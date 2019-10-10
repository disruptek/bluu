
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on logger entity Azure API Management deployment.The Logger entity in API Management represents an event sink that you can use to log API Management events. Currently the Logger entity supports logging API Management events to Azure EventHub.
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimloggers"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LoggerList_573879 = ref object of OpenApiRestCall_573657
proc url_LoggerList_573881(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_LoggerList_573880(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of loggers in the specified service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-log-event-hubs
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
  ## | type  | eq                     |                                             |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574028 = query.getOrDefault("api-version")
  valid_574028 = validateParameter(valid_574028, JString, required = true,
                                 default = nil)
  if valid_574028 != nil:
    section.add "api-version", valid_574028
  var valid_574029 = query.getOrDefault("$top")
  valid_574029 = validateParameter(valid_574029, JInt, required = false, default = nil)
  if valid_574029 != nil:
    section.add "$top", valid_574029
  var valid_574030 = query.getOrDefault("$skip")
  valid_574030 = validateParameter(valid_574030, JInt, required = false, default = nil)
  if valid_574030 != nil:
    section.add "$skip", valid_574030
  var valid_574031 = query.getOrDefault("$filter")
  valid_574031 = validateParameter(valid_574031, JString, required = false,
                                 default = nil)
  if valid_574031 != nil:
    section.add "$filter", valid_574031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574058: Call_LoggerList_573879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of loggers in the specified service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-log-event-hubs
  let valid = call_574058.validator(path, query, header, formData, body)
  let scheme = call_574058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574058.url(scheme.get, call_574058.host, call_574058.base,
                         call_574058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574058, url, valid)

proc call*(call_574129: Call_LoggerList_573879; apiVersion: string; Top: int = 0;
          Skip: int = 0; Filter: string = ""): Recallable =
  ## loggerList
  ## Lists a collection of loggers in the specified service instance.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-log-event-hubs
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
  ## | type  | eq                     |                                             |
  var query_574130 = newJObject()
  add(query_574130, "api-version", newJString(apiVersion))
  add(query_574130, "$top", newJInt(Top))
  add(query_574130, "$skip", newJInt(Skip))
  add(query_574130, "$filter", newJString(Filter))
  result = call_574129.call(nil, query_574130, nil, nil, nil)

var loggerList* = Call_LoggerList_573879(name: "loggerList",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local", route: "/loggers",
                                      validator: validate_LoggerList_573880,
                                      base: "", url: url_LoggerList_573881,
                                      schemes: {Scheme.Https})
type
  Call_LoggerCreateOrUpdate_574202 = ref object of OpenApiRestCall_573657
proc url_LoggerCreateOrUpdate_574204(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "loggerid" in path, "`loggerid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggerCreateOrUpdate_574203(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates a logger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   loggerid: JString (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `loggerid` field"
  var valid_574222 = path.getOrDefault("loggerid")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = nil)
  if valid_574222 != nil:
    section.add "loggerid", valid_574222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574223 = query.getOrDefault("api-version")
  valid_574223 = validateParameter(valid_574223, JString, required = true,
                                 default = nil)
  if valid_574223 != nil:
    section.add "api-version", valid_574223
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

proc call*(call_574225: Call_LoggerCreateOrUpdate_574202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a logger.
  ## 
  let valid = call_574225.validator(path, query, header, formData, body)
  let scheme = call_574225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574225.url(scheme.get, call_574225.host, call_574225.base,
                         call_574225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574225, url, valid)

proc call*(call_574226: Call_LoggerCreateOrUpdate_574202; apiVersion: string;
          loggerid: string; parameters: JsonNode): Recallable =
  ## loggerCreateOrUpdate
  ## Creates or Updates a logger.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   loggerid: string (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  var path_574227 = newJObject()
  var query_574228 = newJObject()
  var body_574229 = newJObject()
  add(query_574228, "api-version", newJString(apiVersion))
  add(path_574227, "loggerid", newJString(loggerid))
  if parameters != nil:
    body_574229 = parameters
  result = call_574226.call(path_574227, query_574228, nil, nil, body_574229)

var loggerCreateOrUpdate* = Call_LoggerCreateOrUpdate_574202(
    name: "loggerCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/loggers/{loggerid}", validator: validate_LoggerCreateOrUpdate_574203,
    base: "", url: url_LoggerCreateOrUpdate_574204, schemes: {Scheme.Https})
type
  Call_LoggerGet_574170 = ref object of OpenApiRestCall_573657
proc url_LoggerGet_574172(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "loggerid" in path, "`loggerid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggerGet_574171(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the logger specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   loggerid: JString (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `loggerid` field"
  var valid_574196 = path.getOrDefault("loggerid")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "loggerid", valid_574196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574197 = query.getOrDefault("api-version")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "api-version", valid_574197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574198: Call_LoggerGet_574170; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the logger specified by its identifier.
  ## 
  let valid = call_574198.validator(path, query, header, formData, body)
  let scheme = call_574198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574198.url(scheme.get, call_574198.host, call_574198.base,
                         call_574198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574198, url, valid)

proc call*(call_574199: Call_LoggerGet_574170; apiVersion: string; loggerid: string): Recallable =
  ## loggerGet
  ## Gets the details of the logger specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   loggerid: string (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  var path_574200 = newJObject()
  var query_574201 = newJObject()
  add(query_574201, "api-version", newJString(apiVersion))
  add(path_574200, "loggerid", newJString(loggerid))
  result = call_574199.call(path_574200, query_574201, nil, nil, nil)

var loggerGet* = Call_LoggerGet_574170(name: "loggerGet", meth: HttpMethod.HttpGet,
                                    host: "azure.local",
                                    route: "/loggers/{loggerid}",
                                    validator: validate_LoggerGet_574171,
                                    base: "", url: url_LoggerGet_574172,
                                    schemes: {Scheme.Https})
type
  Call_LoggerUpdate_574240 = ref object of OpenApiRestCall_573657
proc url_LoggerUpdate_574242(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "loggerid" in path, "`loggerid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggerUpdate_574241(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing logger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   loggerid: JString (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `loggerid` field"
  var valid_574243 = path.getOrDefault("loggerid")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "loggerid", valid_574243
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
  ##           : The entity state (Etag) version of the logger to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574247: Call_LoggerUpdate_574240; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing logger.
  ## 
  let valid = call_574247.validator(path, query, header, formData, body)
  let scheme = call_574247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574247.url(scheme.get, call_574247.host, call_574247.base,
                         call_574247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574247, url, valid)

proc call*(call_574248: Call_LoggerUpdate_574240; apiVersion: string;
          loggerid: string; parameters: JsonNode): Recallable =
  ## loggerUpdate
  ## Updates an existing logger.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   loggerid: string (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  var path_574249 = newJObject()
  var query_574250 = newJObject()
  var body_574251 = newJObject()
  add(query_574250, "api-version", newJString(apiVersion))
  add(path_574249, "loggerid", newJString(loggerid))
  if parameters != nil:
    body_574251 = parameters
  result = call_574248.call(path_574249, query_574250, nil, nil, body_574251)

var loggerUpdate* = Call_LoggerUpdate_574240(name: "loggerUpdate",
    meth: HttpMethod.HttpPatch, host: "azure.local", route: "/loggers/{loggerid}",
    validator: validate_LoggerUpdate_574241, base: "", url: url_LoggerUpdate_574242,
    schemes: {Scheme.Https})
type
  Call_LoggerDelete_574230 = ref object of OpenApiRestCall_573657
proc url_LoggerDelete_574232(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "loggerid" in path, "`loggerid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LoggerDelete_574231(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified logger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   loggerid: JString (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `loggerid` field"
  var valid_574233 = path.getOrDefault("loggerid")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = nil)
  if valid_574233 != nil:
    section.add "loggerid", valid_574233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574234 = query.getOrDefault("api-version")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "api-version", valid_574234
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the logger to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574235 = header.getOrDefault("If-Match")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "If-Match", valid_574235
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574236: Call_LoggerDelete_574230; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified logger.
  ## 
  let valid = call_574236.validator(path, query, header, formData, body)
  let scheme = call_574236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574236.url(scheme.get, call_574236.host, call_574236.base,
                         call_574236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574236, url, valid)

proc call*(call_574237: Call_LoggerDelete_574230; apiVersion: string;
          loggerid: string): Recallable =
  ## loggerDelete
  ## Deletes the specified logger.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   loggerid: string (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  var path_574238 = newJObject()
  var query_574239 = newJObject()
  add(query_574239, "api-version", newJString(apiVersion))
  add(path_574238, "loggerid", newJString(loggerid))
  result = call_574237.call(path_574238, query_574239, nil, nil, nil)

var loggerDelete* = Call_LoggerDelete_574230(name: "loggerDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/loggers/{loggerid}",
    validator: validate_LoggerDelete_574231, base: "", url: url_LoggerDelete_574232,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
