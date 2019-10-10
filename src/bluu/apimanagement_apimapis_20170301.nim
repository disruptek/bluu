
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on API entity and their Operations associated with your Azure API Management deployment.
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
  macServiceName = "apimanagement-apimapis"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ApiList_573879 = ref object of OpenApiRestCall_573657
proc url_ApiList_573881(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApiList_573880(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all APIs of the API Management service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-apis
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
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
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

proc call*(call_574058: Call_ApiList_573879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all APIs of the API Management service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-apis
  let valid = call_574058.validator(path, query, header, formData, body)
  let scheme = call_574058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574058.url(scheme.get, call_574058.host, call_574058.base,
                         call_574058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574058, url, valid)

proc call*(call_574129: Call_ApiList_573879; apiVersion: string; Top: int = 0;
          Skip: int = 0; Filter: string = ""): Recallable =
  ## apiList
  ## Lists all APIs of the API Management service instance.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-apis
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var query_574130 = newJObject()
  add(query_574130, "api-version", newJString(apiVersion))
  add(query_574130, "$top", newJInt(Top))
  add(query_574130, "$skip", newJInt(Skip))
  add(query_574130, "$filter", newJString(Filter))
  result = call_574129.call(nil, query_574130, nil, nil, nil)

var apiList* = Call_ApiList_573879(name: "apiList", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/apis",
                                validator: validate_ApiList_573880, base: "",
                                url: url_ApiList_573881, schemes: {Scheme.Https})
type
  Call_ApiCreateOrUpdate_574202 = ref object of OpenApiRestCall_573657
proc url_ApiCreateOrUpdate_574204(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiCreateOrUpdate_574203(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates new or updates existing specified API of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574222 = path.getOrDefault("apiId")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = nil)
  if valid_574222 != nil:
    section.add "apiId", valid_574222
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
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Api Entity. For Create Api Etag should not be specified. For Update Etag should match the existing Entity or it can be * for unconditional update.
  section = newJObject()
  var valid_574224 = header.getOrDefault("If-Match")
  valid_574224 = validateParameter(valid_574224, JString, required = false,
                                 default = nil)
  if valid_574224 != nil:
    section.add "If-Match", valid_574224
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

proc call*(call_574226: Call_ApiCreateOrUpdate_574202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates new or updates existing specified API of the API Management service instance.
  ## 
  let valid = call_574226.validator(path, query, header, formData, body)
  let scheme = call_574226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574226.url(scheme.get, call_574226.host, call_574226.base,
                         call_574226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574226, url, valid)

proc call*(call_574227: Call_ApiCreateOrUpdate_574202; apiVersion: string;
          apiId: string; parameters: JsonNode): Recallable =
  ## apiCreateOrUpdate
  ## Creates new or updates existing specified API of the API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  var path_574228 = newJObject()
  var query_574229 = newJObject()
  var body_574230 = newJObject()
  add(query_574229, "api-version", newJString(apiVersion))
  add(path_574228, "apiId", newJString(apiId))
  if parameters != nil:
    body_574230 = parameters
  result = call_574227.call(path_574228, query_574229, nil, nil, body_574230)

var apiCreateOrUpdate* = Call_ApiCreateOrUpdate_574202(name: "apiCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local", route: "/apis/{apiId}",
    validator: validate_ApiCreateOrUpdate_574203, base: "",
    url: url_ApiCreateOrUpdate_574204, schemes: {Scheme.Https})
type
  Call_ApiGet_574170 = ref object of OpenApiRestCall_573657
proc url_ApiGet_574172(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiGet_574171(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574196 = path.getOrDefault("apiId")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "apiId", valid_574196
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

proc call*(call_574198: Call_ApiGet_574170; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the API specified by its identifier.
  ## 
  let valid = call_574198.validator(path, query, header, formData, body)
  let scheme = call_574198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574198.url(scheme.get, call_574198.host, call_574198.base,
                         call_574198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574198, url, valid)

proc call*(call_574199: Call_ApiGet_574170; apiVersion: string; apiId: string): Recallable =
  ## apiGet
  ## Gets the details of the API specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  var path_574200 = newJObject()
  var query_574201 = newJObject()
  add(query_574201, "api-version", newJString(apiVersion))
  add(path_574200, "apiId", newJString(apiId))
  result = call_574199.call(path_574200, query_574201, nil, nil, nil)

var apiGet* = Call_ApiGet_574170(name: "apiGet", meth: HttpMethod.HttpGet,
                              host: "azure.local", route: "/apis/{apiId}",
                              validator: validate_ApiGet_574171, base: "",
                              url: url_ApiGet_574172, schemes: {Scheme.Https})
type
  Call_ApiUpdate_574241 = ref object of OpenApiRestCall_573657
proc url_ApiUpdate_574243(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiUpdate_574242(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified API of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574254 = path.getOrDefault("apiId")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = nil)
  if valid_574254 != nil:
    section.add "apiId", valid_574254
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
  ##           : ETag of the API entity. ETag should match the current entity state in the header response of the GET request or it should be * for unconditional update.
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
  ##             : API Update Contract parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574258: Call_ApiUpdate_574241; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified API of the API Management service instance.
  ## 
  let valid = call_574258.validator(path, query, header, formData, body)
  let scheme = call_574258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574258.url(scheme.get, call_574258.host, call_574258.base,
                         call_574258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574258, url, valid)

proc call*(call_574259: Call_ApiUpdate_574241; apiVersion: string; apiId: string;
          parameters: JsonNode): Recallable =
  ## apiUpdate
  ## Updates the specified API of the API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : API Update Contract parameters.
  var path_574260 = newJObject()
  var query_574261 = newJObject()
  var body_574262 = newJObject()
  add(query_574261, "api-version", newJString(apiVersion))
  add(path_574260, "apiId", newJString(apiId))
  if parameters != nil:
    body_574262 = parameters
  result = call_574259.call(path_574260, query_574261, nil, nil, body_574262)

var apiUpdate* = Call_ApiUpdate_574241(name: "apiUpdate", meth: HttpMethod.HttpPatch,
                                    host: "azure.local", route: "/apis/{apiId}",
                                    validator: validate_ApiUpdate_574242,
                                    base: "", url: url_ApiUpdate_574243,
                                    schemes: {Scheme.Https})
type
  Call_ApiDelete_574231 = ref object of OpenApiRestCall_573657
proc url_ApiDelete_574233(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDelete_574232(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified API of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574234 = path.getOrDefault("apiId")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "apiId", valid_574234
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
  ##           : ETag of the API Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
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

proc call*(call_574237: Call_ApiDelete_574231; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified API of the API Management service instance.
  ## 
  let valid = call_574237.validator(path, query, header, formData, body)
  let scheme = call_574237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574237.url(scheme.get, call_574237.host, call_574237.base,
                         call_574237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574237, url, valid)

proc call*(call_574238: Call_ApiDelete_574231; apiVersion: string; apiId: string): Recallable =
  ## apiDelete
  ## Deletes the specified API of the API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  var path_574239 = newJObject()
  var query_574240 = newJObject()
  add(query_574240, "api-version", newJString(apiVersion))
  add(path_574239, "apiId", newJString(apiId))
  result = call_574238.call(path_574239, query_574240, nil, nil, nil)

var apiDelete* = Call_ApiDelete_574231(name: "apiDelete",
                                    meth: HttpMethod.HttpDelete,
                                    host: "azure.local", route: "/apis/{apiId}",
                                    validator: validate_ApiDelete_574232,
                                    base: "", url: url_ApiDelete_574233,
                                    schemes: {Scheme.Https})
type
  Call_ApiOperationListByApi_574263 = ref object of OpenApiRestCall_573657
proc url_ApiOperationListByApi_574265(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationListByApi_574264(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of the operations for the specified API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574266 = path.getOrDefault("apiId")
  valid_574266 = validateParameter(valid_574266, JString, required = true,
                                 default = nil)
  if valid_574266 != nil:
    section.add "apiId", valid_574266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | method      | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574267 = query.getOrDefault("api-version")
  valid_574267 = validateParameter(valid_574267, JString, required = true,
                                 default = nil)
  if valid_574267 != nil:
    section.add "api-version", valid_574267
  var valid_574268 = query.getOrDefault("$top")
  valid_574268 = validateParameter(valid_574268, JInt, required = false, default = nil)
  if valid_574268 != nil:
    section.add "$top", valid_574268
  var valid_574269 = query.getOrDefault("$skip")
  valid_574269 = validateParameter(valid_574269, JInt, required = false, default = nil)
  if valid_574269 != nil:
    section.add "$skip", valid_574269
  var valid_574270 = query.getOrDefault("$filter")
  valid_574270 = validateParameter(valid_574270, JString, required = false,
                                 default = nil)
  if valid_574270 != nil:
    section.add "$filter", valid_574270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574271: Call_ApiOperationListByApi_574263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of the operations for the specified API.
  ## 
  let valid = call_574271.validator(path, query, header, formData, body)
  let scheme = call_574271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574271.url(scheme.get, call_574271.host, call_574271.base,
                         call_574271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574271, url, valid)

proc call*(call_574272: Call_ApiOperationListByApi_574263; apiVersion: string;
          apiId: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiOperationListByApi
  ## Lists a collection of the operations for the specified API.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | method      | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_574273 = newJObject()
  var query_574274 = newJObject()
  add(query_574274, "api-version", newJString(apiVersion))
  add(path_574273, "apiId", newJString(apiId))
  add(query_574274, "$top", newJInt(Top))
  add(query_574274, "$skip", newJInt(Skip))
  add(query_574274, "$filter", newJString(Filter))
  result = call_574272.call(path_574273, query_574274, nil, nil, nil)

var apiOperationListByApi* = Call_ApiOperationListByApi_574263(
    name: "apiOperationListByApi", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apis/{apiId}/operations", validator: validate_ApiOperationListByApi_574264,
    base: "", url: url_ApiOperationListByApi_574265, schemes: {Scheme.Https})
type
  Call_ApiOperationCreateOrUpdate_574285 = ref object of OpenApiRestCall_573657
proc url_ApiOperationCreateOrUpdate_574287(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationCreateOrUpdate_574286(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new operation in the API or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574288 = path.getOrDefault("apiId")
  valid_574288 = validateParameter(valid_574288, JString, required = true,
                                 default = nil)
  if valid_574288 != nil:
    section.add "apiId", valid_574288
  var valid_574289 = path.getOrDefault("operationId")
  valid_574289 = validateParameter(valid_574289, JString, required = true,
                                 default = nil)
  if valid_574289 != nil:
    section.add "operationId", valid_574289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574290 = query.getOrDefault("api-version")
  valid_574290 = validateParameter(valid_574290, JString, required = true,
                                 default = nil)
  if valid_574290 != nil:
    section.add "api-version", valid_574290
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

proc call*(call_574292: Call_ApiOperationCreateOrUpdate_574285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new operation in the API or updates an existing one.
  ## 
  let valid = call_574292.validator(path, query, header, formData, body)
  let scheme = call_574292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574292.url(scheme.get, call_574292.host, call_574292.base,
                         call_574292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574292, url, valid)

proc call*(call_574293: Call_ApiOperationCreateOrUpdate_574285; apiVersion: string;
          apiId: string; parameters: JsonNode; operationId: string): Recallable =
  ## apiOperationCreateOrUpdate
  ## Creates a new operation in the API or updates an existing one.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_574294 = newJObject()
  var query_574295 = newJObject()
  var body_574296 = newJObject()
  add(query_574295, "api-version", newJString(apiVersion))
  add(path_574294, "apiId", newJString(apiId))
  if parameters != nil:
    body_574296 = parameters
  add(path_574294, "operationId", newJString(operationId))
  result = call_574293.call(path_574294, query_574295, nil, nil, body_574296)

var apiOperationCreateOrUpdate* = Call_ApiOperationCreateOrUpdate_574285(
    name: "apiOperationCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationCreateOrUpdate_574286, base: "",
    url: url_ApiOperationCreateOrUpdate_574287, schemes: {Scheme.Https})
type
  Call_ApiOperationGet_574275 = ref object of OpenApiRestCall_573657
proc url_ApiOperationGet_574277(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationGet_574276(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the details of the API Operation specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574278 = path.getOrDefault("apiId")
  valid_574278 = validateParameter(valid_574278, JString, required = true,
                                 default = nil)
  if valid_574278 != nil:
    section.add "apiId", valid_574278
  var valid_574279 = path.getOrDefault("operationId")
  valid_574279 = validateParameter(valid_574279, JString, required = true,
                                 default = nil)
  if valid_574279 != nil:
    section.add "operationId", valid_574279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574280 = query.getOrDefault("api-version")
  valid_574280 = validateParameter(valid_574280, JString, required = true,
                                 default = nil)
  if valid_574280 != nil:
    section.add "api-version", valid_574280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574281: Call_ApiOperationGet_574275; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the API Operation specified by its identifier.
  ## 
  let valid = call_574281.validator(path, query, header, formData, body)
  let scheme = call_574281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574281.url(scheme.get, call_574281.host, call_574281.base,
                         call_574281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574281, url, valid)

proc call*(call_574282: Call_ApiOperationGet_574275; apiVersion: string;
          apiId: string; operationId: string): Recallable =
  ## apiOperationGet
  ## Gets the details of the API Operation specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_574283 = newJObject()
  var query_574284 = newJObject()
  add(query_574284, "api-version", newJString(apiVersion))
  add(path_574283, "apiId", newJString(apiId))
  add(path_574283, "operationId", newJString(operationId))
  result = call_574282.call(path_574283, query_574284, nil, nil, nil)

var apiOperationGet* = Call_ApiOperationGet_574275(name: "apiOperationGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationGet_574276, base: "", url: url_ApiOperationGet_574277,
    schemes: {Scheme.Https})
type
  Call_ApiOperationUpdate_574308 = ref object of OpenApiRestCall_573657
proc url_ApiOperationUpdate_574310(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationUpdate_574309(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the details of the operation in the API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574311 = path.getOrDefault("apiId")
  valid_574311 = validateParameter(valid_574311, JString, required = true,
                                 default = nil)
  if valid_574311 != nil:
    section.add "apiId", valid_574311
  var valid_574312 = path.getOrDefault("operationId")
  valid_574312 = validateParameter(valid_574312, JString, required = true,
                                 default = nil)
  if valid_574312 != nil:
    section.add "operationId", valid_574312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574313 = query.getOrDefault("api-version")
  valid_574313 = validateParameter(valid_574313, JString, required = true,
                                 default = nil)
  if valid_574313 != nil:
    section.add "api-version", valid_574313
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the API Operation Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574314 = header.getOrDefault("If-Match")
  valid_574314 = validateParameter(valid_574314, JString, required = true,
                                 default = nil)
  if valid_574314 != nil:
    section.add "If-Match", valid_574314
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : API Operation Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574316: Call_ApiOperationUpdate_574308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the operation in the API specified by its identifier.
  ## 
  let valid = call_574316.validator(path, query, header, formData, body)
  let scheme = call_574316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574316.url(scheme.get, call_574316.host, call_574316.base,
                         call_574316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574316, url, valid)

proc call*(call_574317: Call_ApiOperationUpdate_574308; apiVersion: string;
          apiId: string; parameters: JsonNode; operationId: string): Recallable =
  ## apiOperationUpdate
  ## Updates the details of the operation in the API specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : API Operation Update parameters.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_574318 = newJObject()
  var query_574319 = newJObject()
  var body_574320 = newJObject()
  add(query_574319, "api-version", newJString(apiVersion))
  add(path_574318, "apiId", newJString(apiId))
  if parameters != nil:
    body_574320 = parameters
  add(path_574318, "operationId", newJString(operationId))
  result = call_574317.call(path_574318, query_574319, nil, nil, body_574320)

var apiOperationUpdate* = Call_ApiOperationUpdate_574308(
    name: "apiOperationUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationUpdate_574309, base: "",
    url: url_ApiOperationUpdate_574310, schemes: {Scheme.Https})
type
  Call_ApiOperationDelete_574297 = ref object of OpenApiRestCall_573657
proc url_ApiOperationDelete_574299(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationDelete_574298(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the specified operation in the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574300 = path.getOrDefault("apiId")
  valid_574300 = validateParameter(valid_574300, JString, required = true,
                                 default = nil)
  if valid_574300 != nil:
    section.add "apiId", valid_574300
  var valid_574301 = path.getOrDefault("operationId")
  valid_574301 = validateParameter(valid_574301, JString, required = true,
                                 default = nil)
  if valid_574301 != nil:
    section.add "operationId", valid_574301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574302 = query.getOrDefault("api-version")
  valid_574302 = validateParameter(valid_574302, JString, required = true,
                                 default = nil)
  if valid_574302 != nil:
    section.add "api-version", valid_574302
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the API Operation Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574303 = header.getOrDefault("If-Match")
  valid_574303 = validateParameter(valid_574303, JString, required = true,
                                 default = nil)
  if valid_574303 != nil:
    section.add "If-Match", valid_574303
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574304: Call_ApiOperationDelete_574297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified operation in the API.
  ## 
  let valid = call_574304.validator(path, query, header, formData, body)
  let scheme = call_574304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574304.url(scheme.get, call_574304.host, call_574304.base,
                         call_574304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574304, url, valid)

proc call*(call_574305: Call_ApiOperationDelete_574297; apiVersion: string;
          apiId: string; operationId: string): Recallable =
  ## apiOperationDelete
  ## Deletes the specified operation in the API.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_574306 = newJObject()
  var query_574307 = newJObject()
  add(query_574307, "api-version", newJString(apiVersion))
  add(path_574306, "apiId", newJString(apiId))
  add(path_574306, "operationId", newJString(operationId))
  result = call_574305.call(path_574306, query_574307, nil, nil, nil)

var apiOperationDelete* = Call_ApiOperationDelete_574297(
    name: "apiOperationDelete", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationDelete_574298, base: "",
    url: url_ApiOperationDelete_574299, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyListByOperation_574321 = ref object of OpenApiRestCall_573657
proc url_ApiOperationPolicyListByOperation_574323(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/policies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationPolicyListByOperation_574322(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of policy configuration at the API Operation level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574324 = path.getOrDefault("apiId")
  valid_574324 = validateParameter(valid_574324, JString, required = true,
                                 default = nil)
  if valid_574324 != nil:
    section.add "apiId", valid_574324
  var valid_574325 = path.getOrDefault("operationId")
  valid_574325 = validateParameter(valid_574325, JString, required = true,
                                 default = nil)
  if valid_574325 != nil:
    section.add "operationId", valid_574325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574326 = query.getOrDefault("api-version")
  valid_574326 = validateParameter(valid_574326, JString, required = true,
                                 default = nil)
  if valid_574326 != nil:
    section.add "api-version", valid_574326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574327: Call_ApiOperationPolicyListByOperation_574321;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the list of policy configuration at the API Operation level.
  ## 
  let valid = call_574327.validator(path, query, header, formData, body)
  let scheme = call_574327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574327.url(scheme.get, call_574327.host, call_574327.base,
                         call_574327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574327, url, valid)

proc call*(call_574328: Call_ApiOperationPolicyListByOperation_574321;
          apiVersion: string; apiId: string; operationId: string): Recallable =
  ## apiOperationPolicyListByOperation
  ## Get the list of policy configuration at the API Operation level.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_574329 = newJObject()
  var query_574330 = newJObject()
  add(query_574330, "api-version", newJString(apiVersion))
  add(path_574329, "apiId", newJString(apiId))
  add(path_574329, "operationId", newJString(operationId))
  result = call_574328.call(path_574329, query_574330, nil, nil, nil)

var apiOperationPolicyListByOperation* = Call_ApiOperationPolicyListByOperation_574321(
    name: "apiOperationPolicyListByOperation", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apis/{apiId}/operations/{operationId}/policies",
    validator: validate_ApiOperationPolicyListByOperation_574322, base: "",
    url: url_ApiOperationPolicyListByOperation_574323, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyCreateOrUpdate_574355 = ref object of OpenApiRestCall_573657
proc url_ApiOperationPolicyCreateOrUpdate_574357(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationPolicyCreateOrUpdate_574356(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates policy configuration for the API Operation level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574358 = path.getOrDefault("apiId")
  valid_574358 = validateParameter(valid_574358, JString, required = true,
                                 default = nil)
  if valid_574358 != nil:
    section.add "apiId", valid_574358
  var valid_574359 = path.getOrDefault("policyId")
  valid_574359 = validateParameter(valid_574359, JString, required = true,
                                 default = newJString("policy"))
  if valid_574359 != nil:
    section.add "policyId", valid_574359
  var valid_574360 = path.getOrDefault("operationId")
  valid_574360 = validateParameter(valid_574360, JString, required = true,
                                 default = nil)
  if valid_574360 != nil:
    section.add "operationId", valid_574360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574361 = query.getOrDefault("api-version")
  valid_574361 = validateParameter(valid_574361, JString, required = true,
                                 default = nil)
  if valid_574361 != nil:
    section.add "api-version", valid_574361
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api Operation policy to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574362 = header.getOrDefault("If-Match")
  valid_574362 = validateParameter(valid_574362, JString, required = true,
                                 default = nil)
  if valid_574362 != nil:
    section.add "If-Match", valid_574362
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574364: Call_ApiOperationPolicyCreateOrUpdate_574355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates policy configuration for the API Operation level.
  ## 
  let valid = call_574364.validator(path, query, header, formData, body)
  let scheme = call_574364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574364.url(scheme.get, call_574364.host, call_574364.base,
                         call_574364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574364, url, valid)

proc call*(call_574365: Call_ApiOperationPolicyCreateOrUpdate_574355;
          apiVersion: string; apiId: string; parameters: JsonNode;
          operationId: string; policyId: string = "policy"): Recallable =
  ## apiOperationPolicyCreateOrUpdate
  ## Creates or updates policy configuration for the API Operation level.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_574366 = newJObject()
  var query_574367 = newJObject()
  var body_574368 = newJObject()
  add(query_574367, "api-version", newJString(apiVersion))
  add(path_574366, "apiId", newJString(apiId))
  add(path_574366, "policyId", newJString(policyId))
  if parameters != nil:
    body_574368 = parameters
  add(path_574366, "operationId", newJString(operationId))
  result = call_574365.call(path_574366, query_574367, nil, nil, body_574368)

var apiOperationPolicyCreateOrUpdate* = Call_ApiOperationPolicyCreateOrUpdate_574355(
    name: "apiOperationPolicyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyCreateOrUpdate_574356, base: "",
    url: url_ApiOperationPolicyCreateOrUpdate_574357, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyGet_574331 = ref object of OpenApiRestCall_573657
proc url_ApiOperationPolicyGet_574333(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationPolicyGet_574332(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the policy configuration at the API Operation level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574334 = path.getOrDefault("apiId")
  valid_574334 = validateParameter(valid_574334, JString, required = true,
                                 default = nil)
  if valid_574334 != nil:
    section.add "apiId", valid_574334
  var valid_574348 = path.getOrDefault("policyId")
  valid_574348 = validateParameter(valid_574348, JString, required = true,
                                 default = newJString("policy"))
  if valid_574348 != nil:
    section.add "policyId", valid_574348
  var valid_574349 = path.getOrDefault("operationId")
  valid_574349 = validateParameter(valid_574349, JString, required = true,
                                 default = nil)
  if valid_574349 != nil:
    section.add "operationId", valid_574349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574350 = query.getOrDefault("api-version")
  valid_574350 = validateParameter(valid_574350, JString, required = true,
                                 default = nil)
  if valid_574350 != nil:
    section.add "api-version", valid_574350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574351: Call_ApiOperationPolicyGet_574331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the API Operation level.
  ## 
  let valid = call_574351.validator(path, query, header, formData, body)
  let scheme = call_574351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574351.url(scheme.get, call_574351.host, call_574351.base,
                         call_574351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574351, url, valid)

proc call*(call_574352: Call_ApiOperationPolicyGet_574331; apiVersion: string;
          apiId: string; operationId: string; policyId: string = "policy"): Recallable =
  ## apiOperationPolicyGet
  ## Get the policy configuration at the API Operation level.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_574353 = newJObject()
  var query_574354 = newJObject()
  add(query_574354, "api-version", newJString(apiVersion))
  add(path_574353, "apiId", newJString(apiId))
  add(path_574353, "policyId", newJString(policyId))
  add(path_574353, "operationId", newJString(operationId))
  result = call_574352.call(path_574353, query_574354, nil, nil, nil)

var apiOperationPolicyGet* = Call_ApiOperationPolicyGet_574331(
    name: "apiOperationPolicyGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyGet_574332, base: "",
    url: url_ApiOperationPolicyGet_574333, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyDelete_574369 = ref object of OpenApiRestCall_573657
proc url_ApiOperationPolicyDelete_574371(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationPolicyDelete_574370(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the policy configuration at the Api Operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574372 = path.getOrDefault("apiId")
  valid_574372 = validateParameter(valid_574372, JString, required = true,
                                 default = nil)
  if valid_574372 != nil:
    section.add "apiId", valid_574372
  var valid_574373 = path.getOrDefault("policyId")
  valid_574373 = validateParameter(valid_574373, JString, required = true,
                                 default = newJString("policy"))
  if valid_574373 != nil:
    section.add "policyId", valid_574373
  var valid_574374 = path.getOrDefault("operationId")
  valid_574374 = validateParameter(valid_574374, JString, required = true,
                                 default = nil)
  if valid_574374 != nil:
    section.add "operationId", valid_574374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574375 = query.getOrDefault("api-version")
  valid_574375 = validateParameter(valid_574375, JString, required = true,
                                 default = nil)
  if valid_574375 != nil:
    section.add "api-version", valid_574375
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api Operation Policy to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574376 = header.getOrDefault("If-Match")
  valid_574376 = validateParameter(valid_574376, JString, required = true,
                                 default = nil)
  if valid_574376 != nil:
    section.add "If-Match", valid_574376
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574377: Call_ApiOperationPolicyDelete_574369; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the policy configuration at the Api Operation.
  ## 
  let valid = call_574377.validator(path, query, header, formData, body)
  let scheme = call_574377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574377.url(scheme.get, call_574377.host, call_574377.base,
                         call_574377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574377, url, valid)

proc call*(call_574378: Call_ApiOperationPolicyDelete_574369; apiVersion: string;
          apiId: string; operationId: string; policyId: string = "policy"): Recallable =
  ## apiOperationPolicyDelete
  ## Deletes the policy configuration at the Api Operation.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_574379 = newJObject()
  var query_574380 = newJObject()
  add(query_574380, "api-version", newJString(apiVersion))
  add(path_574379, "apiId", newJString(apiId))
  add(path_574379, "policyId", newJString(policyId))
  add(path_574379, "operationId", newJString(operationId))
  result = call_574378.call(path_574379, query_574380, nil, nil, nil)

var apiOperationPolicyDelete* = Call_ApiOperationPolicyDelete_574369(
    name: "apiOperationPolicyDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyDelete_574370, base: "",
    url: url_ApiOperationPolicyDelete_574371, schemes: {Scheme.Https})
type
  Call_ApiPolicyListByApi_574381 = ref object of OpenApiRestCall_573657
proc url_ApiPolicyListByApi_574383(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/policies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiPolicyListByApi_574382(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the policy configuration at the API level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574384 = path.getOrDefault("apiId")
  valid_574384 = validateParameter(valid_574384, JString, required = true,
                                 default = nil)
  if valid_574384 != nil:
    section.add "apiId", valid_574384
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574385 = query.getOrDefault("api-version")
  valid_574385 = validateParameter(valid_574385, JString, required = true,
                                 default = nil)
  if valid_574385 != nil:
    section.add "api-version", valid_574385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574386: Call_ApiPolicyListByApi_574381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the API level.
  ## 
  let valid = call_574386.validator(path, query, header, formData, body)
  let scheme = call_574386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574386.url(scheme.get, call_574386.host, call_574386.base,
                         call_574386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574386, url, valid)

proc call*(call_574387: Call_ApiPolicyListByApi_574381; apiVersion: string;
          apiId: string): Recallable =
  ## apiPolicyListByApi
  ## Get the policy configuration at the API level.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  var path_574388 = newJObject()
  var query_574389 = newJObject()
  add(query_574389, "api-version", newJString(apiVersion))
  add(path_574388, "apiId", newJString(apiId))
  result = call_574387.call(path_574388, query_574389, nil, nil, nil)

var apiPolicyListByApi* = Call_ApiPolicyListByApi_574381(
    name: "apiPolicyListByApi", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apis/{apiId}/policies", validator: validate_ApiPolicyListByApi_574382,
    base: "", url: url_ApiPolicyListByApi_574383, schemes: {Scheme.Https})
type
  Call_ApiPolicyCreateOrUpdate_574400 = ref object of OpenApiRestCall_573657
proc url_ApiPolicyCreateOrUpdate_574402(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiPolicyCreateOrUpdate_574401(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates policy configuration for the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574403 = path.getOrDefault("apiId")
  valid_574403 = validateParameter(valid_574403, JString, required = true,
                                 default = nil)
  if valid_574403 != nil:
    section.add "apiId", valid_574403
  var valid_574404 = path.getOrDefault("policyId")
  valid_574404 = validateParameter(valid_574404, JString, required = true,
                                 default = newJString("policy"))
  if valid_574404 != nil:
    section.add "policyId", valid_574404
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574405 = query.getOrDefault("api-version")
  valid_574405 = validateParameter(valid_574405, JString, required = true,
                                 default = nil)
  if valid_574405 != nil:
    section.add "api-version", valid_574405
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api Policy to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574406 = header.getOrDefault("If-Match")
  valid_574406 = validateParameter(valid_574406, JString, required = true,
                                 default = nil)
  if valid_574406 != nil:
    section.add "If-Match", valid_574406
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574408: Call_ApiPolicyCreateOrUpdate_574400; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates policy configuration for the API.
  ## 
  let valid = call_574408.validator(path, query, header, formData, body)
  let scheme = call_574408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574408.url(scheme.get, call_574408.host, call_574408.base,
                         call_574408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574408, url, valid)

proc call*(call_574409: Call_ApiPolicyCreateOrUpdate_574400; apiVersion: string;
          apiId: string; parameters: JsonNode; policyId: string = "policy"): Recallable =
  ## apiPolicyCreateOrUpdate
  ## Creates or updates policy configuration for the API.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  var path_574410 = newJObject()
  var query_574411 = newJObject()
  var body_574412 = newJObject()
  add(query_574411, "api-version", newJString(apiVersion))
  add(path_574410, "apiId", newJString(apiId))
  add(path_574410, "policyId", newJString(policyId))
  if parameters != nil:
    body_574412 = parameters
  result = call_574409.call(path_574410, query_574411, nil, nil, body_574412)

var apiPolicyCreateOrUpdate* = Call_ApiPolicyCreateOrUpdate_574400(
    name: "apiPolicyCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyCreateOrUpdate_574401, base: "",
    url: url_ApiPolicyCreateOrUpdate_574402, schemes: {Scheme.Https})
type
  Call_ApiPolicyGet_574390 = ref object of OpenApiRestCall_573657
proc url_ApiPolicyGet_574392(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiPolicyGet_574391(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the policy configuration at the API level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574393 = path.getOrDefault("apiId")
  valid_574393 = validateParameter(valid_574393, JString, required = true,
                                 default = nil)
  if valid_574393 != nil:
    section.add "apiId", valid_574393
  var valid_574394 = path.getOrDefault("policyId")
  valid_574394 = validateParameter(valid_574394, JString, required = true,
                                 default = newJString("policy"))
  if valid_574394 != nil:
    section.add "policyId", valid_574394
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574395 = query.getOrDefault("api-version")
  valid_574395 = validateParameter(valid_574395, JString, required = true,
                                 default = nil)
  if valid_574395 != nil:
    section.add "api-version", valid_574395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574396: Call_ApiPolicyGet_574390; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the API level.
  ## 
  let valid = call_574396.validator(path, query, header, formData, body)
  let scheme = call_574396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574396.url(scheme.get, call_574396.host, call_574396.base,
                         call_574396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574396, url, valid)

proc call*(call_574397: Call_ApiPolicyGet_574390; apiVersion: string; apiId: string;
          policyId: string = "policy"): Recallable =
  ## apiPolicyGet
  ## Get the policy configuration at the API level.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  var path_574398 = newJObject()
  var query_574399 = newJObject()
  add(query_574399, "api-version", newJString(apiVersion))
  add(path_574398, "apiId", newJString(apiId))
  add(path_574398, "policyId", newJString(policyId))
  result = call_574397.call(path_574398, query_574399, nil, nil, nil)

var apiPolicyGet* = Call_ApiPolicyGet_574390(name: "apiPolicyGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apis/{apiId}/policies/{policyId}", validator: validate_ApiPolicyGet_574391,
    base: "", url: url_ApiPolicyGet_574392, schemes: {Scheme.Https})
type
  Call_ApiPolicyDelete_574413 = ref object of OpenApiRestCall_573657
proc url_ApiPolicyDelete_574415(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiPolicyDelete_574414(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes the policy configuration at the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574416 = path.getOrDefault("apiId")
  valid_574416 = validateParameter(valid_574416, JString, required = true,
                                 default = nil)
  if valid_574416 != nil:
    section.add "apiId", valid_574416
  var valid_574417 = path.getOrDefault("policyId")
  valid_574417 = validateParameter(valid_574417, JString, required = true,
                                 default = newJString("policy"))
  if valid_574417 != nil:
    section.add "policyId", valid_574417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574418 = query.getOrDefault("api-version")
  valid_574418 = validateParameter(valid_574418, JString, required = true,
                                 default = nil)
  if valid_574418 != nil:
    section.add "api-version", valid_574418
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api policy to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574419 = header.getOrDefault("If-Match")
  valid_574419 = validateParameter(valid_574419, JString, required = true,
                                 default = nil)
  if valid_574419 != nil:
    section.add "If-Match", valid_574419
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574420: Call_ApiPolicyDelete_574413; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the policy configuration at the Api.
  ## 
  let valid = call_574420.validator(path, query, header, formData, body)
  let scheme = call_574420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574420.url(scheme.get, call_574420.host, call_574420.base,
                         call_574420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574420, url, valid)

proc call*(call_574421: Call_ApiPolicyDelete_574413; apiVersion: string;
          apiId: string; policyId: string = "policy"): Recallable =
  ## apiPolicyDelete
  ## Deletes the policy configuration at the Api.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  var path_574422 = newJObject()
  var query_574423 = newJObject()
  add(query_574423, "api-version", newJString(apiVersion))
  add(path_574422, "apiId", newJString(apiId))
  add(path_574422, "policyId", newJString(policyId))
  result = call_574421.call(path_574422, query_574423, nil, nil, nil)

var apiPolicyDelete* = Call_ApiPolicyDelete_574413(name: "apiPolicyDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyDelete_574414, base: "", url: url_ApiPolicyDelete_574415,
    schemes: {Scheme.Https})
type
  Call_ApiProductListByApis_574424 = ref object of OpenApiRestCall_573657
proc url_ApiProductListByApis_574426(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiProductListByApis_574425(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Products, which the API is part of.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574427 = path.getOrDefault("apiId")
  valid_574427 = validateParameter(valid_574427, JString, required = true,
                                 default = nil)
  if valid_574427 != nil:
    section.add "apiId", valid_574427
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
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574428 = query.getOrDefault("api-version")
  valid_574428 = validateParameter(valid_574428, JString, required = true,
                                 default = nil)
  if valid_574428 != nil:
    section.add "api-version", valid_574428
  var valid_574429 = query.getOrDefault("$top")
  valid_574429 = validateParameter(valid_574429, JInt, required = false, default = nil)
  if valid_574429 != nil:
    section.add "$top", valid_574429
  var valid_574430 = query.getOrDefault("$skip")
  valid_574430 = validateParameter(valid_574430, JInt, required = false, default = nil)
  if valid_574430 != nil:
    section.add "$skip", valid_574430
  var valid_574431 = query.getOrDefault("$filter")
  valid_574431 = validateParameter(valid_574431, JString, required = false,
                                 default = nil)
  if valid_574431 != nil:
    section.add "$filter", valid_574431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574432: Call_ApiProductListByApis_574424; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Products, which the API is part of.
  ## 
  let valid = call_574432.validator(path, query, header, formData, body)
  let scheme = call_574432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574432.url(scheme.get, call_574432.host, call_574432.base,
                         call_574432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574432, url, valid)

proc call*(call_574433: Call_ApiProductListByApis_574424; apiVersion: string;
          apiId: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiProductListByApis
  ## Lists all Products, which the API is part of.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string
  ##         : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_574434 = newJObject()
  var query_574435 = newJObject()
  add(query_574435, "api-version", newJString(apiVersion))
  add(path_574434, "apiId", newJString(apiId))
  add(query_574435, "$top", newJInt(Top))
  add(query_574435, "$skip", newJInt(Skip))
  add(query_574435, "$filter", newJString(Filter))
  result = call_574433.call(path_574434, query_574435, nil, nil, nil)

var apiProductListByApis* = Call_ApiProductListByApis_574424(
    name: "apiProductListByApis", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apis/{apiId}/products", validator: validate_ApiProductListByApis_574425,
    base: "", url: url_ApiProductListByApis_574426, schemes: {Scheme.Https})
type
  Call_ApiSchemaListByApi_574436 = ref object of OpenApiRestCall_573657
proc url_ApiSchemaListByApi_574438(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/schemas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiSchemaListByApi_574437(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the schema configuration at the API level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574439 = path.getOrDefault("apiId")
  valid_574439 = validateParameter(valid_574439, JString, required = true,
                                 default = nil)
  if valid_574439 != nil:
    section.add "apiId", valid_574439
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574440 = query.getOrDefault("api-version")
  valid_574440 = validateParameter(valid_574440, JString, required = true,
                                 default = nil)
  if valid_574440 != nil:
    section.add "api-version", valid_574440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574441: Call_ApiSchemaListByApi_574436; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the schema configuration at the API level.
  ## 
  let valid = call_574441.validator(path, query, header, formData, body)
  let scheme = call_574441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574441.url(scheme.get, call_574441.host, call_574441.base,
                         call_574441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574441, url, valid)

proc call*(call_574442: Call_ApiSchemaListByApi_574436; apiVersion: string;
          apiId: string): Recallable =
  ## apiSchemaListByApi
  ## Get the schema configuration at the API level.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  var path_574443 = newJObject()
  var query_574444 = newJObject()
  add(query_574444, "api-version", newJString(apiVersion))
  add(path_574443, "apiId", newJString(apiId))
  result = call_574442.call(path_574443, query_574444, nil, nil, nil)

var apiSchemaListByApi* = Call_ApiSchemaListByApi_574436(
    name: "apiSchemaListByApi", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apis/{apiId}/schemas", validator: validate_ApiSchemaListByApi_574437,
    base: "", url: url_ApiSchemaListByApi_574438, schemes: {Scheme.Https})
type
  Call_ApiSchemaCreateOrUpdate_574455 = ref object of OpenApiRestCall_573657
proc url_ApiSchemaCreateOrUpdate_574457(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "schemaId" in path, "`schemaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiSchemaCreateOrUpdate_574456(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates schema configuration for the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   schemaId: JString (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574458 = path.getOrDefault("apiId")
  valid_574458 = validateParameter(valid_574458, JString, required = true,
                                 default = nil)
  if valid_574458 != nil:
    section.add "apiId", valid_574458
  var valid_574459 = path.getOrDefault("schemaId")
  valid_574459 = validateParameter(valid_574459, JString, required = true,
                                 default = nil)
  if valid_574459 != nil:
    section.add "schemaId", valid_574459
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574460 = query.getOrDefault("api-version")
  valid_574460 = validateParameter(valid_574460, JString, required = true,
                                 default = nil)
  if valid_574460 != nil:
    section.add "api-version", valid_574460
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (Etag) version of the Api Schema to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  var valid_574461 = header.getOrDefault("If-Match")
  valid_574461 = validateParameter(valid_574461, JString, required = false,
                                 default = nil)
  if valid_574461 != nil:
    section.add "If-Match", valid_574461
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The schema contents to apply.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574463: Call_ApiSchemaCreateOrUpdate_574455; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates schema configuration for the API.
  ## 
  let valid = call_574463.validator(path, query, header, formData, body)
  let scheme = call_574463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574463.url(scheme.get, call_574463.host, call_574463.base,
                         call_574463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574463, url, valid)

proc call*(call_574464: Call_ApiSchemaCreateOrUpdate_574455; apiVersion: string;
          apiId: string; schemaId: string; parameters: JsonNode): Recallable =
  ## apiSchemaCreateOrUpdate
  ## Creates or updates schema configuration for the API.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   schemaId: string (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : The schema contents to apply.
  var path_574465 = newJObject()
  var query_574466 = newJObject()
  var body_574467 = newJObject()
  add(query_574466, "api-version", newJString(apiVersion))
  add(path_574465, "apiId", newJString(apiId))
  add(path_574465, "schemaId", newJString(schemaId))
  if parameters != nil:
    body_574467 = parameters
  result = call_574464.call(path_574465, query_574466, nil, nil, body_574467)

var apiSchemaCreateOrUpdate* = Call_ApiSchemaCreateOrUpdate_574455(
    name: "apiSchemaCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaCreateOrUpdate_574456, base: "",
    url: url_ApiSchemaCreateOrUpdate_574457, schemes: {Scheme.Https})
type
  Call_ApiSchemaGet_574445 = ref object of OpenApiRestCall_573657
proc url_ApiSchemaGet_574447(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "schemaId" in path, "`schemaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiSchemaGet_574446(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the schema configuration at the API level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   schemaId: JString (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574448 = path.getOrDefault("apiId")
  valid_574448 = validateParameter(valid_574448, JString, required = true,
                                 default = nil)
  if valid_574448 != nil:
    section.add "apiId", valid_574448
  var valid_574449 = path.getOrDefault("schemaId")
  valid_574449 = validateParameter(valid_574449, JString, required = true,
                                 default = nil)
  if valid_574449 != nil:
    section.add "schemaId", valid_574449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574450 = query.getOrDefault("api-version")
  valid_574450 = validateParameter(valid_574450, JString, required = true,
                                 default = nil)
  if valid_574450 != nil:
    section.add "api-version", valid_574450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574451: Call_ApiSchemaGet_574445; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the schema configuration at the API level.
  ## 
  let valid = call_574451.validator(path, query, header, formData, body)
  let scheme = call_574451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574451.url(scheme.get, call_574451.host, call_574451.base,
                         call_574451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574451, url, valid)

proc call*(call_574452: Call_ApiSchemaGet_574445; apiVersion: string; apiId: string;
          schemaId: string): Recallable =
  ## apiSchemaGet
  ## Get the schema configuration at the API level.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   schemaId: string (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  var path_574453 = newJObject()
  var query_574454 = newJObject()
  add(query_574454, "api-version", newJString(apiVersion))
  add(path_574453, "apiId", newJString(apiId))
  add(path_574453, "schemaId", newJString(schemaId))
  result = call_574452.call(path_574453, query_574454, nil, nil, nil)

var apiSchemaGet* = Call_ApiSchemaGet_574445(name: "apiSchemaGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apis/{apiId}/schemas/{schemaId}", validator: validate_ApiSchemaGet_574446,
    base: "", url: url_ApiSchemaGet_574447, schemes: {Scheme.Https})
type
  Call_ApiSchemaDelete_574468 = ref object of OpenApiRestCall_573657
proc url_ApiSchemaDelete_574470(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "schemaId" in path, "`schemaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiSchemaDelete_574469(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes the schema configuration at the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   schemaId: JString (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `apiId` field"
  var valid_574471 = path.getOrDefault("apiId")
  valid_574471 = validateParameter(valid_574471, JString, required = true,
                                 default = nil)
  if valid_574471 != nil:
    section.add "apiId", valid_574471
  var valid_574472 = path.getOrDefault("schemaId")
  valid_574472 = validateParameter(valid_574472, JString, required = true,
                                 default = nil)
  if valid_574472 != nil:
    section.add "schemaId", valid_574472
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574473 = query.getOrDefault("api-version")
  valid_574473 = validateParameter(valid_574473, JString, required = true,
                                 default = nil)
  if valid_574473 != nil:
    section.add "api-version", valid_574473
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api schema to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574474 = header.getOrDefault("If-Match")
  valid_574474 = validateParameter(valid_574474, JString, required = true,
                                 default = nil)
  if valid_574474 != nil:
    section.add "If-Match", valid_574474
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574475: Call_ApiSchemaDelete_574468; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the schema configuration at the Api.
  ## 
  let valid = call_574475.validator(path, query, header, formData, body)
  let scheme = call_574475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574475.url(scheme.get, call_574475.host, call_574475.base,
                         call_574475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574475, url, valid)

proc call*(call_574476: Call_ApiSchemaDelete_574468; apiVersion: string;
          apiId: string; schemaId: string): Recallable =
  ## apiSchemaDelete
  ## Deletes the schema configuration at the Api.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   schemaId: string (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  var path_574477 = newJObject()
  var query_574478 = newJObject()
  add(query_574478, "api-version", newJString(apiVersion))
  add(path_574477, "apiId", newJString(apiId))
  add(path_574477, "schemaId", newJString(schemaId))
  result = call_574476.call(path_574477, query_574478, nil, nil, nil)

var apiSchemaDelete* = Call_ApiSchemaDelete_574468(name: "apiSchemaDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaDelete_574469, base: "", url: url_ApiSchemaDelete_574470,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
