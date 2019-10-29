
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimapis"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ApiList_563777 = ref object of OpenApiRestCall_563555
proc url_ApiList_563779(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApiList_563778(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all APIs of the API Management service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-apis
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
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  section = newJObject()
  var valid_563928 = query.getOrDefault("$top")
  valid_563928 = validateParameter(valid_563928, JInt, required = false, default = nil)
  if valid_563928 != nil:
    section.add "$top", valid_563928
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563929 = query.getOrDefault("api-version")
  valid_563929 = validateParameter(valid_563929, JString, required = true,
                                 default = nil)
  if valid_563929 != nil:
    section.add "api-version", valid_563929
  var valid_563930 = query.getOrDefault("$skip")
  valid_563930 = validateParameter(valid_563930, JInt, required = false, default = nil)
  if valid_563930 != nil:
    section.add "$skip", valid_563930
  var valid_563931 = query.getOrDefault("$filter")
  valid_563931 = validateParameter(valid_563931, JString, required = false,
                                 default = nil)
  if valid_563931 != nil:
    section.add "$filter", valid_563931
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563958: Call_ApiList_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all APIs of the API Management service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-apis
  let valid = call_563958.validator(path, query, header, formData, body)
  let scheme = call_563958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563958.url(scheme.get, call_563958.host, call_563958.base,
                         call_563958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563958, url, valid)

proc call*(call_564029: Call_ApiList_563777; apiVersion: string; Top: int = 0;
          Skip: int = 0; Filter: string = ""): Recallable =
  ## apiList
  ## Lists all APIs of the API Management service instance.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-apis
  ##   Top: int
  ##      : Number of records to return.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
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
  var query_564030 = newJObject()
  add(query_564030, "$top", newJInt(Top))
  add(query_564030, "api-version", newJString(apiVersion))
  add(query_564030, "$skip", newJInt(Skip))
  add(query_564030, "$filter", newJString(Filter))
  result = call_564029.call(nil, query_564030, nil, nil, nil)

var apiList* = Call_ApiList_563777(name: "apiList", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/apis",
                                validator: validate_ApiList_563778, base: "",
                                url: url_ApiList_563779, schemes: {Scheme.Https})
type
  Call_ApiCreateOrUpdate_564102 = ref object of OpenApiRestCall_563555
proc url_ApiCreateOrUpdate_564104(protocol: Scheme; host: string; base: string;
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

proc validate_ApiCreateOrUpdate_564103(path: JsonNode; query: JsonNode;
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
  var valid_564122 = path.getOrDefault("apiId")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "apiId", valid_564122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564123 = query.getOrDefault("api-version")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "api-version", valid_564123
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Api Entity. For Create Api Etag should not be specified. For Update Etag should match the existing Entity or it can be * for unconditional update.
  section = newJObject()
  var valid_564124 = header.getOrDefault("If-Match")
  valid_564124 = validateParameter(valid_564124, JString, required = false,
                                 default = nil)
  if valid_564124 != nil:
    section.add "If-Match", valid_564124
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

proc call*(call_564126: Call_ApiCreateOrUpdate_564102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates new or updates existing specified API of the API Management service instance.
  ## 
  let valid = call_564126.validator(path, query, header, formData, body)
  let scheme = call_564126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564126.url(scheme.get, call_564126.host, call_564126.base,
                         call_564126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564126, url, valid)

proc call*(call_564127: Call_ApiCreateOrUpdate_564102; apiVersion: string;
          apiId: string; parameters: JsonNode): Recallable =
  ## apiCreateOrUpdate
  ## Creates new or updates existing specified API of the API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  var path_564128 = newJObject()
  var query_564129 = newJObject()
  var body_564130 = newJObject()
  add(query_564129, "api-version", newJString(apiVersion))
  add(path_564128, "apiId", newJString(apiId))
  if parameters != nil:
    body_564130 = parameters
  result = call_564127.call(path_564128, query_564129, nil, nil, body_564130)

var apiCreateOrUpdate* = Call_ApiCreateOrUpdate_564102(name: "apiCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "azure.local", route: "/apis/{apiId}",
    validator: validate_ApiCreateOrUpdate_564103, base: "",
    url: url_ApiCreateOrUpdate_564104, schemes: {Scheme.Https})
type
  Call_ApiGet_564070 = ref object of OpenApiRestCall_563555
proc url_ApiGet_564072(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ApiGet_564071(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564096 = path.getOrDefault("apiId")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "apiId", valid_564096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564097 = query.getOrDefault("api-version")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "api-version", valid_564097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564098: Call_ApiGet_564070; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the API specified by its identifier.
  ## 
  let valid = call_564098.validator(path, query, header, formData, body)
  let scheme = call_564098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564098.url(scheme.get, call_564098.host, call_564098.base,
                         call_564098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564098, url, valid)

proc call*(call_564099: Call_ApiGet_564070; apiVersion: string; apiId: string): Recallable =
  ## apiGet
  ## Gets the details of the API specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  var path_564100 = newJObject()
  var query_564101 = newJObject()
  add(query_564101, "api-version", newJString(apiVersion))
  add(path_564100, "apiId", newJString(apiId))
  result = call_564099.call(path_564100, query_564101, nil, nil, nil)

var apiGet* = Call_ApiGet_564070(name: "apiGet", meth: HttpMethod.HttpGet,
                              host: "azure.local", route: "/apis/{apiId}",
                              validator: validate_ApiGet_564071, base: "",
                              url: url_ApiGet_564072, schemes: {Scheme.Https})
type
  Call_ApiUpdate_564141 = ref object of OpenApiRestCall_563555
proc url_ApiUpdate_564143(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ApiUpdate_564142(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564154 = path.getOrDefault("apiId")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "apiId", valid_564154
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
  ##           : ETag of the API entity. ETag should match the current entity state in the header response of the GET request or it should be * for unconditional update.
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
  ##             : API Update Contract parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564158: Call_ApiUpdate_564141; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified API of the API Management service instance.
  ## 
  let valid = call_564158.validator(path, query, header, formData, body)
  let scheme = call_564158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564158.url(scheme.get, call_564158.host, call_564158.base,
                         call_564158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564158, url, valid)

proc call*(call_564159: Call_ApiUpdate_564141; apiVersion: string; apiId: string;
          parameters: JsonNode): Recallable =
  ## apiUpdate
  ## Updates the specified API of the API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : API Update Contract parameters.
  var path_564160 = newJObject()
  var query_564161 = newJObject()
  var body_564162 = newJObject()
  add(query_564161, "api-version", newJString(apiVersion))
  add(path_564160, "apiId", newJString(apiId))
  if parameters != nil:
    body_564162 = parameters
  result = call_564159.call(path_564160, query_564161, nil, nil, body_564162)

var apiUpdate* = Call_ApiUpdate_564141(name: "apiUpdate", meth: HttpMethod.HttpPatch,
                                    host: "azure.local", route: "/apis/{apiId}",
                                    validator: validate_ApiUpdate_564142,
                                    base: "", url: url_ApiUpdate_564143,
                                    schemes: {Scheme.Https})
type
  Call_ApiDelete_564131 = ref object of OpenApiRestCall_563555
proc url_ApiDelete_564133(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ApiDelete_564132(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564134 = path.getOrDefault("apiId")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "apiId", valid_564134
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
  ##           : ETag of the API Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
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

proc call*(call_564137: Call_ApiDelete_564131; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified API of the API Management service instance.
  ## 
  let valid = call_564137.validator(path, query, header, formData, body)
  let scheme = call_564137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564137.url(scheme.get, call_564137.host, call_564137.base,
                         call_564137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564137, url, valid)

proc call*(call_564138: Call_ApiDelete_564131; apiVersion: string; apiId: string): Recallable =
  ## apiDelete
  ## Deletes the specified API of the API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  var path_564139 = newJObject()
  var query_564140 = newJObject()
  add(query_564140, "api-version", newJString(apiVersion))
  add(path_564139, "apiId", newJString(apiId))
  result = call_564138.call(path_564139, query_564140, nil, nil, nil)

var apiDelete* = Call_ApiDelete_564131(name: "apiDelete",
                                    meth: HttpMethod.HttpDelete,
                                    host: "azure.local", route: "/apis/{apiId}",
                                    validator: validate_ApiDelete_564132,
                                    base: "", url: url_ApiDelete_564133,
                                    schemes: {Scheme.Https})
type
  Call_ApiOperationListByApi_564163 = ref object of OpenApiRestCall_563555
proc url_ApiOperationListByApi_564165(protocol: Scheme; host: string; base: string;
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

proc validate_ApiOperationListByApi_564164(path: JsonNode; query: JsonNode;
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
  var valid_564166 = path.getOrDefault("apiId")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "apiId", valid_564166
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Number of records to return.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
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
  var valid_564167 = query.getOrDefault("$top")
  valid_564167 = validateParameter(valid_564167, JInt, required = false, default = nil)
  if valid_564167 != nil:
    section.add "$top", valid_564167
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564168 = query.getOrDefault("api-version")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "api-version", valid_564168
  var valid_564169 = query.getOrDefault("$skip")
  valid_564169 = validateParameter(valid_564169, JInt, required = false, default = nil)
  if valid_564169 != nil:
    section.add "$skip", valid_564169
  var valid_564170 = query.getOrDefault("$filter")
  valid_564170 = validateParameter(valid_564170, JString, required = false,
                                 default = nil)
  if valid_564170 != nil:
    section.add "$filter", valid_564170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564171: Call_ApiOperationListByApi_564163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of the operations for the specified API.
  ## 
  let valid = call_564171.validator(path, query, header, formData, body)
  let scheme = call_564171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564171.url(scheme.get, call_564171.host, call_564171.base,
                         call_564171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564171, url, valid)

proc call*(call_564172: Call_ApiOperationListByApi_564163; apiVersion: string;
          apiId: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiOperationListByApi
  ## Lists a collection of the operations for the specified API.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | method      | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_564173 = newJObject()
  var query_564174 = newJObject()
  add(query_564174, "$top", newJInt(Top))
  add(query_564174, "api-version", newJString(apiVersion))
  add(path_564173, "apiId", newJString(apiId))
  add(query_564174, "$skip", newJInt(Skip))
  add(query_564174, "$filter", newJString(Filter))
  result = call_564172.call(path_564173, query_564174, nil, nil, nil)

var apiOperationListByApi* = Call_ApiOperationListByApi_564163(
    name: "apiOperationListByApi", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apis/{apiId}/operations", validator: validate_ApiOperationListByApi_564164,
    base: "", url: url_ApiOperationListByApi_564165, schemes: {Scheme.Https})
type
  Call_ApiOperationCreateOrUpdate_564185 = ref object of OpenApiRestCall_563555
proc url_ApiOperationCreateOrUpdate_564187(protocol: Scheme; host: string;
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

proc validate_ApiOperationCreateOrUpdate_564186(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new operation in the API or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_564188 = path.getOrDefault("operationId")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "operationId", valid_564188
  var valid_564189 = path.getOrDefault("apiId")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "apiId", valid_564189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564190 = query.getOrDefault("api-version")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "api-version", valid_564190
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

proc call*(call_564192: Call_ApiOperationCreateOrUpdate_564185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new operation in the API or updates an existing one.
  ## 
  let valid = call_564192.validator(path, query, header, formData, body)
  let scheme = call_564192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564192.url(scheme.get, call_564192.host, call_564192.base,
                         call_564192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564192, url, valid)

proc call*(call_564193: Call_ApiOperationCreateOrUpdate_564185; apiVersion: string;
          operationId: string; apiId: string; parameters: JsonNode): Recallable =
  ## apiOperationCreateOrUpdate
  ## Creates a new operation in the API or updates an existing one.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  var path_564194 = newJObject()
  var query_564195 = newJObject()
  var body_564196 = newJObject()
  add(query_564195, "api-version", newJString(apiVersion))
  add(path_564194, "operationId", newJString(operationId))
  add(path_564194, "apiId", newJString(apiId))
  if parameters != nil:
    body_564196 = parameters
  result = call_564193.call(path_564194, query_564195, nil, nil, body_564196)

var apiOperationCreateOrUpdate* = Call_ApiOperationCreateOrUpdate_564185(
    name: "apiOperationCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationCreateOrUpdate_564186, base: "",
    url: url_ApiOperationCreateOrUpdate_564187, schemes: {Scheme.Https})
type
  Call_ApiOperationGet_564175 = ref object of OpenApiRestCall_563555
proc url_ApiOperationGet_564177(protocol: Scheme; host: string; base: string;
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

proc validate_ApiOperationGet_564176(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the details of the API Operation specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_564178 = path.getOrDefault("operationId")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "operationId", valid_564178
  var valid_564179 = path.getOrDefault("apiId")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "apiId", valid_564179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564180 = query.getOrDefault("api-version")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "api-version", valid_564180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564181: Call_ApiOperationGet_564175; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the API Operation specified by its identifier.
  ## 
  let valid = call_564181.validator(path, query, header, formData, body)
  let scheme = call_564181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564181.url(scheme.get, call_564181.host, call_564181.base,
                         call_564181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564181, url, valid)

proc call*(call_564182: Call_ApiOperationGet_564175; apiVersion: string;
          operationId: string; apiId: string): Recallable =
  ## apiOperationGet
  ## Gets the details of the API Operation specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  var path_564183 = newJObject()
  var query_564184 = newJObject()
  add(query_564184, "api-version", newJString(apiVersion))
  add(path_564183, "operationId", newJString(operationId))
  add(path_564183, "apiId", newJString(apiId))
  result = call_564182.call(path_564183, query_564184, nil, nil, nil)

var apiOperationGet* = Call_ApiOperationGet_564175(name: "apiOperationGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationGet_564176, base: "", url: url_ApiOperationGet_564177,
    schemes: {Scheme.Https})
type
  Call_ApiOperationUpdate_564208 = ref object of OpenApiRestCall_563555
proc url_ApiOperationUpdate_564210(protocol: Scheme; host: string; base: string;
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

proc validate_ApiOperationUpdate_564209(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the details of the operation in the API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_564211 = path.getOrDefault("operationId")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "operationId", valid_564211
  var valid_564212 = path.getOrDefault("apiId")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "apiId", valid_564212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564213 = query.getOrDefault("api-version")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "api-version", valid_564213
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the API Operation Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564214 = header.getOrDefault("If-Match")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "If-Match", valid_564214
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

proc call*(call_564216: Call_ApiOperationUpdate_564208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the operation in the API specified by its identifier.
  ## 
  let valid = call_564216.validator(path, query, header, formData, body)
  let scheme = call_564216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564216.url(scheme.get, call_564216.host, call_564216.base,
                         call_564216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564216, url, valid)

proc call*(call_564217: Call_ApiOperationUpdate_564208; apiVersion: string;
          operationId: string; apiId: string; parameters: JsonNode): Recallable =
  ## apiOperationUpdate
  ## Updates the details of the operation in the API specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : API Operation Update parameters.
  var path_564218 = newJObject()
  var query_564219 = newJObject()
  var body_564220 = newJObject()
  add(query_564219, "api-version", newJString(apiVersion))
  add(path_564218, "operationId", newJString(operationId))
  add(path_564218, "apiId", newJString(apiId))
  if parameters != nil:
    body_564220 = parameters
  result = call_564217.call(path_564218, query_564219, nil, nil, body_564220)

var apiOperationUpdate* = Call_ApiOperationUpdate_564208(
    name: "apiOperationUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationUpdate_564209, base: "",
    url: url_ApiOperationUpdate_564210, schemes: {Scheme.Https})
type
  Call_ApiOperationDelete_564197 = ref object of OpenApiRestCall_563555
proc url_ApiOperationDelete_564199(protocol: Scheme; host: string; base: string;
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

proc validate_ApiOperationDelete_564198(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the specified operation in the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_564200 = path.getOrDefault("operationId")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "operationId", valid_564200
  var valid_564201 = path.getOrDefault("apiId")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "apiId", valid_564201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564202 = query.getOrDefault("api-version")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "api-version", valid_564202
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the API Operation Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564203 = header.getOrDefault("If-Match")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "If-Match", valid_564203
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564204: Call_ApiOperationDelete_564197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified operation in the API.
  ## 
  let valid = call_564204.validator(path, query, header, formData, body)
  let scheme = call_564204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564204.url(scheme.get, call_564204.host, call_564204.base,
                         call_564204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564204, url, valid)

proc call*(call_564205: Call_ApiOperationDelete_564197; apiVersion: string;
          operationId: string; apiId: string): Recallable =
  ## apiOperationDelete
  ## Deletes the specified operation in the API.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  var path_564206 = newJObject()
  var query_564207 = newJObject()
  add(query_564207, "api-version", newJString(apiVersion))
  add(path_564206, "operationId", newJString(operationId))
  add(path_564206, "apiId", newJString(apiId))
  result = call_564205.call(path_564206, query_564207, nil, nil, nil)

var apiOperationDelete* = Call_ApiOperationDelete_564197(
    name: "apiOperationDelete", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationDelete_564198, base: "",
    url: url_ApiOperationDelete_564199, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyListByOperation_564221 = ref object of OpenApiRestCall_563555
proc url_ApiOperationPolicyListByOperation_564223(protocol: Scheme; host: string;
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

proc validate_ApiOperationPolicyListByOperation_564222(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of policy configuration at the API Operation level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_564224 = path.getOrDefault("operationId")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "operationId", valid_564224
  var valid_564225 = path.getOrDefault("apiId")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "apiId", valid_564225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564226 = query.getOrDefault("api-version")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "api-version", valid_564226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564227: Call_ApiOperationPolicyListByOperation_564221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the list of policy configuration at the API Operation level.
  ## 
  let valid = call_564227.validator(path, query, header, formData, body)
  let scheme = call_564227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564227.url(scheme.get, call_564227.host, call_564227.base,
                         call_564227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564227, url, valid)

proc call*(call_564228: Call_ApiOperationPolicyListByOperation_564221;
          apiVersion: string; operationId: string; apiId: string): Recallable =
  ## apiOperationPolicyListByOperation
  ## Get the list of policy configuration at the API Operation level.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  var path_564229 = newJObject()
  var query_564230 = newJObject()
  add(query_564230, "api-version", newJString(apiVersion))
  add(path_564229, "operationId", newJString(operationId))
  add(path_564229, "apiId", newJString(apiId))
  result = call_564228.call(path_564229, query_564230, nil, nil, nil)

var apiOperationPolicyListByOperation* = Call_ApiOperationPolicyListByOperation_564221(
    name: "apiOperationPolicyListByOperation", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apis/{apiId}/operations/{operationId}/policies",
    validator: validate_ApiOperationPolicyListByOperation_564222, base: "",
    url: url_ApiOperationPolicyListByOperation_564223, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyCreateOrUpdate_564255 = ref object of OpenApiRestCall_563555
proc url_ApiOperationPolicyCreateOrUpdate_564257(protocol: Scheme; host: string;
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

proc validate_ApiOperationPolicyCreateOrUpdate_564256(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates policy configuration for the API Operation level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_564258 = path.getOrDefault("operationId")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "operationId", valid_564258
  var valid_564259 = path.getOrDefault("apiId")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "apiId", valid_564259
  var valid_564260 = path.getOrDefault("policyId")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = newJString("policy"))
  if valid_564260 != nil:
    section.add "policyId", valid_564260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564261 = query.getOrDefault("api-version")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "api-version", valid_564261
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api Operation policy to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564262 = header.getOrDefault("If-Match")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "If-Match", valid_564262
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

proc call*(call_564264: Call_ApiOperationPolicyCreateOrUpdate_564255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates policy configuration for the API Operation level.
  ## 
  let valid = call_564264.validator(path, query, header, formData, body)
  let scheme = call_564264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564264.url(scheme.get, call_564264.host, call_564264.base,
                         call_564264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564264, url, valid)

proc call*(call_564265: Call_ApiOperationPolicyCreateOrUpdate_564255;
          apiVersion: string; operationId: string; apiId: string;
          parameters: JsonNode; policyId: string = "policy"): Recallable =
  ## apiOperationPolicyCreateOrUpdate
  ## Creates or updates policy configuration for the API Operation level.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  var path_564266 = newJObject()
  var query_564267 = newJObject()
  var body_564268 = newJObject()
  add(query_564267, "api-version", newJString(apiVersion))
  add(path_564266, "operationId", newJString(operationId))
  add(path_564266, "apiId", newJString(apiId))
  add(path_564266, "policyId", newJString(policyId))
  if parameters != nil:
    body_564268 = parameters
  result = call_564265.call(path_564266, query_564267, nil, nil, body_564268)

var apiOperationPolicyCreateOrUpdate* = Call_ApiOperationPolicyCreateOrUpdate_564255(
    name: "apiOperationPolicyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyCreateOrUpdate_564256, base: "",
    url: url_ApiOperationPolicyCreateOrUpdate_564257, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyGet_564231 = ref object of OpenApiRestCall_563555
proc url_ApiOperationPolicyGet_564233(protocol: Scheme; host: string; base: string;
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

proc validate_ApiOperationPolicyGet_564232(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the policy configuration at the API Operation level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_564234 = path.getOrDefault("operationId")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "operationId", valid_564234
  var valid_564235 = path.getOrDefault("apiId")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "apiId", valid_564235
  var valid_564249 = path.getOrDefault("policyId")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = newJString("policy"))
  if valid_564249 != nil:
    section.add "policyId", valid_564249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564250 = query.getOrDefault("api-version")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "api-version", valid_564250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564251: Call_ApiOperationPolicyGet_564231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the API Operation level.
  ## 
  let valid = call_564251.validator(path, query, header, formData, body)
  let scheme = call_564251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564251.url(scheme.get, call_564251.host, call_564251.base,
                         call_564251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564251, url, valid)

proc call*(call_564252: Call_ApiOperationPolicyGet_564231; apiVersion: string;
          operationId: string; apiId: string; policyId: string = "policy"): Recallable =
  ## apiOperationPolicyGet
  ## Get the policy configuration at the API Operation level.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  var path_564253 = newJObject()
  var query_564254 = newJObject()
  add(query_564254, "api-version", newJString(apiVersion))
  add(path_564253, "operationId", newJString(operationId))
  add(path_564253, "apiId", newJString(apiId))
  add(path_564253, "policyId", newJString(policyId))
  result = call_564252.call(path_564253, query_564254, nil, nil, nil)

var apiOperationPolicyGet* = Call_ApiOperationPolicyGet_564231(
    name: "apiOperationPolicyGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyGet_564232, base: "",
    url: url_ApiOperationPolicyGet_564233, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyDelete_564269 = ref object of OpenApiRestCall_563555
proc url_ApiOperationPolicyDelete_564271(protocol: Scheme; host: string;
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

proc validate_ApiOperationPolicyDelete_564270(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the policy configuration at the Api Operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_564272 = path.getOrDefault("operationId")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "operationId", valid_564272
  var valid_564273 = path.getOrDefault("apiId")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "apiId", valid_564273
  var valid_564274 = path.getOrDefault("policyId")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = newJString("policy"))
  if valid_564274 != nil:
    section.add "policyId", valid_564274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564275 = query.getOrDefault("api-version")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "api-version", valid_564275
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api Operation Policy to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564276 = header.getOrDefault("If-Match")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "If-Match", valid_564276
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564277: Call_ApiOperationPolicyDelete_564269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the policy configuration at the Api Operation.
  ## 
  let valid = call_564277.validator(path, query, header, formData, body)
  let scheme = call_564277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564277.url(scheme.get, call_564277.host, call_564277.base,
                         call_564277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564277, url, valid)

proc call*(call_564278: Call_ApiOperationPolicyDelete_564269; apiVersion: string;
          operationId: string; apiId: string; policyId: string = "policy"): Recallable =
  ## apiOperationPolicyDelete
  ## Deletes the policy configuration at the Api Operation.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  var path_564279 = newJObject()
  var query_564280 = newJObject()
  add(query_564280, "api-version", newJString(apiVersion))
  add(path_564279, "operationId", newJString(operationId))
  add(path_564279, "apiId", newJString(apiId))
  add(path_564279, "policyId", newJString(policyId))
  result = call_564278.call(path_564279, query_564280, nil, nil, nil)

var apiOperationPolicyDelete* = Call_ApiOperationPolicyDelete_564269(
    name: "apiOperationPolicyDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyDelete_564270, base: "",
    url: url_ApiOperationPolicyDelete_564271, schemes: {Scheme.Https})
type
  Call_ApiPolicyListByApi_564281 = ref object of OpenApiRestCall_563555
proc url_ApiPolicyListByApi_564283(protocol: Scheme; host: string; base: string;
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

proc validate_ApiPolicyListByApi_564282(path: JsonNode; query: JsonNode;
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
  var valid_564284 = path.getOrDefault("apiId")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "apiId", valid_564284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564285 = query.getOrDefault("api-version")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "api-version", valid_564285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564286: Call_ApiPolicyListByApi_564281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the API level.
  ## 
  let valid = call_564286.validator(path, query, header, formData, body)
  let scheme = call_564286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564286.url(scheme.get, call_564286.host, call_564286.base,
                         call_564286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564286, url, valid)

proc call*(call_564287: Call_ApiPolicyListByApi_564281; apiVersion: string;
          apiId: string): Recallable =
  ## apiPolicyListByApi
  ## Get the policy configuration at the API level.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  var path_564288 = newJObject()
  var query_564289 = newJObject()
  add(query_564289, "api-version", newJString(apiVersion))
  add(path_564288, "apiId", newJString(apiId))
  result = call_564287.call(path_564288, query_564289, nil, nil, nil)

var apiPolicyListByApi* = Call_ApiPolicyListByApi_564281(
    name: "apiPolicyListByApi", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apis/{apiId}/policies", validator: validate_ApiPolicyListByApi_564282,
    base: "", url: url_ApiPolicyListByApi_564283, schemes: {Scheme.Https})
type
  Call_ApiPolicyCreateOrUpdate_564300 = ref object of OpenApiRestCall_563555
proc url_ApiPolicyCreateOrUpdate_564302(protocol: Scheme; host: string; base: string;
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

proc validate_ApiPolicyCreateOrUpdate_564301(path: JsonNode; query: JsonNode;
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
  var valid_564303 = path.getOrDefault("apiId")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "apiId", valid_564303
  var valid_564304 = path.getOrDefault("policyId")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = newJString("policy"))
  if valid_564304 != nil:
    section.add "policyId", valid_564304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564305 = query.getOrDefault("api-version")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "api-version", valid_564305
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api Policy to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564306 = header.getOrDefault("If-Match")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "If-Match", valid_564306
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

proc call*(call_564308: Call_ApiPolicyCreateOrUpdate_564300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates policy configuration for the API.
  ## 
  let valid = call_564308.validator(path, query, header, formData, body)
  let scheme = call_564308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564308.url(scheme.get, call_564308.host, call_564308.base,
                         call_564308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564308, url, valid)

proc call*(call_564309: Call_ApiPolicyCreateOrUpdate_564300; apiVersion: string;
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
  var path_564310 = newJObject()
  var query_564311 = newJObject()
  var body_564312 = newJObject()
  add(query_564311, "api-version", newJString(apiVersion))
  add(path_564310, "apiId", newJString(apiId))
  add(path_564310, "policyId", newJString(policyId))
  if parameters != nil:
    body_564312 = parameters
  result = call_564309.call(path_564310, query_564311, nil, nil, body_564312)

var apiPolicyCreateOrUpdate* = Call_ApiPolicyCreateOrUpdate_564300(
    name: "apiPolicyCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyCreateOrUpdate_564301, base: "",
    url: url_ApiPolicyCreateOrUpdate_564302, schemes: {Scheme.Https})
type
  Call_ApiPolicyGet_564290 = ref object of OpenApiRestCall_563555
proc url_ApiPolicyGet_564292(protocol: Scheme; host: string; base: string;
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

proc validate_ApiPolicyGet_564291(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564293 = path.getOrDefault("apiId")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "apiId", valid_564293
  var valid_564294 = path.getOrDefault("policyId")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = newJString("policy"))
  if valid_564294 != nil:
    section.add "policyId", valid_564294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564295 = query.getOrDefault("api-version")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "api-version", valid_564295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564296: Call_ApiPolicyGet_564290; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the API level.
  ## 
  let valid = call_564296.validator(path, query, header, formData, body)
  let scheme = call_564296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564296.url(scheme.get, call_564296.host, call_564296.base,
                         call_564296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564296, url, valid)

proc call*(call_564297: Call_ApiPolicyGet_564290; apiVersion: string; apiId: string;
          policyId: string = "policy"): Recallable =
  ## apiPolicyGet
  ## Get the policy configuration at the API level.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  var path_564298 = newJObject()
  var query_564299 = newJObject()
  add(query_564299, "api-version", newJString(apiVersion))
  add(path_564298, "apiId", newJString(apiId))
  add(path_564298, "policyId", newJString(policyId))
  result = call_564297.call(path_564298, query_564299, nil, nil, nil)

var apiPolicyGet* = Call_ApiPolicyGet_564290(name: "apiPolicyGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apis/{apiId}/policies/{policyId}", validator: validate_ApiPolicyGet_564291,
    base: "", url: url_ApiPolicyGet_564292, schemes: {Scheme.Https})
type
  Call_ApiPolicyDelete_564313 = ref object of OpenApiRestCall_563555
proc url_ApiPolicyDelete_564315(protocol: Scheme; host: string; base: string;
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

proc validate_ApiPolicyDelete_564314(path: JsonNode; query: JsonNode;
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
  var valid_564316 = path.getOrDefault("apiId")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "apiId", valid_564316
  var valid_564317 = path.getOrDefault("policyId")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = newJString("policy"))
  if valid_564317 != nil:
    section.add "policyId", valid_564317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564318 = query.getOrDefault("api-version")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "api-version", valid_564318
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api policy to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564319 = header.getOrDefault("If-Match")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "If-Match", valid_564319
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564320: Call_ApiPolicyDelete_564313; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the policy configuration at the Api.
  ## 
  let valid = call_564320.validator(path, query, header, formData, body)
  let scheme = call_564320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564320.url(scheme.get, call_564320.host, call_564320.base,
                         call_564320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564320, url, valid)

proc call*(call_564321: Call_ApiPolicyDelete_564313; apiVersion: string;
          apiId: string; policyId: string = "policy"): Recallable =
  ## apiPolicyDelete
  ## Deletes the policy configuration at the Api.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  var path_564322 = newJObject()
  var query_564323 = newJObject()
  add(query_564323, "api-version", newJString(apiVersion))
  add(path_564322, "apiId", newJString(apiId))
  add(path_564322, "policyId", newJString(policyId))
  result = call_564321.call(path_564322, query_564323, nil, nil, nil)

var apiPolicyDelete* = Call_ApiPolicyDelete_564313(name: "apiPolicyDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyDelete_564314, base: "", url: url_ApiPolicyDelete_564315,
    schemes: {Scheme.Https})
type
  Call_ApiProductListByApis_564324 = ref object of OpenApiRestCall_563555
proc url_ApiProductListByApis_564326(protocol: Scheme; host: string; base: string;
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

proc validate_ApiProductListByApis_564325(path: JsonNode; query: JsonNode;
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
  var valid_564327 = path.getOrDefault("apiId")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "apiId", valid_564327
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
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  var valid_564328 = query.getOrDefault("$top")
  valid_564328 = validateParameter(valid_564328, JInt, required = false, default = nil)
  if valid_564328 != nil:
    section.add "$top", valid_564328
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564329 = query.getOrDefault("api-version")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "api-version", valid_564329
  var valid_564330 = query.getOrDefault("$skip")
  valid_564330 = validateParameter(valid_564330, JInt, required = false, default = nil)
  if valid_564330 != nil:
    section.add "$skip", valid_564330
  var valid_564331 = query.getOrDefault("$filter")
  valid_564331 = validateParameter(valid_564331, JString, required = false,
                                 default = nil)
  if valid_564331 != nil:
    section.add "$filter", valid_564331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564332: Call_ApiProductListByApis_564324; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Products, which the API is part of.
  ## 
  let valid = call_564332.validator(path, query, header, formData, body)
  let scheme = call_564332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564332.url(scheme.get, call_564332.host, call_564332.base,
                         call_564332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564332, url, valid)

proc call*(call_564333: Call_ApiProductListByApis_564324; apiVersion: string;
          apiId: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiProductListByApis
  ## Lists all Products, which the API is part of.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string
  ##         : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_564334 = newJObject()
  var query_564335 = newJObject()
  add(query_564335, "$top", newJInt(Top))
  add(query_564335, "api-version", newJString(apiVersion))
  add(path_564334, "apiId", newJString(apiId))
  add(query_564335, "$skip", newJInt(Skip))
  add(query_564335, "$filter", newJString(Filter))
  result = call_564333.call(path_564334, query_564335, nil, nil, nil)

var apiProductListByApis* = Call_ApiProductListByApis_564324(
    name: "apiProductListByApis", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apis/{apiId}/products", validator: validate_ApiProductListByApis_564325,
    base: "", url: url_ApiProductListByApis_564326, schemes: {Scheme.Https})
type
  Call_ApiSchemaListByApi_564336 = ref object of OpenApiRestCall_563555
proc url_ApiSchemaListByApi_564338(protocol: Scheme; host: string; base: string;
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

proc validate_ApiSchemaListByApi_564337(path: JsonNode; query: JsonNode;
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
  var valid_564339 = path.getOrDefault("apiId")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "apiId", valid_564339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564340 = query.getOrDefault("api-version")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "api-version", valid_564340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564341: Call_ApiSchemaListByApi_564336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the schema configuration at the API level.
  ## 
  let valid = call_564341.validator(path, query, header, formData, body)
  let scheme = call_564341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564341.url(scheme.get, call_564341.host, call_564341.base,
                         call_564341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564341, url, valid)

proc call*(call_564342: Call_ApiSchemaListByApi_564336; apiVersion: string;
          apiId: string): Recallable =
  ## apiSchemaListByApi
  ## Get the schema configuration at the API level.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  var path_564343 = newJObject()
  var query_564344 = newJObject()
  add(query_564344, "api-version", newJString(apiVersion))
  add(path_564343, "apiId", newJString(apiId))
  result = call_564342.call(path_564343, query_564344, nil, nil, nil)

var apiSchemaListByApi* = Call_ApiSchemaListByApi_564336(
    name: "apiSchemaListByApi", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apis/{apiId}/schemas", validator: validate_ApiSchemaListByApi_564337,
    base: "", url: url_ApiSchemaListByApi_564338, schemes: {Scheme.Https})
type
  Call_ApiSchemaCreateOrUpdate_564355 = ref object of OpenApiRestCall_563555
proc url_ApiSchemaCreateOrUpdate_564357(protocol: Scheme; host: string; base: string;
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

proc validate_ApiSchemaCreateOrUpdate_564356(path: JsonNode; query: JsonNode;
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
  var valid_564358 = path.getOrDefault("apiId")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "apiId", valid_564358
  var valid_564359 = path.getOrDefault("schemaId")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "schemaId", valid_564359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564360 = query.getOrDefault("api-version")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "api-version", valid_564360
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (Etag) version of the Api Schema to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  var valid_564361 = header.getOrDefault("If-Match")
  valid_564361 = validateParameter(valid_564361, JString, required = false,
                                 default = nil)
  if valid_564361 != nil:
    section.add "If-Match", valid_564361
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

proc call*(call_564363: Call_ApiSchemaCreateOrUpdate_564355; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates schema configuration for the API.
  ## 
  let valid = call_564363.validator(path, query, header, formData, body)
  let scheme = call_564363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564363.url(scheme.get, call_564363.host, call_564363.base,
                         call_564363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564363, url, valid)

proc call*(call_564364: Call_ApiSchemaCreateOrUpdate_564355; apiVersion: string;
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
  var path_564365 = newJObject()
  var query_564366 = newJObject()
  var body_564367 = newJObject()
  add(query_564366, "api-version", newJString(apiVersion))
  add(path_564365, "apiId", newJString(apiId))
  add(path_564365, "schemaId", newJString(schemaId))
  if parameters != nil:
    body_564367 = parameters
  result = call_564364.call(path_564365, query_564366, nil, nil, body_564367)

var apiSchemaCreateOrUpdate* = Call_ApiSchemaCreateOrUpdate_564355(
    name: "apiSchemaCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaCreateOrUpdate_564356, base: "",
    url: url_ApiSchemaCreateOrUpdate_564357, schemes: {Scheme.Https})
type
  Call_ApiSchemaGet_564345 = ref object of OpenApiRestCall_563555
proc url_ApiSchemaGet_564347(protocol: Scheme; host: string; base: string;
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

proc validate_ApiSchemaGet_564346(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564348 = path.getOrDefault("apiId")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "apiId", valid_564348
  var valid_564349 = path.getOrDefault("schemaId")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "schemaId", valid_564349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564350 = query.getOrDefault("api-version")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "api-version", valid_564350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564351: Call_ApiSchemaGet_564345; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the schema configuration at the API level.
  ## 
  let valid = call_564351.validator(path, query, header, formData, body)
  let scheme = call_564351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564351.url(scheme.get, call_564351.host, call_564351.base,
                         call_564351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564351, url, valid)

proc call*(call_564352: Call_ApiSchemaGet_564345; apiVersion: string; apiId: string;
          schemaId: string): Recallable =
  ## apiSchemaGet
  ## Get the schema configuration at the API level.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   schemaId: string (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  var path_564353 = newJObject()
  var query_564354 = newJObject()
  add(query_564354, "api-version", newJString(apiVersion))
  add(path_564353, "apiId", newJString(apiId))
  add(path_564353, "schemaId", newJString(schemaId))
  result = call_564352.call(path_564353, query_564354, nil, nil, nil)

var apiSchemaGet* = Call_ApiSchemaGet_564345(name: "apiSchemaGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/apis/{apiId}/schemas/{schemaId}", validator: validate_ApiSchemaGet_564346,
    base: "", url: url_ApiSchemaGet_564347, schemes: {Scheme.Https})
type
  Call_ApiSchemaDelete_564368 = ref object of OpenApiRestCall_563555
proc url_ApiSchemaDelete_564370(protocol: Scheme; host: string; base: string;
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

proc validate_ApiSchemaDelete_564369(path: JsonNode; query: JsonNode;
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
  var valid_564371 = path.getOrDefault("apiId")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "apiId", valid_564371
  var valid_564372 = path.getOrDefault("schemaId")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "schemaId", valid_564372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564373 = query.getOrDefault("api-version")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "api-version", valid_564373
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api schema to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564374 = header.getOrDefault("If-Match")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "If-Match", valid_564374
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564375: Call_ApiSchemaDelete_564368; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the schema configuration at the Api.
  ## 
  let valid = call_564375.validator(path, query, header, formData, body)
  let scheme = call_564375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564375.url(scheme.get, call_564375.host, call_564375.base,
                         call_564375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564375, url, valid)

proc call*(call_564376: Call_ApiSchemaDelete_564368; apiVersion: string;
          apiId: string; schemaId: string): Recallable =
  ## apiSchemaDelete
  ## Deletes the schema configuration at the Api.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   schemaId: string (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  var path_564377 = newJObject()
  var query_564378 = newJObject()
  add(query_564378, "api-version", newJString(apiVersion))
  add(path_564377, "apiId", newJString(apiId))
  add(path_564377, "schemaId", newJString(schemaId))
  result = call_564376.call(path_564377, query_564378, nil, nil, nil)

var apiSchemaDelete* = Call_ApiSchemaDelete_564368(name: "apiSchemaDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaDelete_564369, base: "", url: url_ApiSchemaDelete_564370,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
