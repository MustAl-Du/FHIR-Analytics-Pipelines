﻿// -------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License (MIT). See LICENSE in the repo root for license information.
// -------------------------------------------------------------------------------------------------

using System.Collections.Generic;

namespace Microsoft.Health.Fhir.Synapse.DataClient.Models.SearchOption
{

    public class BaseSearchOptions
    {
        public BaseSearchOptions(
            string resourceType,
            List<KeyValuePair<string, string>> queryParameters)
        {
            ResourceType = resourceType;
            QueryParameters = queryParameters ?? new List<KeyValuePair<string, string>>();
        }

        public string ResourceType { get; set; }

        public List<KeyValuePair<string, string>> QueryParameters { get; set; }

        public virtual string RelativeUri()
        {
            return ResourceType;
        }
    }
}
