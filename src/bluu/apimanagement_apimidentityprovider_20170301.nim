
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Identity Provider entity associated with your Azure API Management deployment. Setting up an external Identity Provider for authentication can help you manage the developer portal logins using the OAuth2 flow.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "apimanagement-apimidentityprovider"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_IdentityProviderList_563778 = ref object of OpenApiRestCall_563556
proc url_IdentityProviderList_563780(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentityProviderList_563779(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of Identity Provider configured in the specified service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-aad#how-to-authorize-developer-accounts-using-azure-active-directory
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563928 = query.getOrDefault("api-version")
  valid_563928 = validateParameter(valid_563928, JString, required = true,
                                 default = nil)
  if valid_563928 != nil:
    section.add "api-version", valid_563928
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563955: Call_IdentityProviderList_563778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of Identity Provider configured in the specified service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-aad#how-to-authorize-developer-accounts-using-azure-active-directory
  let valid = call_563955.validator(path, query, header, formData, body)
  let scheme = call_563955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563955.url(scheme.get, call_563955.host, call_563955.base,
                         call_563955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563955, url, valid)

proc call*(call_564026: Call_IdentityProviderList_563778; apiVersion: string): Recallable =
  ## identityProviderList
  ## Lists a collection of Identity Provider configured in the specified service instance.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-aad#how-to-authorize-developer-accounts-using-azure-active-directory
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_564027 = newJObject()
  add(query_564027, "api-version", newJString(apiVersion))
  result = call_564026.call(nil, query_564027, nil, nil, nil)

var identityProviderList* = Call_IdentityProviderList_563778(
    name: "identityProviderList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/identityProviders", validator: validate_IdentityProviderList_563779,
    base: "", url: url_IdentityProviderList_563780, schemes: {Scheme.Https})
type
  Call_IdentityProviderCreateOrUpdate_564112 = ref object of OpenApiRestCall_563556
proc url_IdentityProviderCreateOrUpdate_564114(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "identityProviderName" in path,
        "`identityProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/identityProviders/"),
               (kind: VariableSegment, value: "identityProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IdentityProviderCreateOrUpdate_564113(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates the IdentityProvider configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   identityProviderName: JString (required)
  ##                       : Identity Provider Type identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `identityProviderName` field"
  var valid_564132 = path.getOrDefault("identityProviderName")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = newJString("facebook"))
  if valid_564132 != nil:
    section.add "identityProviderName", valid_564132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564133 = query.getOrDefault("api-version")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "api-version", valid_564133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564135: Call_IdentityProviderCreateOrUpdate_564112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates the IdentityProvider configuration.
  ## 
  let valid = call_564135.validator(path, query, header, formData, body)
  let scheme = call_564135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564135.url(scheme.get, call_564135.host, call_564135.base,
                         call_564135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564135, url, valid)

proc call*(call_564136: Call_IdentityProviderCreateOrUpdate_564112;
          apiVersion: string; parameters: JsonNode;
          identityProviderName: string = "facebook"): Recallable =
  ## identityProviderCreateOrUpdate
  ## Creates or Updates the IdentityProvider configuration.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   identityProviderName: string (required)
  ##                       : Identity Provider Type identifier.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  var path_564137 = newJObject()
  var query_564138 = newJObject()
  var body_564139 = newJObject()
  add(query_564138, "api-version", newJString(apiVersion))
  add(path_564137, "identityProviderName", newJString(identityProviderName))
  if parameters != nil:
    body_564139 = parameters
  result = call_564136.call(path_564137, query_564138, nil, nil, body_564139)

var identityProviderCreateOrUpdate* = Call_IdentityProviderCreateOrUpdate_564112(
    name: "identityProviderCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/identityProviders/{identityProviderName}",
    validator: validate_IdentityProviderCreateOrUpdate_564113, base: "",
    url: url_IdentityProviderCreateOrUpdate_564114, schemes: {Scheme.Https})
type
  Call_IdentityProviderGet_564067 = ref object of OpenApiRestCall_563556
proc url_IdentityProviderGet_564069(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "identityProviderName" in path,
        "`identityProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/identityProviders/"),
               (kind: VariableSegment, value: "identityProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IdentityProviderGet_564068(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the configuration details of the identity Provider configured in specified service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   identityProviderName: JString (required)
  ##                       : Identity Provider Type identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `identityProviderName` field"
  var valid_564106 = path.getOrDefault("identityProviderName")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = newJString("facebook"))
  if valid_564106 != nil:
    section.add "identityProviderName", valid_564106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564107 = query.getOrDefault("api-version")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "api-version", valid_564107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564108: Call_IdentityProviderGet_564067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration details of the identity Provider configured in specified service instance.
  ## 
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_IdentityProviderGet_564067; apiVersion: string;
          identityProviderName: string = "facebook"): Recallable =
  ## identityProviderGet
  ## Gets the configuration details of the identity Provider configured in specified service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   identityProviderName: string (required)
  ##                       : Identity Provider Type identifier.
  var path_564110 = newJObject()
  var query_564111 = newJObject()
  add(query_564111, "api-version", newJString(apiVersion))
  add(path_564110, "identityProviderName", newJString(identityProviderName))
  result = call_564109.call(path_564110, query_564111, nil, nil, nil)

var identityProviderGet* = Call_IdentityProviderGet_564067(
    name: "identityProviderGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/identityProviders/{identityProviderName}",
    validator: validate_IdentityProviderGet_564068, base: "",
    url: url_IdentityProviderGet_564069, schemes: {Scheme.Https})
type
  Call_IdentityProviderUpdate_564150 = ref object of OpenApiRestCall_563556
proc url_IdentityProviderUpdate_564152(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "identityProviderName" in path,
        "`identityProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/identityProviders/"),
               (kind: VariableSegment, value: "identityProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IdentityProviderUpdate_564151(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing IdentityProvider configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   identityProviderName: JString (required)
  ##                       : Identity Provider Type identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `identityProviderName` field"
  var valid_564163 = path.getOrDefault("identityProviderName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = newJString("facebook"))
  if valid_564163 != nil:
    section.add "identityProviderName", valid_564163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564164 = query.getOrDefault("api-version")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "api-version", valid_564164
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the identity provider configuration to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564165 = header.getOrDefault("If-Match")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "If-Match", valid_564165
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564167: Call_IdentityProviderUpdate_564150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing IdentityProvider configuration.
  ## 
  let valid = call_564167.validator(path, query, header, formData, body)
  let scheme = call_564167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564167.url(scheme.get, call_564167.host, call_564167.base,
                         call_564167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564167, url, valid)

proc call*(call_564168: Call_IdentityProviderUpdate_564150; apiVersion: string;
          parameters: JsonNode; identityProviderName: string = "facebook"): Recallable =
  ## identityProviderUpdate
  ## Updates an existing IdentityProvider configuration.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   identityProviderName: string (required)
  ##                       : Identity Provider Type identifier.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  var path_564169 = newJObject()
  var query_564170 = newJObject()
  var body_564171 = newJObject()
  add(query_564170, "api-version", newJString(apiVersion))
  add(path_564169, "identityProviderName", newJString(identityProviderName))
  if parameters != nil:
    body_564171 = parameters
  result = call_564168.call(path_564169, query_564170, nil, nil, body_564171)

var identityProviderUpdate* = Call_IdentityProviderUpdate_564150(
    name: "identityProviderUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/identityProviders/{identityProviderName}",
    validator: validate_IdentityProviderUpdate_564151, base: "",
    url: url_IdentityProviderUpdate_564152, schemes: {Scheme.Https})
type
  Call_IdentityProviderDelete_564140 = ref object of OpenApiRestCall_563556
proc url_IdentityProviderDelete_564142(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "identityProviderName" in path,
        "`identityProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/identityProviders/"),
               (kind: VariableSegment, value: "identityProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IdentityProviderDelete_564141(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified identity provider configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   identityProviderName: JString (required)
  ##                       : Identity Provider Type identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `identityProviderName` field"
  var valid_564143 = path.getOrDefault("identityProviderName")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = newJString("facebook"))
  if valid_564143 != nil:
    section.add "identityProviderName", valid_564143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564144 = query.getOrDefault("api-version")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "api-version", valid_564144
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the backend to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564145 = header.getOrDefault("If-Match")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "If-Match", valid_564145
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564146: Call_IdentityProviderDelete_564140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified identity provider configuration.
  ## 
  let valid = call_564146.validator(path, query, header, formData, body)
  let scheme = call_564146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564146.url(scheme.get, call_564146.host, call_564146.base,
                         call_564146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564146, url, valid)

proc call*(call_564147: Call_IdentityProviderDelete_564140; apiVersion: string;
          identityProviderName: string = "facebook"): Recallable =
  ## identityProviderDelete
  ## Deletes the specified identity provider configuration.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   identityProviderName: string (required)
  ##                       : Identity Provider Type identifier.
  var path_564148 = newJObject()
  var query_564149 = newJObject()
  add(query_564149, "api-version", newJString(apiVersion))
  add(path_564148, "identityProviderName", newJString(identityProviderName))
  result = call_564147.call(path_564148, query_564149, nil, nil, nil)

var identityProviderDelete* = Call_IdentityProviderDelete_564140(
    name: "identityProviderDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/identityProviders/{identityProviderName}",
    validator: validate_IdentityProviderDelete_564141, base: "",
    url: url_IdentityProviderDelete_564142, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
