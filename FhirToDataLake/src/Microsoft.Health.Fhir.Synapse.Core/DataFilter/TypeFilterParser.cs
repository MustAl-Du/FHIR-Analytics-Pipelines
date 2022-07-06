﻿// -------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License (MIT). See LICENSE in the repo root for license information.
// -------------------------------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.Linq;
using EnsureThat;
using Microsoft.Extensions.Logging;
using Microsoft.Health.Fhir.Synapse.Common.Exceptions;
using Microsoft.Health.Fhir.Synapse.Common.Models.FhirSearch;
using Microsoft.Health.Fhir.Synapse.Common.Models.Jobs;
using Microsoft.Health.Fhir.Synapse.Core.Fhir;
using Microsoft.Health.Fhir.Synapse.DataClient.Api;

namespace Microsoft.Health.Fhir.Synapse.Core.DataFilter
{
    public class TypeFilterParser : ITypeFilterParser
    {
        private readonly ILogger<TypeFilterParser> _logger;
        private readonly IFhirSpecificationProvider _fhirSpecificationProvider;

        public TypeFilterParser(
            IFhirSpecificationProvider fhirSpecificationProvider,
            ILogger<TypeFilterParser> logger)
        {
            EnsureArg.IsNotNull(fhirSpecificationProvider, nameof(fhirSpecificationProvider));
            EnsureArg.IsNotNull(logger, nameof(logger));

            _fhirSpecificationProvider = fhirSpecificationProvider;
            _logger = logger;
        }

        public IEnumerable<TypeFilter> CreateTypeFilters(
            FilterScope filterScope,
            string typeString,
            string filterString)
        {
            var requiredTypes = ParseType(filterScope, typeString).ToHashSet();
            var typeFilters = ParseTypeFilter(filterString).ToList();

            ValidateTypeFilters(requiredTypes, typeFilters);

            // Generate base type filters for the types without typeFilters,
            // so dataClient can handle all the cases with a unify interface.
            var filteredTypes = new HashSet<string>();
            foreach (var filter in typeFilters)
            {
                filteredTypes.Add(filter.ResourceType);
            }

            var nonFilterTypes = requiredTypes.Where(x => !filteredTypes.Contains(x)).ToList();

            if (nonFilterTypes.Any())
            {
                switch (filterScope)
                {
                    // For system filter scope, generate a typeFilter for each resource type
                    case FilterScope.System:
                        typeFilters.AddRange(nonFilterTypes.Select(type => new TypeFilter(type, null)));
                        break;

                    // For group filter scope, just generate a typeFilter for all the resource types
                    case FilterScope.Group:
                        List<Tuple<string, string>> parameters = null;

                        // if both typeString and filterString aren't specified, the request url is "https://{fhirURL}/Patient/{patientId}/*"
                        // otherwise, the request url is "https://{fhirURL}/Patient/{patientId}/*?_type={nonFilterTypes}"
                        if (!string.IsNullOrWhiteSpace(typeString) || !string.IsNullOrWhiteSpace(filterString))
                        {
                            parameters = new List<Tuple<string, string>> { new (FhirApiConstants.TypeKey, string.Join(',', nonFilterTypes)) };
                        }

                        typeFilters.Add(new TypeFilter(FhirConstants.AllResource, parameters));
                        break;
                    default:
                        // this case should not happen
                        throw new ConfigurationErrorException($"The filterScope {filterScope} isn't supported now");
                }
            }

            _logger.LogInformation($"Create TypeFilters successfully, there are {typeFilters.Count} TypeFilters created.");
            return typeFilters;
        }

        /// <summary>
        /// Parse the type configuration from a string to a list of resource types.
        /// If the type is null or empty, return all resource types for system filter scope and return patient compartment resource types for group filter scope.
        /// If the type isn't supported, will throw an exception.
        /// Duplicated types
        /// </summary>
        /// <param name="filterScope">filter scope.</param>
        /// <param name="typeString">type string.</param>
        /// <returns>a list of resource type.</returns>
        private IEnumerable<string> ParseType(FilterScope filterScope, string typeString)
        {
            var supportedResourceTypes = filterScope switch
            {
                FilterScope.System => _fhirSpecificationProvider.GetAllResourceTypes().ToHashSet(),
                FilterScope.Group => _fhirSpecificationProvider.GetCompartmentResourceTypes(FhirConstants.PatientResource).ToHashSet(),
                _ => throw new ConfigurationErrorException($"The FilterScope {filterScope} isn't supported now.")
            };

            if (string.IsNullOrWhiteSpace(typeString))
            {
                _logger.LogDebug($"The required resource type string is null, empty or white space, all the resource types will be handled.");
                return supportedResourceTypes;
            }

            // TODO: trim space for each type?
            var types = typeString?.Split(',').ToHashSet();

            // validate if invalid Fhir resource types
            var invalidFhirResourceTypes =
                types.Where(type => !_fhirSpecificationProvider.IsValidFhirResourceType(type)).ToList();
            if (invalidFhirResourceTypes.Any())
            {
                _logger.LogError($"The required resource types \"{string.Join(',', invalidFhirResourceTypes)}\" aren't valid resource types.");
                throw new ConfigurationErrorException(
                    $"The required resource types \"{string.Join(',', invalidFhirResourceTypes)}\" aren't valid resource types.");
            }

            // validate if unsupported resource types
            var unsupportedTypes = types.Where(type => !supportedResourceTypes.Contains(type)).ToList();
            if (unsupportedTypes.Any())
            {
                _logger.LogError($"The required resource types \"{string.Join(',', unsupportedTypes)}\" aren't supported for scope {filterScope}.");
                throw new ConfigurationErrorException(
                    $"The required resource types \"{string.Join(',', unsupportedTypes)}\" aren't supported for scope {filterScope}.");
            }

            return types;
        }

