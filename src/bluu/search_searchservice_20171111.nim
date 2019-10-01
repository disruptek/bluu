
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SearchServiceClient
## version: 2017-11-11
## termsOfService: (not provided)
## license: (not provided)
## 
## Client that can be used to manage and query indexes and documents, as well as manage other resources, on an Azure Search service.
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

  OpenApiRestCall_567667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567667): Option[Scheme] {.used.} =
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
  macServiceName = "search-searchservice"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DataSourcesCreate_568186 = ref object of OpenApiRestCall_567667
proc url_DataSourcesCreate_568188(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DataSourcesCreate_568187(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a new Azure Search datasource.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Data-Source
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568206 = query.getOrDefault("api-version")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "api-version", valid_568206
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568207 = header.getOrDefault("client-request-id")
  valid_568207 = validateParameter(valid_568207, JString, required = false,
                                 default = nil)
  if valid_568207 != nil:
    section.add "client-request-id", valid_568207
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dataSource: JObject (required)
  ##             : The definition of the datasource to create.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568209: Call_DataSourcesCreate_568186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search datasource.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Data-Source
  let valid = call_568209.validator(path, query, header, formData, body)
  let scheme = call_568209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568209.url(scheme.get, call_568209.host, call_568209.base,
                         call_568209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568209, url, valid)

proc call*(call_568210: Call_DataSourcesCreate_568186; apiVersion: string;
          dataSource: JsonNode): Recallable =
  ## dataSourcesCreate
  ## Creates a new Azure Search datasource.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Data-Source
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSource: JObject (required)
  ##             : The definition of the datasource to create.
  var query_568211 = newJObject()
  var body_568212 = newJObject()
  add(query_568211, "api-version", newJString(apiVersion))
  if dataSource != nil:
    body_568212 = dataSource
  result = call_568210.call(nil, query_568211, nil, nil, body_568212)

var dataSourcesCreate* = Call_DataSourcesCreate_568186(name: "dataSourcesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/datasources",
    validator: validate_DataSourcesCreate_568187, base: "",
    url: url_DataSourcesCreate_568188, schemes: {Scheme.Https})
type
  Call_DataSourcesList_567889 = ref object of OpenApiRestCall_567667
proc url_DataSourcesList_567891(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DataSourcesList_567890(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists all datasources available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Data-Sources
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568050 = query.getOrDefault("api-version")
  valid_568050 = validateParameter(valid_568050, JString, required = true,
                                 default = nil)
  if valid_568050 != nil:
    section.add "api-version", valid_568050
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568051 = header.getOrDefault("client-request-id")
  valid_568051 = validateParameter(valid_568051, JString, required = false,
                                 default = nil)
  if valid_568051 != nil:
    section.add "client-request-id", valid_568051
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568074: Call_DataSourcesList_567889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all datasources available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Data-Sources
  let valid = call_568074.validator(path, query, header, formData, body)
  let scheme = call_568074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568074.url(scheme.get, call_568074.host, call_568074.base,
                         call_568074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568074, url, valid)

proc call*(call_568145: Call_DataSourcesList_567889; apiVersion: string): Recallable =
  ## dataSourcesList
  ## Lists all datasources available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Data-Sources
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568146 = newJObject()
  add(query_568146, "api-version", newJString(apiVersion))
  result = call_568145.call(nil, query_568146, nil, nil, nil)

var dataSourcesList* = Call_DataSourcesList_567889(name: "dataSourcesList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/datasources",
    validator: validate_DataSourcesList_567890, base: "", url: url_DataSourcesList_567891,
    schemes: {Scheme.Https})
type
  Call_DataSourcesCreateOrUpdate_568237 = ref object of OpenApiRestCall_567667
proc url_DataSourcesCreateOrUpdate_568239(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "dataSourceName" in path, "`dataSourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/datasources(\'"),
               (kind: VariableSegment, value: "dataSourceName"),
               (kind: ConstantSegment, value: "\')")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataSourcesCreateOrUpdate_568238(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Azure Search datasource or updates a datasource if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Data-Source
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataSourceName: JString (required)
  ##                 : The name of the datasource to create or update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataSourceName` field"
  var valid_568240 = path.getOrDefault("dataSourceName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "dataSourceName", valid_568240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568241 = query.getOrDefault("api-version")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "api-version", valid_568241
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  ##   Prefer: JString (required)
  ##         : For HTTP PUT requests, instructs the service to return the created/updated resource on success.
  section = newJObject()
  var valid_568242 = header.getOrDefault("If-Match")
  valid_568242 = validateParameter(valid_568242, JString, required = false,
                                 default = nil)
  if valid_568242 != nil:
    section.add "If-Match", valid_568242
  var valid_568243 = header.getOrDefault("client-request-id")
  valid_568243 = validateParameter(valid_568243, JString, required = false,
                                 default = nil)
  if valid_568243 != nil:
    section.add "client-request-id", valid_568243
  var valid_568244 = header.getOrDefault("If-None-Match")
  valid_568244 = validateParameter(valid_568244, JString, required = false,
                                 default = nil)
  if valid_568244 != nil:
    section.add "If-None-Match", valid_568244
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_568258 = header.getOrDefault("Prefer")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_568258 != nil:
    section.add "Prefer", valid_568258
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dataSource: JObject (required)
  ##             : The definition of the datasource to create or update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568260: Call_DataSourcesCreateOrUpdate_568237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search datasource or updates a datasource if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Data-Source
  let valid = call_568260.validator(path, query, header, formData, body)
  let scheme = call_568260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568260.url(scheme.get, call_568260.host, call_568260.base,
                         call_568260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568260, url, valid)

proc call*(call_568261: Call_DataSourcesCreateOrUpdate_568237; apiVersion: string;
          dataSourceName: string; dataSource: JsonNode): Recallable =
  ## dataSourcesCreateOrUpdate
  ## Creates a new Azure Search datasource or updates a datasource if it already exists.
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Data-Source
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to create or update.
  ##   dataSource: JObject (required)
  ##             : The definition of the datasource to create or update.
  var path_568262 = newJObject()
  var query_568263 = newJObject()
  var body_568264 = newJObject()
  add(query_568263, "api-version", newJString(apiVersion))
  add(path_568262, "dataSourceName", newJString(dataSourceName))
  if dataSource != nil:
    body_568264 = dataSource
  result = call_568261.call(path_568262, query_568263, nil, nil, body_568264)

var dataSourcesCreateOrUpdate* = Call_DataSourcesCreateOrUpdate_568237(
    name: "dataSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesCreateOrUpdate_568238, base: "",
    url: url_DataSourcesCreateOrUpdate_568239, schemes: {Scheme.Https})
type
  Call_DataSourcesGet_568213 = ref object of OpenApiRestCall_567667
proc url_DataSourcesGet_568215(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "dataSourceName" in path, "`dataSourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/datasources(\'"),
               (kind: VariableSegment, value: "dataSourceName"),
               (kind: ConstantSegment, value: "\')")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataSourcesGet_568214(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves a datasource definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Data-Source
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataSourceName: JString (required)
  ##                 : The name of the datasource to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataSourceName` field"
  var valid_568230 = path.getOrDefault("dataSourceName")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "dataSourceName", valid_568230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568231 = query.getOrDefault("api-version")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "api-version", valid_568231
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568232 = header.getOrDefault("client-request-id")
  valid_568232 = validateParameter(valid_568232, JString, required = false,
                                 default = nil)
  if valid_568232 != nil:
    section.add "client-request-id", valid_568232
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568233: Call_DataSourcesGet_568213; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a datasource definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Data-Source
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_DataSourcesGet_568213; apiVersion: string;
          dataSourceName: string): Recallable =
  ## dataSourcesGet
  ## Retrieves a datasource definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Data-Source
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to retrieve.
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "dataSourceName", newJString(dataSourceName))
  result = call_568234.call(path_568235, query_568236, nil, nil, nil)

var dataSourcesGet* = Call_DataSourcesGet_568213(name: "dataSourcesGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesGet_568214, base: "", url: url_DataSourcesGet_568215,
    schemes: {Scheme.Https})
type
  Call_DataSourcesDelete_568265 = ref object of OpenApiRestCall_567667
proc url_DataSourcesDelete_568267(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "dataSourceName" in path, "`dataSourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/datasources(\'"),
               (kind: VariableSegment, value: "dataSourceName"),
               (kind: ConstantSegment, value: "\')")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataSourcesDelete_568266(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an Azure Search datasource.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Data-Source
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataSourceName: JString (required)
  ##                 : The name of the datasource to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataSourceName` field"
  var valid_568268 = path.getOrDefault("dataSourceName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "dataSourceName", valid_568268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568269 = query.getOrDefault("api-version")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "api-version", valid_568269
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  section = newJObject()
  var valid_568270 = header.getOrDefault("If-Match")
  valid_568270 = validateParameter(valid_568270, JString, required = false,
                                 default = nil)
  if valid_568270 != nil:
    section.add "If-Match", valid_568270
  var valid_568271 = header.getOrDefault("client-request-id")
  valid_568271 = validateParameter(valid_568271, JString, required = false,
                                 default = nil)
  if valid_568271 != nil:
    section.add "client-request-id", valid_568271
  var valid_568272 = header.getOrDefault("If-None-Match")
  valid_568272 = validateParameter(valid_568272, JString, required = false,
                                 default = nil)
  if valid_568272 != nil:
    section.add "If-None-Match", valid_568272
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568273: Call_DataSourcesDelete_568265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search datasource.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Data-Source
  let valid = call_568273.validator(path, query, header, formData, body)
  let scheme = call_568273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568273.url(scheme.get, call_568273.host, call_568273.base,
                         call_568273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568273, url, valid)

proc call*(call_568274: Call_DataSourcesDelete_568265; apiVersion: string;
          dataSourceName: string): Recallable =
  ## dataSourcesDelete
  ## Deletes an Azure Search datasource.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Data-Source
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to delete.
  var path_568275 = newJObject()
  var query_568276 = newJObject()
  add(query_568276, "api-version", newJString(apiVersion))
  add(path_568275, "dataSourceName", newJString(dataSourceName))
  result = call_568274.call(path_568275, query_568276, nil, nil, nil)

var dataSourcesDelete* = Call_DataSourcesDelete_568265(name: "dataSourcesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesDelete_568266, base: "",
    url: url_DataSourcesDelete_568267, schemes: {Scheme.Https})
type
  Call_IndexersCreate_568285 = ref object of OpenApiRestCall_567667
proc url_IndexersCreate_568287(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexersCreate_568286(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates a new Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568288 = query.getOrDefault("api-version")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "api-version", valid_568288
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568289 = header.getOrDefault("client-request-id")
  valid_568289 = validateParameter(valid_568289, JString, required = false,
                                 default = nil)
  if valid_568289 != nil:
    section.add "client-request-id", valid_568289
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   indexer: JObject (required)
  ##          : The definition of the indexer to create.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568291: Call_IndexersCreate_568285; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  let valid = call_568291.validator(path, query, header, formData, body)
  let scheme = call_568291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568291.url(scheme.get, call_568291.host, call_568291.base,
                         call_568291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568291, url, valid)

proc call*(call_568292: Call_IndexersCreate_568285; apiVersion: string;
          indexer: JsonNode): Recallable =
  ## indexersCreate
  ## Creates a new Azure Search indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexer: JObject (required)
  ##          : The definition of the indexer to create.
  var query_568293 = newJObject()
  var body_568294 = newJObject()
  add(query_568293, "api-version", newJString(apiVersion))
  if indexer != nil:
    body_568294 = indexer
  result = call_568292.call(nil, query_568293, nil, nil, body_568294)

var indexersCreate* = Call_IndexersCreate_568285(name: "indexersCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/indexers",
    validator: validate_IndexersCreate_568286, base: "", url: url_IndexersCreate_568287,
    schemes: {Scheme.Https})
type
  Call_IndexersList_568277 = ref object of OpenApiRestCall_567667
proc url_IndexersList_568279(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexersList_568278(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all indexers available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexers
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568280 = query.getOrDefault("api-version")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "api-version", valid_568280
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568281 = header.getOrDefault("client-request-id")
  valid_568281 = validateParameter(valid_568281, JString, required = false,
                                 default = nil)
  if valid_568281 != nil:
    section.add "client-request-id", valid_568281
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568282: Call_IndexersList_568277; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all indexers available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexers
  let valid = call_568282.validator(path, query, header, formData, body)
  let scheme = call_568282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568282.url(scheme.get, call_568282.host, call_568282.base,
                         call_568282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568282, url, valid)

proc call*(call_568283: Call_IndexersList_568277; apiVersion: string): Recallable =
  ## indexersList
  ## Lists all indexers available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexers
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568284 = newJObject()
  add(query_568284, "api-version", newJString(apiVersion))
  result = call_568283.call(nil, query_568284, nil, nil, nil)

var indexersList* = Call_IndexersList_568277(name: "indexersList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/indexers",
    validator: validate_IndexersList_568278, base: "", url: url_IndexersList_568279,
    schemes: {Scheme.Https})
type
  Call_IndexersCreateOrUpdate_568305 = ref object of OpenApiRestCall_567667
proc url_IndexersCreateOrUpdate_568307(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "indexerName" in path, "`indexerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/indexers(\'"),
               (kind: VariableSegment, value: "indexerName"),
               (kind: ConstantSegment, value: "\')")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IndexersCreateOrUpdate_568306(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Azure Search indexer or updates an indexer if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexerName: JString (required)
  ##              : The name of the indexer to create or update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `indexerName` field"
  var valid_568308 = path.getOrDefault("indexerName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "indexerName", valid_568308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568309 = query.getOrDefault("api-version")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "api-version", valid_568309
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  ##   Prefer: JString (required)
  ##         : For HTTP PUT requests, instructs the service to return the created/updated resource on success.
  section = newJObject()
  var valid_568310 = header.getOrDefault("If-Match")
  valid_568310 = validateParameter(valid_568310, JString, required = false,
                                 default = nil)
  if valid_568310 != nil:
    section.add "If-Match", valid_568310
  var valid_568311 = header.getOrDefault("client-request-id")
  valid_568311 = validateParameter(valid_568311, JString, required = false,
                                 default = nil)
  if valid_568311 != nil:
    section.add "client-request-id", valid_568311
  var valid_568312 = header.getOrDefault("If-None-Match")
  valid_568312 = validateParameter(valid_568312, JString, required = false,
                                 default = nil)
  if valid_568312 != nil:
    section.add "If-None-Match", valid_568312
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_568313 = header.getOrDefault("Prefer")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_568313 != nil:
    section.add "Prefer", valid_568313
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   indexer: JObject (required)
  ##          : The definition of the indexer to create or update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568315: Call_IndexersCreateOrUpdate_568305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search indexer or updates an indexer if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  let valid = call_568315.validator(path, query, header, formData, body)
  let scheme = call_568315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568315.url(scheme.get, call_568315.host, call_568315.base,
                         call_568315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568315, url, valid)

proc call*(call_568316: Call_IndexersCreateOrUpdate_568305; apiVersion: string;
          indexerName: string; indexer: JsonNode): Recallable =
  ## indexersCreateOrUpdate
  ## Creates a new Azure Search indexer or updates an indexer if it already exists.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to create or update.
  ##   indexer: JObject (required)
  ##          : The definition of the indexer to create or update.
  var path_568317 = newJObject()
  var query_568318 = newJObject()
  var body_568319 = newJObject()
  add(query_568318, "api-version", newJString(apiVersion))
  add(path_568317, "indexerName", newJString(indexerName))
  if indexer != nil:
    body_568319 = indexer
  result = call_568316.call(path_568317, query_568318, nil, nil, body_568319)

var indexersCreateOrUpdate* = Call_IndexersCreateOrUpdate_568305(
    name: "indexersCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/indexers(\'{indexerName}\')",
    validator: validate_IndexersCreateOrUpdate_568306, base: "",
    url: url_IndexersCreateOrUpdate_568307, schemes: {Scheme.Https})
type
  Call_IndexersGet_568295 = ref object of OpenApiRestCall_567667
proc url_IndexersGet_568297(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "indexerName" in path, "`indexerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/indexers(\'"),
               (kind: VariableSegment, value: "indexerName"),
               (kind: ConstantSegment, value: "\')")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IndexersGet_568296(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves an indexer definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexerName: JString (required)
  ##              : The name of the indexer to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `indexerName` field"
  var valid_568298 = path.getOrDefault("indexerName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "indexerName", valid_568298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568299 = query.getOrDefault("api-version")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "api-version", valid_568299
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568300 = header.getOrDefault("client-request-id")
  valid_568300 = validateParameter(valid_568300, JString, required = false,
                                 default = nil)
  if valid_568300 != nil:
    section.add "client-request-id", valid_568300
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568301: Call_IndexersGet_568295; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an indexer definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer
  let valid = call_568301.validator(path, query, header, formData, body)
  let scheme = call_568301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568301.url(scheme.get, call_568301.host, call_568301.base,
                         call_568301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568301, url, valid)

proc call*(call_568302: Call_IndexersGet_568295; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersGet
  ## Retrieves an indexer definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to retrieve.
  var path_568303 = newJObject()
  var query_568304 = newJObject()
  add(query_568304, "api-version", newJString(apiVersion))
  add(path_568303, "indexerName", newJString(indexerName))
  result = call_568302.call(path_568303, query_568304, nil, nil, nil)

var indexersGet* = Call_IndexersGet_568295(name: "indexersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local",
                                        route: "/indexers(\'{indexerName}\')",
                                        validator: validate_IndexersGet_568296,
                                        base: "", url: url_IndexersGet_568297,
                                        schemes: {Scheme.Https})
type
  Call_IndexersDelete_568320 = ref object of OpenApiRestCall_567667
proc url_IndexersDelete_568322(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "indexerName" in path, "`indexerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/indexers(\'"),
               (kind: VariableSegment, value: "indexerName"),
               (kind: ConstantSegment, value: "\')")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IndexersDelete_568321(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes an Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Indexer
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexerName: JString (required)
  ##              : The name of the indexer to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `indexerName` field"
  var valid_568323 = path.getOrDefault("indexerName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "indexerName", valid_568323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568324 = query.getOrDefault("api-version")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "api-version", valid_568324
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  section = newJObject()
  var valid_568325 = header.getOrDefault("If-Match")
  valid_568325 = validateParameter(valid_568325, JString, required = false,
                                 default = nil)
  if valid_568325 != nil:
    section.add "If-Match", valid_568325
  var valid_568326 = header.getOrDefault("client-request-id")
  valid_568326 = validateParameter(valid_568326, JString, required = false,
                                 default = nil)
  if valid_568326 != nil:
    section.add "client-request-id", valid_568326
  var valid_568327 = header.getOrDefault("If-None-Match")
  valid_568327 = validateParameter(valid_568327, JString, required = false,
                                 default = nil)
  if valid_568327 != nil:
    section.add "If-None-Match", valid_568327
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568328: Call_IndexersDelete_568320; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Indexer
  let valid = call_568328.validator(path, query, header, formData, body)
  let scheme = call_568328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568328.url(scheme.get, call_568328.host, call_568328.base,
                         call_568328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568328, url, valid)

proc call*(call_568329: Call_IndexersDelete_568320; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersDelete
  ## Deletes an Azure Search indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to delete.
  var path_568330 = newJObject()
  var query_568331 = newJObject()
  add(query_568331, "api-version", newJString(apiVersion))
  add(path_568330, "indexerName", newJString(indexerName))
  result = call_568329.call(path_568330, query_568331, nil, nil, nil)

var indexersDelete* = Call_IndexersDelete_568320(name: "indexersDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/indexers(\'{indexerName}\')", validator: validate_IndexersDelete_568321,
    base: "", url: url_IndexersDelete_568322, schemes: {Scheme.Https})
type
  Call_IndexersReset_568332 = ref object of OpenApiRestCall_567667
proc url_IndexersReset_568334(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "indexerName" in path, "`indexerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/indexers(\'"),
               (kind: VariableSegment, value: "indexerName"),
               (kind: ConstantSegment, value: "\')/search.reset")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IndexersReset_568333(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets the change tracking state associated with an Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Reset-Indexer
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexerName: JString (required)
  ##              : The name of the indexer to reset.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `indexerName` field"
  var valid_568335 = path.getOrDefault("indexerName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "indexerName", valid_568335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568336 = query.getOrDefault("api-version")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "api-version", valid_568336
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568337 = header.getOrDefault("client-request-id")
  valid_568337 = validateParameter(valid_568337, JString, required = false,
                                 default = nil)
  if valid_568337 != nil:
    section.add "client-request-id", valid_568337
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568338: Call_IndexersReset_568332; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the change tracking state associated with an Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Reset-Indexer
  let valid = call_568338.validator(path, query, header, formData, body)
  let scheme = call_568338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568338.url(scheme.get, call_568338.host, call_568338.base,
                         call_568338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568338, url, valid)

proc call*(call_568339: Call_IndexersReset_568332; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersReset
  ## Resets the change tracking state associated with an Azure Search indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Reset-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to reset.
  var path_568340 = newJObject()
  var query_568341 = newJObject()
  add(query_568341, "api-version", newJString(apiVersion))
  add(path_568340, "indexerName", newJString(indexerName))
  result = call_568339.call(path_568340, query_568341, nil, nil, nil)

var indexersReset* = Call_IndexersReset_568332(name: "indexersReset",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/indexers(\'{indexerName}\')/search.reset",
    validator: validate_IndexersReset_568333, base: "", url: url_IndexersReset_568334,
    schemes: {Scheme.Https})
type
  Call_IndexersRun_568342 = ref object of OpenApiRestCall_567667
proc url_IndexersRun_568344(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "indexerName" in path, "`indexerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/indexers(\'"),
               (kind: VariableSegment, value: "indexerName"),
               (kind: ConstantSegment, value: "\')/search.run")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IndexersRun_568343(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Runs an Azure Search indexer on-demand.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Run-Indexer
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexerName: JString (required)
  ##              : The name of the indexer to run.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `indexerName` field"
  var valid_568345 = path.getOrDefault("indexerName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "indexerName", valid_568345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568346 = query.getOrDefault("api-version")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "api-version", valid_568346
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568347 = header.getOrDefault("client-request-id")
  valid_568347 = validateParameter(valid_568347, JString, required = false,
                                 default = nil)
  if valid_568347 != nil:
    section.add "client-request-id", valid_568347
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568348: Call_IndexersRun_568342; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs an Azure Search indexer on-demand.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Run-Indexer
  let valid = call_568348.validator(path, query, header, formData, body)
  let scheme = call_568348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568348.url(scheme.get, call_568348.host, call_568348.base,
                         call_568348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568348, url, valid)

proc call*(call_568349: Call_IndexersRun_568342; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersRun
  ## Runs an Azure Search indexer on-demand.
  ## https://docs.microsoft.com/rest/api/searchservice/Run-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to run.
  var path_568350 = newJObject()
  var query_568351 = newJObject()
  add(query_568351, "api-version", newJString(apiVersion))
  add(path_568350, "indexerName", newJString(indexerName))
  result = call_568349.call(path_568350, query_568351, nil, nil, nil)

var indexersRun* = Call_IndexersRun_568342(name: "indexersRun",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local", route: "/indexers(\'{indexerName}\')/search.run",
                                        validator: validate_IndexersRun_568343,
                                        base: "", url: url_IndexersRun_568344,
                                        schemes: {Scheme.Https})
type
  Call_IndexersGetStatus_568352 = ref object of OpenApiRestCall_567667
proc url_IndexersGetStatus_568354(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "indexerName" in path, "`indexerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/indexers(\'"),
               (kind: VariableSegment, value: "indexerName"),
               (kind: ConstantSegment, value: "\')/search.status")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IndexersGetStatus_568353(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns the current status and execution history of an indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer-Status
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexerName: JString (required)
  ##              : The name of the indexer for which to retrieve status.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `indexerName` field"
  var valid_568355 = path.getOrDefault("indexerName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "indexerName", valid_568355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568356 = query.getOrDefault("api-version")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "api-version", valid_568356
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568357 = header.getOrDefault("client-request-id")
  valid_568357 = validateParameter(valid_568357, JString, required = false,
                                 default = nil)
  if valid_568357 != nil:
    section.add "client-request-id", valid_568357
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568358: Call_IndexersGetStatus_568352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the current status and execution history of an indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer-Status
  let valid = call_568358.validator(path, query, header, formData, body)
  let scheme = call_568358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568358.url(scheme.get, call_568358.host, call_568358.base,
                         call_568358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568358, url, valid)

proc call*(call_568359: Call_IndexersGetStatus_568352; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersGetStatus
  ## Returns the current status and execution history of an indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer-Status
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer for which to retrieve status.
  var path_568360 = newJObject()
  var query_568361 = newJObject()
  add(query_568361, "api-version", newJString(apiVersion))
  add(path_568360, "indexerName", newJString(indexerName))
  result = call_568359.call(path_568360, query_568361, nil, nil, nil)

var indexersGetStatus* = Call_IndexersGetStatus_568352(name: "indexersGetStatus",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/indexers(\'{indexerName}\')/search.status",
    validator: validate_IndexersGetStatus_568353, base: "",
    url: url_IndexersGetStatus_568354, schemes: {Scheme.Https})
type
  Call_IndexesCreate_568372 = ref object of OpenApiRestCall_567667
proc url_IndexesCreate_568374(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexesCreate_568373(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Index
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568375 = query.getOrDefault("api-version")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "api-version", valid_568375
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568376 = header.getOrDefault("client-request-id")
  valid_568376 = validateParameter(valid_568376, JString, required = false,
                                 default = nil)
  if valid_568376 != nil:
    section.add "client-request-id", valid_568376
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   index: JObject (required)
  ##        : The definition of the index to create.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568378: Call_IndexesCreate_568372; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Index
  let valid = call_568378.validator(path, query, header, formData, body)
  let scheme = call_568378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568378.url(scheme.get, call_568378.host, call_568378.base,
                         call_568378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568378, url, valid)

proc call*(call_568379: Call_IndexesCreate_568372; apiVersion: string;
          index: JsonNode): Recallable =
  ## indexesCreate
  ## Creates a new Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Index
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   index: JObject (required)
  ##        : The definition of the index to create.
  var query_568380 = newJObject()
  var body_568381 = newJObject()
  add(query_568380, "api-version", newJString(apiVersion))
  if index != nil:
    body_568381 = index
  result = call_568379.call(nil, query_568380, nil, nil, body_568381)

var indexesCreate* = Call_IndexesCreate_568372(name: "indexesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/indexes",
    validator: validate_IndexesCreate_568373, base: "", url: url_IndexesCreate_568374,
    schemes: {Scheme.Https})
type
  Call_IndexesList_568362 = ref object of OpenApiRestCall_567667
proc url_IndexesList_568364(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexesList_568363(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all indexes available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexes
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : Selects which properties of the index definitions to retrieve. Specified as a comma-separated list of JSON property names, or '*' for all properties. The default is all properties.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568366 = query.getOrDefault("api-version")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "api-version", valid_568366
  var valid_568367 = query.getOrDefault("$select")
  valid_568367 = validateParameter(valid_568367, JString, required = false,
                                 default = nil)
  if valid_568367 != nil:
    section.add "$select", valid_568367
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568368 = header.getOrDefault("client-request-id")
  valid_568368 = validateParameter(valid_568368, JString, required = false,
                                 default = nil)
  if valid_568368 != nil:
    section.add "client-request-id", valid_568368
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568369: Call_IndexesList_568362; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all indexes available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexes
  let valid = call_568369.validator(path, query, header, formData, body)
  let scheme = call_568369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568369.url(scheme.get, call_568369.host, call_568369.base,
                         call_568369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568369, url, valid)

proc call*(call_568370: Call_IndexesList_568362; apiVersion: string;
          Select: string = ""): Recallable =
  ## indexesList
  ## Lists all indexes available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexes
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : Selects which properties of the index definitions to retrieve. Specified as a comma-separated list of JSON property names, or '*' for all properties. The default is all properties.
  var query_568371 = newJObject()
  add(query_568371, "api-version", newJString(apiVersion))
  add(query_568371, "$select", newJString(Select))
  result = call_568370.call(nil, query_568371, nil, nil, nil)

var indexesList* = Call_IndexesList_568362(name: "indexesList",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/indexes",
                                        validator: validate_IndexesList_568363,
                                        base: "", url: url_IndexesList_568364,
                                        schemes: {Scheme.Https})
type
  Call_IndexesCreateOrUpdate_568392 = ref object of OpenApiRestCall_567667
proc url_IndexesCreateOrUpdate_568394(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "indexName" in path, "`indexName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/indexes(\'"),
               (kind: VariableSegment, value: "indexName"),
               (kind: ConstantSegment, value: "\')")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IndexesCreateOrUpdate_568393(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Azure Search index or updates an index if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Index
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexName: JString (required)
  ##            : The definition of the index to create or update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `indexName` field"
  var valid_568395 = path.getOrDefault("indexName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "indexName", valid_568395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   allowIndexDowntime: JBool
  ##                     : Allows new analyzers, tokenizers, token filters, or char filters to be added to an index by taking the index offline for at least a few seconds. This temporarily causes indexing and query requests to fail. Performance and write availability of the index can be impaired for several minutes after the index is updated, or longer for very large indexes.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568396 = query.getOrDefault("api-version")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "api-version", valid_568396
  var valid_568397 = query.getOrDefault("allowIndexDowntime")
  valid_568397 = validateParameter(valid_568397, JBool, required = false, default = nil)
  if valid_568397 != nil:
    section.add "allowIndexDowntime", valid_568397
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  ##   Prefer: JString (required)
  ##         : For HTTP PUT requests, instructs the service to return the created/updated resource on success.
  section = newJObject()
  var valid_568398 = header.getOrDefault("If-Match")
  valid_568398 = validateParameter(valid_568398, JString, required = false,
                                 default = nil)
  if valid_568398 != nil:
    section.add "If-Match", valid_568398
  var valid_568399 = header.getOrDefault("client-request-id")
  valid_568399 = validateParameter(valid_568399, JString, required = false,
                                 default = nil)
  if valid_568399 != nil:
    section.add "client-request-id", valid_568399
  var valid_568400 = header.getOrDefault("If-None-Match")
  valid_568400 = validateParameter(valid_568400, JString, required = false,
                                 default = nil)
  if valid_568400 != nil:
    section.add "If-None-Match", valid_568400
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_568401 = header.getOrDefault("Prefer")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_568401 != nil:
    section.add "Prefer", valid_568401
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   index: JObject (required)
  ##        : The definition of the index to create or update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568403: Call_IndexesCreateOrUpdate_568392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search index or updates an index if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Index
  let valid = call_568403.validator(path, query, header, formData, body)
  let scheme = call_568403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568403.url(scheme.get, call_568403.host, call_568403.base,
                         call_568403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568403, url, valid)

proc call*(call_568404: Call_IndexesCreateOrUpdate_568392; indexName: string;
          apiVersion: string; index: JsonNode; allowIndexDowntime: bool = false): Recallable =
  ## indexesCreateOrUpdate
  ## Creates a new Azure Search index or updates an index if it already exists.
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Index
  ##   indexName: string (required)
  ##            : The definition of the index to create or update.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   index: JObject (required)
  ##        : The definition of the index to create or update.
  ##   allowIndexDowntime: bool
  ##                     : Allows new analyzers, tokenizers, token filters, or char filters to be added to an index by taking the index offline for at least a few seconds. This temporarily causes indexing and query requests to fail. Performance and write availability of the index can be impaired for several minutes after the index is updated, or longer for very large indexes.
  var path_568405 = newJObject()
  var query_568406 = newJObject()
  var body_568407 = newJObject()
  add(path_568405, "indexName", newJString(indexName))
  add(query_568406, "api-version", newJString(apiVersion))
  if index != nil:
    body_568407 = index
  add(query_568406, "allowIndexDowntime", newJBool(allowIndexDowntime))
  result = call_568404.call(path_568405, query_568406, nil, nil, body_568407)

var indexesCreateOrUpdate* = Call_IndexesCreateOrUpdate_568392(
    name: "indexesCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/indexes(\'{indexName}\')", validator: validate_IndexesCreateOrUpdate_568393,
    base: "", url: url_IndexesCreateOrUpdate_568394, schemes: {Scheme.Https})
type
  Call_IndexesGet_568382 = ref object of OpenApiRestCall_567667
proc url_IndexesGet_568384(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "indexName" in path, "`indexName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/indexes(\'"),
               (kind: VariableSegment, value: "indexName"),
               (kind: ConstantSegment, value: "\')")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IndexesGet_568383(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves an index definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexName: JString (required)
  ##            : The name of the index to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `indexName` field"
  var valid_568385 = path.getOrDefault("indexName")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "indexName", valid_568385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568386 = query.getOrDefault("api-version")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "api-version", valid_568386
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568387 = header.getOrDefault("client-request-id")
  valid_568387 = validateParameter(valid_568387, JString, required = false,
                                 default = nil)
  if valid_568387 != nil:
    section.add "client-request-id", valid_568387
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568388: Call_IndexesGet_568382; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an index definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index
  let valid = call_568388.validator(path, query, header, formData, body)
  let scheme = call_568388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568388.url(scheme.get, call_568388.host, call_568388.base,
                         call_568388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568388, url, valid)

proc call*(call_568389: Call_IndexesGet_568382; indexName: string; apiVersion: string): Recallable =
  ## indexesGet
  ## Retrieves an index definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index
  ##   indexName: string (required)
  ##            : The name of the index to retrieve.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_568390 = newJObject()
  var query_568391 = newJObject()
  add(path_568390, "indexName", newJString(indexName))
  add(query_568391, "api-version", newJString(apiVersion))
  result = call_568389.call(path_568390, query_568391, nil, nil, nil)

var indexesGet* = Call_IndexesGet_568382(name: "indexesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local",
                                      route: "/indexes(\'{indexName}\')",
                                      validator: validate_IndexesGet_568383,
                                      base: "", url: url_IndexesGet_568384,
                                      schemes: {Scheme.Https})
type
  Call_IndexesDelete_568408 = ref object of OpenApiRestCall_567667
proc url_IndexesDelete_568410(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "indexName" in path, "`indexName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/indexes(\'"),
               (kind: VariableSegment, value: "indexName"),
               (kind: ConstantSegment, value: "\')")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IndexesDelete_568409(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an Azure Search index and all the documents it contains.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Index
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexName: JString (required)
  ##            : The name of the index to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `indexName` field"
  var valid_568411 = path.getOrDefault("indexName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "indexName", valid_568411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568412 = query.getOrDefault("api-version")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "api-version", valid_568412
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  section = newJObject()
  var valid_568413 = header.getOrDefault("If-Match")
  valid_568413 = validateParameter(valid_568413, JString, required = false,
                                 default = nil)
  if valid_568413 != nil:
    section.add "If-Match", valid_568413
  var valid_568414 = header.getOrDefault("client-request-id")
  valid_568414 = validateParameter(valid_568414, JString, required = false,
                                 default = nil)
  if valid_568414 != nil:
    section.add "client-request-id", valid_568414
  var valid_568415 = header.getOrDefault("If-None-Match")
  valid_568415 = validateParameter(valid_568415, JString, required = false,
                                 default = nil)
  if valid_568415 != nil:
    section.add "If-None-Match", valid_568415
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568416: Call_IndexesDelete_568408; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search index and all the documents it contains.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Index
  let valid = call_568416.validator(path, query, header, formData, body)
  let scheme = call_568416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568416.url(scheme.get, call_568416.host, call_568416.base,
                         call_568416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568416, url, valid)

proc call*(call_568417: Call_IndexesDelete_568408; indexName: string;
          apiVersion: string): Recallable =
  ## indexesDelete
  ## Deletes an Azure Search index and all the documents it contains.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Index
  ##   indexName: string (required)
  ##            : The name of the index to delete.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_568418 = newJObject()
  var query_568419 = newJObject()
  add(path_568418, "indexName", newJString(indexName))
  add(query_568419, "api-version", newJString(apiVersion))
  result = call_568417.call(path_568418, query_568419, nil, nil, nil)

var indexesDelete* = Call_IndexesDelete_568408(name: "indexesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/indexes(\'{indexName}\')", validator: validate_IndexesDelete_568409,
    base: "", url: url_IndexesDelete_568410, schemes: {Scheme.Https})
type
  Call_IndexesAnalyze_568420 = ref object of OpenApiRestCall_567667
proc url_IndexesAnalyze_568422(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "indexName" in path, "`indexName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/indexes(\'"),
               (kind: VariableSegment, value: "indexName"),
               (kind: ConstantSegment, value: "\')/search.analyze")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IndexesAnalyze_568421(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Shows how an analyzer breaks text into tokens.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/test-analyzer
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexName: JString (required)
  ##            : The name of the index for which to test an analyzer.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `indexName` field"
  var valid_568423 = path.getOrDefault("indexName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "indexName", valid_568423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568424 = query.getOrDefault("api-version")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "api-version", valid_568424
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568425 = header.getOrDefault("client-request-id")
  valid_568425 = validateParameter(valid_568425, JString, required = false,
                                 default = nil)
  if valid_568425 != nil:
    section.add "client-request-id", valid_568425
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : The text and analyzer or analysis components to test.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568427: Call_IndexesAnalyze_568420; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shows how an analyzer breaks text into tokens.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/test-analyzer
  let valid = call_568427.validator(path, query, header, formData, body)
  let scheme = call_568427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568427.url(scheme.get, call_568427.host, call_568427.base,
                         call_568427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568427, url, valid)

proc call*(call_568428: Call_IndexesAnalyze_568420; indexName: string;
          apiVersion: string; request: JsonNode): Recallable =
  ## indexesAnalyze
  ## Shows how an analyzer breaks text into tokens.
  ## https://docs.microsoft.com/rest/api/searchservice/test-analyzer
  ##   indexName: string (required)
  ##            : The name of the index for which to test an analyzer.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   request: JObject (required)
  ##          : The text and analyzer or analysis components to test.
  var path_568429 = newJObject()
  var query_568430 = newJObject()
  var body_568431 = newJObject()
  add(path_568429, "indexName", newJString(indexName))
  add(query_568430, "api-version", newJString(apiVersion))
  if request != nil:
    body_568431 = request
  result = call_568428.call(path_568429, query_568430, nil, nil, body_568431)

var indexesAnalyze* = Call_IndexesAnalyze_568420(name: "indexesAnalyze",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/indexes(\'{indexName}\')/search.analyze",
    validator: validate_IndexesAnalyze_568421, base: "", url: url_IndexesAnalyze_568422,
    schemes: {Scheme.Https})
type
  Call_IndexesGetStatistics_568432 = ref object of OpenApiRestCall_567667
proc url_IndexesGetStatistics_568434(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "indexName" in path, "`indexName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/indexes(\'"),
               (kind: VariableSegment, value: "indexName"),
               (kind: ConstantSegment, value: "\')/search.stats")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IndexesGetStatistics_568433(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns statistics for the given index, including a document count and storage usage.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index-Statistics
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexName: JString (required)
  ##            : The name of the index for which to retrieve statistics.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `indexName` field"
  var valid_568435 = path.getOrDefault("indexName")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "indexName", valid_568435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568436 = query.getOrDefault("api-version")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "api-version", valid_568436
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568437 = header.getOrDefault("client-request-id")
  valid_568437 = validateParameter(valid_568437, JString, required = false,
                                 default = nil)
  if valid_568437 != nil:
    section.add "client-request-id", valid_568437
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568438: Call_IndexesGetStatistics_568432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns statistics for the given index, including a document count and storage usage.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index-Statistics
  let valid = call_568438.validator(path, query, header, formData, body)
  let scheme = call_568438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568438.url(scheme.get, call_568438.host, call_568438.base,
                         call_568438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568438, url, valid)

proc call*(call_568439: Call_IndexesGetStatistics_568432; indexName: string;
          apiVersion: string): Recallable =
  ## indexesGetStatistics
  ## Returns statistics for the given index, including a document count and storage usage.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index-Statistics
  ##   indexName: string (required)
  ##            : The name of the index for which to retrieve statistics.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_568440 = newJObject()
  var query_568441 = newJObject()
  add(path_568440, "indexName", newJString(indexName))
  add(query_568441, "api-version", newJString(apiVersion))
  result = call_568439.call(path_568440, query_568441, nil, nil, nil)

var indexesGetStatistics* = Call_IndexesGetStatistics_568432(
    name: "indexesGetStatistics", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/indexes(\'{indexName}\')/search.stats",
    validator: validate_IndexesGetStatistics_568433, base: "",
    url: url_IndexesGetStatistics_568434, schemes: {Scheme.Https})
type
  Call_GetServiceStatistics_568442 = ref object of OpenApiRestCall_567667
proc url_GetServiceStatistics_568444(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetServiceStatistics_568443(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets service level statistics for an Azure Search service.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568445 = query.getOrDefault("api-version")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "api-version", valid_568445
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568446 = header.getOrDefault("client-request-id")
  valid_568446 = validateParameter(valid_568446, JString, required = false,
                                 default = nil)
  if valid_568446 != nil:
    section.add "client-request-id", valid_568446
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568447: Call_GetServiceStatistics_568442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets service level statistics for an Azure Search service.
  ## 
  let valid = call_568447.validator(path, query, header, formData, body)
  let scheme = call_568447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568447.url(scheme.get, call_568447.host, call_568447.base,
                         call_568447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568447, url, valid)

proc call*(call_568448: Call_GetServiceStatistics_568442; apiVersion: string): Recallable =
  ## getServiceStatistics
  ## Gets service level statistics for an Azure Search service.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568449 = newJObject()
  add(query_568449, "api-version", newJString(apiVersion))
  result = call_568448.call(nil, query_568449, nil, nil, nil)

var getServiceStatistics* = Call_GetServiceStatistics_568442(
    name: "getServiceStatistics", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/servicestats", validator: validate_GetServiceStatistics_568443,
    base: "", url: url_GetServiceStatistics_568444, schemes: {Scheme.Https})
type
  Call_SynonymMapsCreate_568458 = ref object of OpenApiRestCall_567667
proc url_SynonymMapsCreate_568460(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SynonymMapsCreate_568459(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a new Azure Search synonym map.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Synonym-Map
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568461 = query.getOrDefault("api-version")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "api-version", valid_568461
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568462 = header.getOrDefault("client-request-id")
  valid_568462 = validateParameter(valid_568462, JString, required = false,
                                 default = nil)
  if valid_568462 != nil:
    section.add "client-request-id", valid_568462
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   synonymMap: JObject (required)
  ##             : The definition of the synonym map to create.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568464: Call_SynonymMapsCreate_568458; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search synonym map.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Synonym-Map
  let valid = call_568464.validator(path, query, header, formData, body)
  let scheme = call_568464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568464.url(scheme.get, call_568464.host, call_568464.base,
                         call_568464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568464, url, valid)

proc call*(call_568465: Call_SynonymMapsCreate_568458; apiVersion: string;
          synonymMap: JsonNode): Recallable =
  ## synonymMapsCreate
  ## Creates a new Azure Search synonym map.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Synonym-Map
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   synonymMap: JObject (required)
  ##             : The definition of the synonym map to create.
  var query_568466 = newJObject()
  var body_568467 = newJObject()
  add(query_568466, "api-version", newJString(apiVersion))
  if synonymMap != nil:
    body_568467 = synonymMap
  result = call_568465.call(nil, query_568466, nil, nil, body_568467)

var synonymMapsCreate* = Call_SynonymMapsCreate_568458(name: "synonymMapsCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/synonymmaps",
    validator: validate_SynonymMapsCreate_568459, base: "",
    url: url_SynonymMapsCreate_568460, schemes: {Scheme.Https})
type
  Call_SynonymMapsList_568450 = ref object of OpenApiRestCall_567667
proc url_SynonymMapsList_568452(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SynonymMapsList_568451(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists all synonym maps available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Synonym-Maps
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568453 = query.getOrDefault("api-version")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "api-version", valid_568453
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568454 = header.getOrDefault("client-request-id")
  valid_568454 = validateParameter(valid_568454, JString, required = false,
                                 default = nil)
  if valid_568454 != nil:
    section.add "client-request-id", valid_568454
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568455: Call_SynonymMapsList_568450; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all synonym maps available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Synonym-Maps
  let valid = call_568455.validator(path, query, header, formData, body)
  let scheme = call_568455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568455.url(scheme.get, call_568455.host, call_568455.base,
                         call_568455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568455, url, valid)

proc call*(call_568456: Call_SynonymMapsList_568450; apiVersion: string): Recallable =
  ## synonymMapsList
  ## Lists all synonym maps available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Synonym-Maps
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568457 = newJObject()
  add(query_568457, "api-version", newJString(apiVersion))
  result = call_568456.call(nil, query_568457, nil, nil, nil)

var synonymMapsList* = Call_SynonymMapsList_568450(name: "synonymMapsList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/synonymmaps",
    validator: validate_SynonymMapsList_568451, base: "", url: url_SynonymMapsList_568452,
    schemes: {Scheme.Https})
type
  Call_SynonymMapsCreateOrUpdate_568478 = ref object of OpenApiRestCall_567667
proc url_SynonymMapsCreateOrUpdate_568480(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "synonymMapName" in path, "`synonymMapName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/synonymmaps(\'"),
               (kind: VariableSegment, value: "synonymMapName"),
               (kind: ConstantSegment, value: "\')")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SynonymMapsCreateOrUpdate_568479(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Azure Search synonym map or updates a synonym map if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Synonym-Map
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   synonymMapName: JString (required)
  ##                 : The name of the synonym map to create or update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `synonymMapName` field"
  var valid_568481 = path.getOrDefault("synonymMapName")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "synonymMapName", valid_568481
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568482 = query.getOrDefault("api-version")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "api-version", valid_568482
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  ##   Prefer: JString (required)
  ##         : For HTTP PUT requests, instructs the service to return the created/updated resource on success.
  section = newJObject()
  var valid_568483 = header.getOrDefault("If-Match")
  valid_568483 = validateParameter(valid_568483, JString, required = false,
                                 default = nil)
  if valid_568483 != nil:
    section.add "If-Match", valid_568483
  var valid_568484 = header.getOrDefault("client-request-id")
  valid_568484 = validateParameter(valid_568484, JString, required = false,
                                 default = nil)
  if valid_568484 != nil:
    section.add "client-request-id", valid_568484
  var valid_568485 = header.getOrDefault("If-None-Match")
  valid_568485 = validateParameter(valid_568485, JString, required = false,
                                 default = nil)
  if valid_568485 != nil:
    section.add "If-None-Match", valid_568485
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_568486 = header.getOrDefault("Prefer")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_568486 != nil:
    section.add "Prefer", valid_568486
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   synonymMap: JObject (required)
  ##             : The definition of the synonym map to create or update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568488: Call_SynonymMapsCreateOrUpdate_568478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search synonym map or updates a synonym map if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Synonym-Map
  let valid = call_568488.validator(path, query, header, formData, body)
  let scheme = call_568488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568488.url(scheme.get, call_568488.host, call_568488.base,
                         call_568488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568488, url, valid)

proc call*(call_568489: Call_SynonymMapsCreateOrUpdate_568478; apiVersion: string;
          synonymMap: JsonNode; synonymMapName: string): Recallable =
  ## synonymMapsCreateOrUpdate
  ## Creates a new Azure Search synonym map or updates a synonym map if it already exists.
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Synonym-Map
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   synonymMap: JObject (required)
  ##             : The definition of the synonym map to create or update.
  ##   synonymMapName: string (required)
  ##                 : The name of the synonym map to create or update.
  var path_568490 = newJObject()
  var query_568491 = newJObject()
  var body_568492 = newJObject()
  add(query_568491, "api-version", newJString(apiVersion))
  if synonymMap != nil:
    body_568492 = synonymMap
  add(path_568490, "synonymMapName", newJString(synonymMapName))
  result = call_568489.call(path_568490, query_568491, nil, nil, body_568492)

var synonymMapsCreateOrUpdate* = Call_SynonymMapsCreateOrUpdate_568478(
    name: "synonymMapsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/synonymmaps(\'{synonymMapName}\')",
    validator: validate_SynonymMapsCreateOrUpdate_568479, base: "",
    url: url_SynonymMapsCreateOrUpdate_568480, schemes: {Scheme.Https})
type
  Call_SynonymMapsGet_568468 = ref object of OpenApiRestCall_567667
proc url_SynonymMapsGet_568470(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "synonymMapName" in path, "`synonymMapName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/synonymmaps(\'"),
               (kind: VariableSegment, value: "synonymMapName"),
               (kind: ConstantSegment, value: "\')")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SynonymMapsGet_568469(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves a synonym map definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Synonym-Map
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   synonymMapName: JString (required)
  ##                 : The name of the synonym map to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `synonymMapName` field"
  var valid_568471 = path.getOrDefault("synonymMapName")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "synonymMapName", valid_568471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568472 = query.getOrDefault("api-version")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "api-version", valid_568472
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568473 = header.getOrDefault("client-request-id")
  valid_568473 = validateParameter(valid_568473, JString, required = false,
                                 default = nil)
  if valid_568473 != nil:
    section.add "client-request-id", valid_568473
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568474: Call_SynonymMapsGet_568468; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a synonym map definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Synonym-Map
  let valid = call_568474.validator(path, query, header, formData, body)
  let scheme = call_568474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568474.url(scheme.get, call_568474.host, call_568474.base,
                         call_568474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568474, url, valid)

proc call*(call_568475: Call_SynonymMapsGet_568468; apiVersion: string;
          synonymMapName: string): Recallable =
  ## synonymMapsGet
  ## Retrieves a synonym map definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Synonym-Map
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   synonymMapName: string (required)
  ##                 : The name of the synonym map to retrieve.
  var path_568476 = newJObject()
  var query_568477 = newJObject()
  add(query_568477, "api-version", newJString(apiVersion))
  add(path_568476, "synonymMapName", newJString(synonymMapName))
  result = call_568475.call(path_568476, query_568477, nil, nil, nil)

var synonymMapsGet* = Call_SynonymMapsGet_568468(name: "synonymMapsGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/synonymmaps(\'{synonymMapName}\')",
    validator: validate_SynonymMapsGet_568469, base: "", url: url_SynonymMapsGet_568470,
    schemes: {Scheme.Https})
type
  Call_SynonymMapsDelete_568493 = ref object of OpenApiRestCall_567667
proc url_SynonymMapsDelete_568495(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "synonymMapName" in path, "`synonymMapName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/synonymmaps(\'"),
               (kind: VariableSegment, value: "synonymMapName"),
               (kind: ConstantSegment, value: "\')")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SynonymMapsDelete_568494(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an Azure Search synonym map.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Synonym-Map
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   synonymMapName: JString (required)
  ##                 : The name of the synonym map to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `synonymMapName` field"
  var valid_568496 = path.getOrDefault("synonymMapName")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "synonymMapName", valid_568496
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568497 = query.getOrDefault("api-version")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "api-version", valid_568497
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  section = newJObject()
  var valid_568498 = header.getOrDefault("If-Match")
  valid_568498 = validateParameter(valid_568498, JString, required = false,
                                 default = nil)
  if valid_568498 != nil:
    section.add "If-Match", valid_568498
  var valid_568499 = header.getOrDefault("client-request-id")
  valid_568499 = validateParameter(valid_568499, JString, required = false,
                                 default = nil)
  if valid_568499 != nil:
    section.add "client-request-id", valid_568499
  var valid_568500 = header.getOrDefault("If-None-Match")
  valid_568500 = validateParameter(valid_568500, JString, required = false,
                                 default = nil)
  if valid_568500 != nil:
    section.add "If-None-Match", valid_568500
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568501: Call_SynonymMapsDelete_568493; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search synonym map.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Synonym-Map
  let valid = call_568501.validator(path, query, header, formData, body)
  let scheme = call_568501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568501.url(scheme.get, call_568501.host, call_568501.base,
                         call_568501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568501, url, valid)

proc call*(call_568502: Call_SynonymMapsDelete_568493; apiVersion: string;
          synonymMapName: string): Recallable =
  ## synonymMapsDelete
  ## Deletes an Azure Search synonym map.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Synonym-Map
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   synonymMapName: string (required)
  ##                 : The name of the synonym map to delete.
  var path_568503 = newJObject()
  var query_568504 = newJObject()
  add(query_568504, "api-version", newJString(apiVersion))
  add(path_568503, "synonymMapName", newJString(synonymMapName))
  result = call_568502.call(path_568503, query_568504, nil, nil, nil)

var synonymMapsDelete* = Call_SynonymMapsDelete_568493(name: "synonymMapsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/synonymmaps(\'{synonymMapName}\')",
    validator: validate_SynonymMapsDelete_568494, base: "",
    url: url_SynonymMapsDelete_568495, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
