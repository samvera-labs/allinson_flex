export function saveData(options) {
  let path = options.path
  let method = options.method ? options.method : 'get'
  let data = { allinson_flex_profile: { data: options.data, schema: options.schema } }
  data = Object.assign({}, data, {})

  fetch(path, {
    method: method,
    body: JSON.stringify(data),
    headers: {
      'X-CSRF-Token': document.querySelector('[name=csrf-token]').content,
      'Content-Type': 'application/json'
    }
  })
    .then((res) => res)
    .then(options.success)
    .catch(options.fail)
}