        /// <summary>
        /// Parses the typeFilter configuration from a string into a list of <see cref="TypeFilter"/> objects.
        /// </summary>
        /// <param name="filterString">The typeFilter parameter input.</param>
        /// <returns>A list of <see cref="TypeFilter"/></returns>
        private IEnumerable<TypeFilter> ParseTypeFilter(string filterString)
        {
            var filters = new List<TypeFilter>();

            if (string.IsNullOrWhiteSpace(filterString))
            {
                _logger.LogDebug($"The type filter string is null, empty or white space.");
                return filters;
            }

            var filterArray = filterString.Split(",");

            // the filter format sample is
            // "MedicationRequest?status=completed&date=gt2018-07-01T00:00:00Z"
            foreach (var filter in filterArray)
            {
                var parameterIndex = filter.IndexOf("?", StringComparison.Ordinal);

                if (parameterIndex <= 0 || parameterIndex == filter.Length - 1)
                {
                    _logger.LogError($"The typeFilter segment '{filter}' could not be parsed.");
                    throw new ConfigurationErrorException(
                        $"The typeFilter segment '{filter}' could not be parsed.");
                }

                var filterType = filter.Substring(0, parameterIndex);

                var filterParameters = filter.Substring(parameterIndex + 1).Split("&");
                var parameterTupleList = new List<Tuple<string, string>>();

                foreach (var parameter in filterParameters)
                {
                    var keyValue = parameter.Split("=");

                    if (keyValue.Length != 2)
                    {
                        _logger.LogError($"The typeFilter segment '{filter}' could not be parsed.");
                        throw new ConfigurationErrorException(
                            $"The typeFilter segment '{filter}' could not be parsed.");
                    }

                    parameterTupleList.Add(new Tuple<string, string>(keyValue[0], keyValue[1]));
                }

                filters.Add(new TypeFilter(filterType, parameterTupleList));
            }

            return filters;
        }

        /// <summary>
        /// Validate typeFilters:
        /// 1. The resource type in typeFilter should be in the required types.
        /// 2. The search parameters are supported for this resource type.
        /// </summary>
        private void ValidateTypeFilters(HashSet<string> requiredTypes, List<TypeFilter> typeFilters)
        {
            EnsureArg.IsNotNull(requiredTypes, nameof(requiredTypes));
            EnsureArg.IsNotNull(typeFilters, nameof(typeFilters));

            foreach (var typeFilter in typeFilters)
            {
                // The resource type in typeFilter should be in the required types.
                if (!requiredTypes.Contains(typeFilter.ResourceType))
                {
                    _logger.LogError($"The resource type {typeFilter.ResourceType} in typeFilter isn't in the required types.");
                    throw new ConfigurationErrorException($"The resource type {typeFilter.ResourceType} in typeFilter isn't in the required types.");
                }

                // Validate search parameters
                var supportedSearchParam = _fhirSpecificationProvider
                    .GetSearchParametersByResourceType(typeFilter.ResourceType).ToHashSet();
                foreach (var (param, _) in typeFilter.Parameters)
                {
                    var splitParams = param.Split(':', '.');
                    var paramName = splitParams[0];

                    // the parameter name should be the supported parameter of this resource type.
                    if (paramName != "_has" && !supportedSearchParam.Contains(paramName))
                    {
                        _logger.LogError($"The search parameter {paramName} isn't supported by resource type {typeFilter.ResourceType}.");
                        throw new ConfigurationErrorException(
                            $"The search parameter {paramName} isn't supported by resource type {typeFilter.ResourceType}.");
                    }

                    // TODO: validate modifier/reverse chaining/chained
                    // Reverse Chaining sample
                    // GET [base]/Patient?_has:Observation:patient:code=1234-5
                    // Chained parameters sample
                    // GET [base]/DiagnosticReport?subject:Patient.name=peter
                }
            }
        }
    }
}
