﻿// -------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License (MIT). See LICENSE in the repo root for license information.
// -------------------------------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.IO;
using System.Threading;
using System.Threading.Tasks;

namespace Microsoft.Health.Fhir.Synapse.Azure.Blob
{
    public interface IAzureBlobContainerClient
    {
        /// <summary>
        /// Whether a blob exists.
        /// </summary>
        /// <param name="blobName">name of blob.</param>
        /// <param name="cancellationToken">cancellation token.</param>
        /// <returns>true if blob exists, otherwise return false.</returns>
        public Task<bool> BlobExistsAsync(
            string blobName,
            CancellationToken cancellationToken);

        /// <summary>
        /// List blob with specific prefix.
        /// </summary>
        /// <param name="blobPrefix">blob prefix.</param>
        /// <param name="cancellationToken">cancellation token.</param>
        /// <returns>blob name list.</returns>
        public Task<IEnumerable<string>> ListBlobsAsync(
            string blobPrefix,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Create a new blob. Returns false if the blob already exists.
        /// </summary>
        /// <param name="blobName">The blob name to create.</param>
        /// <param name="stream">blob content.</param>
        /// <param name="cancellationToken">cancellation token.</param>
        /// <returns>whether operation succeeds.</returns>
        public Task<bool> CreateBlobAsync(
            string blobName,
            Stream stream,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Get a blob content.
        /// </summary>
        /// <param name="blobName">blob name.</param>
        /// <param name="cancellationToken">cancellation token.</param>
        /// <returns>blob content.</returns>
        public Task<Stream> GetBlobAsync(
            string blobName,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Delete a blob.
        /// </summary>
        /// <param name="blobName">blob name to delete.</param>
        /// <param name="cancellationToken">cancellation token.</param>
        /// <returns>whether delete succeeds.</returns>
        public Task<bool> DeleteBlobAsync(
            string blobName,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Update blob.
        /// </summary>
        /// <param name="blobName">blob name.</param>
        /// <param name="stream">data to upload.</param>
        /// <param name="cancellationToken">cancellation token.</param>
        /// <returns>blob url.</returns>
        public Task<string> UpdateBlobAsync(
            string blobName,
            Stream stream,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Acquire lease for a blob.
        /// </summary>
        /// <param name="blobName">blob name.</param>
        /// <param name="leaseId">lease id.</param>
        /// <param name="timeSpan">time span for lease.</param>
        /// <param name="cancellationToken">cancellation token.</param>
        /// <returns>Lease id.</returns>
        public Task<string> AcquireLeaseAsync(
            string blobName,
            string leaseId,
            TimeSpan timeSpan,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Release lease for a blob.
        /// </summary>
        /// <param name="blobName">blob name.</param>
        /// <param name="leaseId">lease id.</param>
        /// <param name="cancellationToken">cancellation token.</param>
        /// <returns>operation result.</returns>
        public Task<bool> ReleaseLeaseAsync(
            string blobName,
            string leaseId,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Renew lease for a blob.
        /// </summary>
        /// <param name="blobName">blob name.</param>
        /// <param name="leaseId">lease id.</param>
        /// <param name="cancellationToken">cancellation token.</param>
        /// <returns>renewed lease id.</returns>
        public Task<string> RenewLeaseAsync(
            string blobName,
            string leaseId,
            CancellationToken cancellationToken = default);
    }
}
