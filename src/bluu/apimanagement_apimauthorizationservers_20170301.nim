
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
  macServiceName = "apimanagement-apimauthorizationservers"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AuthorizationServerList_563778 = ref object of OpenApiRestCall_563556
proc url_AuthorizationServerList_563780(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AuthorizationServerList_563779(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of authorization servers defined within a service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Number of records to return.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | id    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  var valid_563929 = query.getOrDefault("$top")
  valid_563929 = validateParameter(valid_563929, JInt, required = false, default = nil)
  if valid_563929 != nil:
    section.add "$top", valid_563929
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563930 = query.getOrDefault("api-version")
  valid_563930 = validateParameter(valid_563930, JString, required = true,
                                 default = nil)
  if valid_563930 != nil:
    section.add "api-version", valid_563930
  var valid_563931 = query.getOrDefault("$skip")
  valid_563931 = validateParameter(valid_563931, JInt, required = false, default = nil)
  if valid_563931 != nil:
    section.add "$skip", valid_563931
  var valid_563932 = query.getOrDefault("$filter")
  valid_563932 = validateParameter(valid_563932, JString, required = false,
                                 default = nil)
  if valid_563932 != nil:
    section.add "$filter", valid_563932
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563959: Call_AuthorizationServerList_563778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of authorization servers defined within a service instance.
  ## 
  let valid = call_563959.validator(path, query, header, formData, body)
  let scheme = call_563959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563959.url(scheme.get, call_563959.host, call_563959.base,
                         call_563959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563959, url, valid)

proc call*(call_564030: Call_AuthorizationServerList_563778; apiVersion: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## authorizationServerList
  ## Lists a collection of authorization servers defined within a service instance.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string
  ##         : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | id    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var query_564031 = newJObject()
  add(query_564031, "$top", newJInt(Top))
  add(query_564031, "api-version", newJString(apiVersion))
  add(query_564031, "$skip", newJInt(Skip))
  add(query_564031, "$filter", newJString(Filter))
  result = call_564030.call(nil, query_564031, nil, nil, nil)

var authorizationServerList* = Call_AuthorizationServerList_563778(
    name: "authorizationServerList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/authorizationServers", validator: validate_AuthorizationServerList_563779,
    base: "", url: url_AuthorizationServerList_563780, schemes: {Scheme.Https})
type
  Call_AuthorizationServerCreateOrUpdate_564103 = ref object of OpenApiRestCall_563556
proc url_AuthorizationServerCreateOrUpdate_564105(protocol: Scheme; host: string;
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

proc validate_AuthorizationServerCreateOrUpdate_564104(path: JsonNode;
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
  var valid_564123 = path.getOrDefault("authsid")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "authsid", valid_564123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564124 = query.getOrDefault("api-version")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "api-version", valid_564124
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

proc call*(call_564126: Call_AuthorizationServerCreateOrUpdate_564103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new authorization server or updates an existing authorization server.
  ## 
  let valid = call_564126.validator(path, query, header, formData, body)
  let scheme = call_564126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564126.url(scheme.get, call_564126.host, call_564126.base,
                         call_564126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564126, url, valid)

proc call*(call_564127: Call_AuthorizationServerCreateOrUpdate_564103;
          apiVersion: string; authsid: string; parameters: JsonNode): Recallable =
  ## authorizationServerCreateOrUpdate
  ## Creates new authorization server or updates an existing authorization server.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   authsid: string (required)
  ##          : Identifier of the authorization server.
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  var path_564128 = newJObject()
  var query_564129 = newJObject()
  var body_564130 = newJObject()
  add(query_564129, "api-version", newJString(apiVersion))
  add(path_564128, "authsid", newJString(authsid))
  if parameters != nil:
    body_564130 = parameters
  result = call_564127.call(path_564128, query_564129, nil, nil, body_564130)

var authorizationServerCreateOrUpdate* = Call_AuthorizationServerCreateOrUpdate_564103(
    name: "authorizationServerCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/authorizationServers/{authsid}",
    validator: validate_AuthorizationServerCreateOrUpdate_564104, base: "",
    url: url_AuthorizationServerCreateOrUpdate_564105, schemes: {Scheme.Https})
type
  Call_AuthorizationServerGet_564071 = ref object of OpenApiRestCall_563556
proc url_AuthorizationServerGet_564073(protocol: Scheme; host: string; base: string;
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

proc validate_AuthorizationServerGet_564072(path: JsonNode; query: JsonNode;
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
  var valid_564097 = path.getOrDefault("authsid")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "authsid", valid_564097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564098 = query.getOrDefault("api-version")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "api-version", valid_564098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564099: Call_AuthorizationServerGet_564071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the authorization server specified by its identifier.
  ## 
  let valid = call_564099.validator(path, query, header, formData, body)
  let scheme = call_564099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564099.url(scheme.get, call_564099.host, call_564099.base,
                         call_564099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564099, url, valid)

proc call*(call_564100: Call_AuthorizationServerGet_564071; apiVersion: string;
          authsid: string): Recallable =
  ## authorizationServerGet
  ## Gets the details of the authorization server specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   authsid: string (required)
  ##          : Identifier of the authorization server.
  var path_564101 = newJObject()
  var query_564102 = newJObject()
  add(query_564102, "api-version", newJString(apiVersion))
  add(path_564101, "authsid", newJString(authsid))
  result = call_564100.call(path_564101, query_564102, nil, nil, nil)

var authorizationServerGet* = Call_AuthorizationServerGet_564071(
    name: "authorizationServerGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/authorizationServers/{authsid}",
    validator: validate_AuthorizationServerGet_564072, base: "",
    url: url_AuthorizationServerGet_564073, schemes: {Scheme.Https})
type
  Call_AuthorizationServerUpdate_564141 = ref object of OpenApiRestCall_563556
proc url_AuthorizationServerUpdate_564143(protocol: Scheme; host: string;
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

proc validate_AuthorizationServerUpdate_564142(path: JsonNode; query: JsonNode;
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
  var valid_564154 = path.getOrDefault("authsid")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "authsid", valid_564154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564155 = query.getOrDefault("api-version")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "api-version", valid_564155
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the authorization server to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564156 = header.getOrDefault("If-Match")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "If-Match", valid_564156
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

proc call*(call_564158: Call_AuthorizationServerUpdate_564141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the authorization server specified by its identifier.
  ## 
  let valid = call_564158.validator(path, query, header, formData, body)
  let scheme = call_564158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564158.url(scheme.get, call_564158.host, call_564158.base,
                         call_564158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564158, url, valid)

proc call*(call_564159: Call_AuthorizationServerUpdate_564141; apiVersion: string;
          authsid: string; parameters: JsonNode): Recallable =
  ## authorizationServerUpdate
  ## Updates the details of the authorization server specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   authsid: string (required)
  ##          : Identifier of the authorization server.
  ##   parameters: JObject (required)
  ##             : OAuth2 Server settings Update parameters.
  var path_564160 = newJObject()
  var query_564161 = newJObject()
  var body_564162 = newJObject()
  add(query_564161, "api-version", newJString(apiVersion))
  add(path_564160, "authsid", newJString(authsid))
  if parameters != nil:
    body_564162 = parameters
  result = call_564159.call(path_564160, query_564161, nil, nil, body_564162)

var authorizationServerUpdate* = Call_AuthorizationServerUpdate_564141(
    name: "authorizationServerUpdate", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/authorizationServers/{authsid}",
    validator: validate_AuthorizationServerUpdate_564142, base: "",
    url: url_AuthorizationServerUpdate_564143, schemes: {Scheme.Https})
type
  Call_AuthorizationServerDelete_564131 = ref object of OpenApiRestCall_563556
proc url_AuthorizationServerDelete_564133(protocol: Scheme; host: string;
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

proc validate_AuthorizationServerDelete_564132(path: JsonNode; query: JsonNode;
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
  var valid_564134 = path.getOrDefault("authsid")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "authsid", valid_564134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564135 = query.getOrDefault("api-version")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "api-version", valid_564135
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the authentication server to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564136 = header.getOrDefault("If-Match")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "If-Match", valid_564136
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564137: Call_AuthorizationServerDelete_564131; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific authorization server instance.
  ## 
  let valid = call_564137.validator(path, query, header, formData, body)
  let scheme = call_564137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564137.url(scheme.get, call_564137.host, call_564137.base,
                         call_564137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564137, url, valid)

proc call*(call_564138: Call_AuthorizationServerDelete_564131; apiVersion: string;
          authsid: string): Recallable =
  ## authorizationServerDelete
  ## Deletes specific authorization server instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   authsid: string (required)
  ##          : Identifier of the authorization server.
  var path_564139 = newJObject()
  var query_564140 = newJObject()
  add(query_564140, "api-version", newJString(apiVersion))
  add(path_564139, "authsid", newJString(authsid))
  result = call_564138.call(path_564139, query_564140, nil, nil, nil)

var authorizationServerDelete* = Call_AuthorizationServerDelete_564131(
    name: "authorizationServerDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/authorizationServers/{authsid}",
    validator: validate_AuthorizationServerDelete_564132, base: "",
    url: url_AuthorizationServerDelete_564133, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
