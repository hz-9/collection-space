<template>
  <div>
    <table class="table">
      <thead>
        <tr>
          <th class="left">Type</th>
          <th>Description</th>
        </tr>
      </thead>

      <tbody>
        <tr>
          <td class="left">
            <RouterLink to="/cors">CORS</RouterLink>
          </td>
          <td>
            Cross-Origin Resource Sharing (CORS) is a mechanism that allows browsers to request
            resources from a different origin.
          </td>
        </tr>
        <tr>
          <td class="left">
            <RouterLink to="/proxy">Proxy</RouterLink>
          </td>
          <td>
            A proxy server acts as an intermediary, forwarding requests and responses to enable
            cross-origin access.
          </td>
        </tr>
        <tr>
          <td class="left">
            <RouterLink to="/jsonp">Jsonp</RouterLink>
          </td>
          <td>
            JSONP is a technique that uses dynamically inserted script tags to make cross-origin
            requests.
          </td>
        </tr>
        <tr>
          <td class="left">
            <RouterLink to="/post-message">postMessage</RouterLink>
          </td>
          <td>
            The postMessage method allows for safe cross-origin communication between Window
            objects.
          </td>
        </tr>
        <tr>
          <td class="left">
            <RouterLink to="/document-domain">document.domain</RouterLink>
          </td>
          <td>
            Setting document.domain to the same value in different windows allows for cross-origin
            communication within the same top-level domain.
          </td>
        </tr>
        <tr>
          <td class="left">
            <RouterLink to="/window-name">window.name</RouterLink>
          </td>
          <td>
            The window.name property can be used to share data between different origins by
            navigating between them.
          </td>
        </tr>
        <tr>
          <td class="left">
            <RouterLink to="/location-hash">location.hash</RouterLink>
          </td>
          <td>
            Using the location.hash property, different windows can communicate by changing the URL
            fragment identifier.
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<style scoped>
.table {
  width: 100%;
  /* border-collapse: collapse; */
  /* border-spacing: 1px; */
  margin-top: 2rem;
  border-collapse: collapse;
  border: 1px solid var(--color-border);
}

.table th,
.table td {
  background-color: var(--color-bg);
  color: var(--color-text);
  /* font-weight: 400; */
  padding: 0.5rem 1rem;
  text-align: left;
}

.table th {
  font-weight: 700;
}

.table tr {
  border-bottom: 1px solid var(--color-border);
}

.left {
  width: 200px;
  text-align: left;
  padding: 0.5rem 1rem;
  border-right: 1px solid var(--color-border);
}
</style>
