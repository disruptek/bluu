
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for managing OAuth2 servers configuration in your Azure API Management deployment. OAuth 2.0 can be used to authorize developer accounts for Azure API Management. For more information refer to [How to OAuth2](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-oauth2).
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
  macServiceName = "apimanagement-apimauthorizationservers"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AuthorizationServerList_573880 = ref object of OpenApiRestCall_573658
proc url_AuthorizationServerList_573882(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AuthorizationServerList_573881(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of authorization servers defined within a service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | id    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574029 = query.getOrDefault("api-version")
  valid_574029 = validateParameter(valid_574029, JString, required = true,
                                 default = nil)
  if valid_574029 != nil:
    section.add "api-version", valid_574029
  var valid_574030 = query.getOrDefault("$top")
  valid_574030 = validateParameter(valid_574030, JInt, required = false, default = nil)
  if valid_574030 != nil:
    section.add "$top", valid_574030
  var valid_574031 = query.getOrDefault("$skip")
  valid_574031 = validateParameter(valid_574031, JInt, required = false, default = nil)
  if valid_574031 != nil:
    section.add "$skip", valid_574031
  var valid_574032 = query.getOrDefault("$filter")
  valid_574032 = validateParameter(valid_574032, JString, required = false,
                                 default = nil)
  if valid_574032 != nil:
    section.add "$filter", valid_574032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574059: Call_AuthorizationServerList_573880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of authorization servers defined within a service instance.
  ## 
  let valid = call_574059.validator(path, query, header, formData, body)
  let scheme = call_574059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574059.url(scheme.get, call_574059.host, call_574059.base,
                         call_574059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574059, url, valid)

proc call*(call_574130: Call_AuthorizationServerList_573880; apiVersion: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## authorizationServerList
  ## Lists a collection of authorization servers defined within a service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string
  ##         : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | id    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var query_574131 = newJObject()
  add(query_574131, "api-version", newJString(apiVersion))
  add(query_574131, "$top", newJInt(Top))
  add(query_574131, "$skip", newJInt(Skip))
  add(query_574131, "$filter", newJString(Filter))
  result = call_574130.call(nil, query_574131, nil, nil, nil)

var authorizationServerList* = Call_AuthorizationServerList_573880(
    name: "authorizationServerList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/authorizationServers", validator: validate_AuthorizationServerList_573881,
    base: "", url: url_AuthorizationServerList_573882, schemes: {Scheme.Https})
type
  Call_AuthorizationServerCreateOrUpdate_574203 = ref object of OpenApiRestCall_573658
proc url_AuthorizationServerCreateOrUpdate_574205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "authsid" in path, "`authsid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/authorizationServers/"),
               (kind: VariableSegment, value: "authsid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AuthorizationServerCreateOrUpdate_574204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates new authorization server or updates an existing authorization server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authsid: JString (required)
  ##          : Identifier of the authorization server.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authsid` field"
  var valid_574223 = path.getOrDefault("authsid")
  valid_574223 = validateParameter(valid_574223, JString, required = true,
                                 default = nil)
  if valid_574223 != nil:
    section.add "authsid", valid_574223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574224 = query.getOrDefault("api-version")
  valid_574224 = validateParameter(valid_574224, JString, required = true,
                                 default = nil)
  if valid_574224 != nil:
    section.add "api-version", valid_574224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574226: Call_AuthorizationServerCreateOrUpdate_574203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new authorization server or updates an existing authorization server.
  ## 
  let valid = call_574226.validator(path, query, header, formData, body)
  let scheme = call_574226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574226.url(scheme.get, call_574226.host, call_574226.base,
                         call_574226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574226, url, valid)

proc call*(call_574227: Call_AuthorizationServerCreateOrUpdate_574203;
          apiVersion: string; authsid: string; parameters: JsonNode): Recallable =
  ## authorizationServerCreateOrUpdate
  ## Creates new authorization server or updates an existing authorization server.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   authsid: string (required)
  ##          : Identifier of the authorization server.
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  var path_574228 = newJObject()
  var query_574229 = newJObject()
  var body_574230 = newJObject()
  add(query_574229, "api-version", newJString(apiVersion))
  add(path_574228, "authsid", newJString(authsid))
  if parameters != nil:
    body_574230 = parameters
  result = call_574227.call(path_574228, query_574229, nil, nil, body_574230)

var authorizationServerCreateOrUpdate* = Call_AuthorizationServerCreateOrUpdate_574203(
    name: "authorizationServerCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/authorizationServers/{authsid}",
    validator: validate_AuthorizationServerCreateOrUpdate_574204, base: "",
    url: url_AuthorizationServerCreateOrUpdate_574205, schemes: {Scheme.Https})
type
  Call_AuthorizationServerGet_574171 = ref object of OpenApiRestCall_573658
proc url_AuthorizationServerGet_574173(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "authsid" in path, "`authsid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/authorizationServers/"),
               (kind: VariableSegment, value: "authsid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AuthorizationServerGet_574172(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the authorization server specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authsid: JString (required)
  ##          : Identifier of the authorization server.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authsid` field"
  var valid_574197 = path.getOrDefault("authsid")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "authsid", valid_574197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574198 = query.getOrDefault("api-version")
  valid_574198 = validateParameter(valid_574198, JString, required = true,
                                 default = nil)
  if valid_574198 != nil:
    section.add "api-version", valid_574198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574199: Call_AuthorizationServerGet_574171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the authorization server specified by its identifier.
  ## 
  let valid = call_574199.validator(path, query, header, formData, body)
  let scheme = call_574199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574199.url(scheme.get, call_574199.host, call_574199.base,
                         call_574199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574199, url, valid)

proc call*(call_574200: Call_AuthorizationServerGet_574171; apiVersion: string;
          authsid: string): Recallable =
  ## authorizationServerGet
  ## Gets the details of the authorization server specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   authsid: string (required)
  ##          : Identifier of the authorization server.
  var path_574201 = newJObject()
  var query_574202 = newJObject()
  add(query_574202, "api-version", newJString(apiVersion))
  add(path_574201, "authsid", newJString(authsid))
  result = call_574200.call(path_574201, query_574202, nil, nil, nil)

var authorizationServerGet* = Call_AuthorizationServerGet_574171(
    name: "authorizationServerGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/authorizationServers/{authsid}",
    validator: validate_AuthorizationServerGet_574172, base: "",
    url: url_AuthorizationServerGet_574173, schemes: {Scheme.Https})
type
  Call_AuthorizationServerUpdate_574241 = ref object of OpenApiRestCall_573658
proc url_AuthorizationServerUpdate_574243(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "authsid" in path, "`authsid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/authorizationServers/"),
               (kind: VariableSegment, value: "authsid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AuthorizationServerUpdate_574242(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of the authorization server specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authsid: JString (required)
  ##          : Identifier of the authorization server.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authsid` field"
  var valid_574254 = path.getOrDefault("authsid")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = nil)
  if valid_574254 != nil:
    section.add "authsid", valid_574254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574255 = query.getOrDefault("api-version")
  valid_574255 = validateParameter(valid_574255, JString, required = true,
                                 default = nil)
  if valid_574255 != nil:
    section.add "api-version", valid_574255
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the authorization server to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574256 = header.getOrDefault("If-Match")
  valid_574256 = validateParameter(valid_574256, JString, required = true,
                                 default = nil)
  if valid_574256 != nil:
    section.add "If-Match", valid_574256
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : OAuth2 Server settings Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574258: Call_AuthorizationServerUpdate_574241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the authorization server specified by its identifier.
  ## 
  let valid = call_574258.validator(path, query, header, formData, body)
  let scheme = call_574258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574258.url(scheme.get, call_574258.host, call_574258.base,
                         call_574258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574258, url, valid)

proc call*(call_574259: Call_AuthorizationServerUpdate_574241; apiVersion: string;
          authsid: string; parameters: JsonNode): Recallable =
  ## authorizationServerUpdate
  ## Updates the details of the authorization server specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   authsid: string (required)
  ##          : Identifier of the authorization server.
  ##   parameters: JObject (required)
  ##             : OAuth2 Server settings Update parameters.
  var path_574260 = newJObject()
  var query_574261 = newJObject()
  var body_574262 = newJObject()
  add(query_574261, "api-version", newJString(apiVersion))
  add(path_574260, "authsid", newJString(authsid))
  if parameters != nil:
    body_574262 = parameters
  result = call_574259.call(path_574260, query_574261, nil, nil, body_574262)

var authorizationServerUpdate* = Call_AuthorizationServerUpdate_574241(
    name: "authorizationServerUpdate", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/authorizationServers/{authsid}",
    validator: validate_AuthorizationServerUpdate_574242, base: "",
    url: url_AuthorizationServerUpdate_574243, schemes: {Scheme.Https})
type
  Call_AuthorizationServerDelete_574231 = ref object of OpenApiRestCall_573658
proc url_AuthorizationServerDelete_574233(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "authsid" in path, "`authsid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/authorizationServers/"),
               (kind: VariableSegment, value: "authsid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AuthorizationServerDelete_574232(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specific authorization server instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authsid: JString (required)
  ##          : Identifier of the authorization server.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authsid` field"
  var valid_574234 = path.getOrDefault("authsid")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "authsid", valid_574234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574235 = query.getOrDefault("api-version")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "api-version", valid_574235
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the authentication server to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574236 = header.getOrDefault("If-Match")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "If-Match", valid_574236
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574237: Call_AuthorizationServerDelete_574231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific authorization server instance.
  ## 
  let valid = call_574237.validator(path, query, header, formData, body)
  let scheme = call_574237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574237.url(scheme.get, call_574237.host, call_574237.base,
                         call_574237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574237, url, valid)

proc call*(call_574238: Call_AuthorizationServerDelete_574231; apiVersion: string;
          authsid: string): Recallable =
  ## authorizationServerDelete
  ## Deletes specific authorization server instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   authsid: string (required)
  ##          : Identifier of the authorization server.
  var path_574239 = newJObject()
  var query_574240 = newJObject()
  add(query_574240, "api-version", newJString(apiVersion))
  add(path_574239, "authsid", newJString(authsid))
  result = call_574238.call(path_574239, query_574240, nil, nil, nil)

var authorizationServerDelete* = Call_AuthorizationServerDelete_574231(
    name: "authorizationServerDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/authorizationServers/{authsid}",
    validator: validate_AuthorizationServerDelete_574232, base: "",
    url: url_AuthorizationServerDelete_574233, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
