
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

  OpenApiRestCall_573658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573658): Option[Scheme] {.used.} =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "apimanagement-apimidentityprovider"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_IdentityProviderList_573880 = ref object of OpenApiRestCall_573658
proc url_IdentityProviderList_573882(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentityProviderList_573881(path: JsonNode; query: JsonNode;
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
  var valid_574028 = query.getOrDefault("api-version")
  valid_574028 = validateParameter(valid_574028, JString, required = true,
                                 default = nil)
  if valid_574028 != nil:
    section.add "api-version", valid_574028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574055: Call_IdentityProviderList_573880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of Identity Provider configured in the specified service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-aad#how-to-authorize-developer-accounts-using-azure-active-directory
  let valid = call_574055.validator(path, query, header, formData, body)
  let scheme = call_574055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574055.url(scheme.get, call_574055.host, call_574055.base,
                         call_574055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574055, url, valid)

proc call*(call_574126: Call_IdentityProviderList_573880; apiVersion: string): Recallable =
  ## identityProviderList
  ## Lists a collection of Identity Provider configured in the specified service instance.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-aad#how-to-authorize-developer-accounts-using-azure-active-directory
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_574127 = newJObject()
  add(query_574127, "api-version", newJString(apiVersion))
  result = call_574126.call(nil, query_574127, nil, nil, nil)

var identityProviderList* = Call_IdentityProviderList_573880(
    name: "identityProviderList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/identityProviders", validator: validate_IdentityProviderList_573881,
    base: "", url: url_IdentityProviderList_573882, schemes: {Scheme.Https})
type
  Call_IdentityProviderCreateOrUpdate_574212 = ref object of OpenApiRestCall_573658
proc url_IdentityProviderCreateOrUpdate_574214(protocol: Scheme; host: string;
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

proc validate_IdentityProviderCreateOrUpdate_574213(path: JsonNode;
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
  var valid_574232 = path.getOrDefault("identityProviderName")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = newJString("facebook"))
  if valid_574232 != nil:
    section.add "identityProviderName", valid_574232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574233 = query.getOrDefault("api-version")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = nil)
  if valid_574233 != nil:
    section.add "api-version", valid_574233
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

proc call*(call_574235: Call_IdentityProviderCreateOrUpdate_574212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates the IdentityProvider configuration.
  ## 
  let valid = call_574235.validator(path, query, header, formData, body)
  let scheme = call_574235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574235.url(scheme.get, call_574235.host, call_574235.base,
                         call_574235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574235, url, valid)

proc call*(call_574236: Call_IdentityProviderCreateOrUpdate_574212;
          apiVersion: string; parameters: JsonNode;
          identityProviderName: string = "facebook"): Recallable =
  ## identityProviderCreateOrUpdate
  ## Creates or Updates the IdentityProvider configuration.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   identityProviderName: string (required)
  ##                       : Identity Provider Type identifier.
  var path_574237 = newJObject()
  var query_574238 = newJObject()
  var body_574239 = newJObject()
  add(query_574238, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_574239 = parameters
  add(path_574237, "identityProviderName", newJString(identityProviderName))
  result = call_574236.call(path_574237, query_574238, nil, nil, body_574239)

var identityProviderCreateOrUpdate* = Call_IdentityProviderCreateOrUpdate_574212(
    name: "identityProviderCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/identityProviders/{identityProviderName}",
    validator: validate_IdentityProviderCreateOrUpdate_574213, base: "",
    url: url_IdentityProviderCreateOrUpdate_574214, schemes: {Scheme.Https})
type
  Call_IdentityProviderGet_574167 = ref object of OpenApiRestCall_573658
proc url_IdentityProviderGet_574169(protocol: Scheme; host: string; base: string;
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

proc validate_IdentityProviderGet_574168(path: JsonNode; query: JsonNode;
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
  var valid_574206 = path.getOrDefault("identityProviderName")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = newJString("facebook"))
  if valid_574206 != nil:
    section.add "identityProviderName", valid_574206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574207 = query.getOrDefault("api-version")
  valid_574207 = validateParameter(valid_574207, JString, required = true,
                                 default = nil)
  if valid_574207 != nil:
    section.add "api-version", valid_574207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574208: Call_IdentityProviderGet_574167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration details of the identity Provider configured in specified service instance.
  ## 
  let valid = call_574208.validator(path, query, header, formData, body)
  let scheme = call_574208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574208.url(scheme.get, call_574208.host, call_574208.base,
                         call_574208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574208, url, valid)

proc call*(call_574209: Call_IdentityProviderGet_574167; apiVersion: string;
          identityProviderName: string = "facebook"): Recallable =
  ## identityProviderGet
  ## Gets the configuration details of the identity Provider configured in specified service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   identityProviderName: string (required)
  ##                       : Identity Provider Type identifier.
  var path_574210 = newJObject()
  var query_574211 = newJObject()
  add(query_574211, "api-version", newJString(apiVersion))
  add(path_574210, "identityProviderName", newJString(identityProviderName))
  result = call_574209.call(path_574210, query_574211, nil, nil, nil)

var identityProviderGet* = Call_IdentityProviderGet_574167(
    name: "identityProviderGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/identityProviders/{identityProviderName}",
    validator: validate_IdentityProviderGet_574168, base: "",
    url: url_IdentityProviderGet_574169, schemes: {Scheme.Https})
type
  Call_IdentityProviderUpdate_574250 = ref object of OpenApiRestCall_573658
proc url_IdentityProviderUpdate_574252(protocol: Scheme; host: string; base: string;
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

proc validate_IdentityProviderUpdate_574251(path: JsonNode; query: JsonNode;
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
  var valid_574263 = path.getOrDefault("identityProviderName")
  valid_574263 = validateParameter(valid_574263, JString, required = true,
                                 default = newJString("facebook"))
  if valid_574263 != nil:
    section.add "identityProviderName", valid_574263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574264 = query.getOrDefault("api-version")
  valid_574264 = validateParameter(valid_574264, JString, required = true,
                                 default = nil)
  if valid_574264 != nil:
    section.add "api-version", valid_574264
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the identity provider configuration to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574265 = header.getOrDefault("If-Match")
  valid_574265 = validateParameter(valid_574265, JString, required = true,
                                 default = nil)
  if valid_574265 != nil:
    section.add "If-Match", valid_574265
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

proc call*(call_574267: Call_IdentityProviderUpdate_574250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing IdentityProvider configuration.
  ## 
  let valid = call_574267.validator(path, query, header, formData, body)
  let scheme = call_574267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574267.url(scheme.get, call_574267.host, call_574267.base,
                         call_574267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574267, url, valid)

proc call*(call_574268: Call_IdentityProviderUpdate_574250; apiVersion: string;
          parameters: JsonNode; identityProviderName: string = "facebook"): Recallable =
  ## identityProviderUpdate
  ## Updates an existing IdentityProvider configuration.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   identityProviderName: string (required)
  ##                       : Identity Provider Type identifier.
  var path_574269 = newJObject()
  var query_574270 = newJObject()
  var body_574271 = newJObject()
  add(query_574270, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_574271 = parameters
  add(path_574269, "identityProviderName", newJString(identityProviderName))
  result = call_574268.call(path_574269, query_574270, nil, nil, body_574271)

var identityProviderUpdate* = Call_IdentityProviderUpdate_574250(
    name: "identityProviderUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/identityProviders/{identityProviderName}",
    validator: validate_IdentityProviderUpdate_574251, base: "",
    url: url_IdentityProviderUpdate_574252, schemes: {Scheme.Https})
type
  Call_IdentityProviderDelete_574240 = ref object of OpenApiRestCall_573658
proc url_IdentityProviderDelete_574242(protocol: Scheme; host: string; base: string;
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

proc validate_IdentityProviderDelete_574241(path: JsonNode; query: JsonNode;
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
  var valid_574243 = path.getOrDefault("identityProviderName")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = newJString("facebook"))
  if valid_574243 != nil:
    section.add "identityProviderName", valid_574243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574244 = query.getOrDefault("api-version")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = nil)
  if valid_574244 != nil:
    section.add "api-version", valid_574244
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the backend to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574245 = header.getOrDefault("If-Match")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "If-Match", valid_574245
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574246: Call_IdentityProviderDelete_574240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified identity provider configuration.
  ## 
  let valid = call_574246.validator(path, query, header, formData, body)
  let scheme = call_574246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574246.url(scheme.get, call_574246.host, call_574246.base,
                         call_574246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574246, url, valid)

proc call*(call_574247: Call_IdentityProviderDelete_574240; apiVersion: string;
          identityProviderName: string = "facebook"): Recallable =
  ## identityProviderDelete
  ## Deletes the specified identity provider configuration.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   identityProviderName: string (required)
  ##                       : Identity Provider Type identifier.
  var path_574248 = newJObject()
  var query_574249 = newJObject()
  add(query_574249, "api-version", newJString(apiVersion))
  add(path_574248, "identityProviderName", newJString(identityProviderName))
  result = call_574247.call(path_574248, query_574249, nil, nil, nil)

var identityProviderDelete* = Call_IdentityProviderDelete_574240(
    name: "identityProviderDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/identityProviders/{identityProviderName}",
    validator: validate_IdentityProviderDelete_574241, base: "",
    url: url_IdentityProviderDelete_574242, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
