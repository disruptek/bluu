
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SearchServiceClient
## version: 2016-09-01
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

  OpenApiRestCall_567666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567666): Option[Scheme] {.used.} =
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
  Call_DataSourcesCreate_568185 = ref object of OpenApiRestCall_567666
proc url_DataSourcesCreate_568187(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DataSourcesCreate_568186(path: JsonNode; query: JsonNode;
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
  var valid_568205 = query.getOrDefault("api-version")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "api-version", valid_568205
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568206 = header.getOrDefault("client-request-id")
  valid_568206 = validateParameter(valid_568206, JString, required = false,
                                 default = nil)
  if valid_568206 != nil:
    section.add "client-request-id", valid_568206
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

proc call*(call_568208: Call_DataSourcesCreate_568185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search datasource.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Data-Source
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_DataSourcesCreate_568185; apiVersion: string;
          dataSource: JsonNode): Recallable =
  ## dataSourcesCreate
  ## Creates a new Azure Search datasource.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Data-Source
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSource: JObject (required)
  ##             : The definition of the datasource to create.
  var query_568210 = newJObject()
  var body_568211 = newJObject()
  add(query_568210, "api-version", newJString(apiVersion))
  if dataSource != nil:
    body_568211 = dataSource
  result = call_568209.call(nil, query_568210, nil, nil, body_568211)

var dataSourcesCreate* = Call_DataSourcesCreate_568185(name: "dataSourcesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/datasources",
    validator: validate_DataSourcesCreate_568186, base: "",
    url: url_DataSourcesCreate_568187, schemes: {Scheme.Https})
type
  Call_DataSourcesList_567888 = ref object of OpenApiRestCall_567666
proc url_DataSourcesList_567890(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DataSourcesList_567889(path: JsonNode; query: JsonNode;
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
  var valid_568049 = query.getOrDefault("api-version")
  valid_568049 = validateParameter(valid_568049, JString, required = true,
                                 default = nil)
  if valid_568049 != nil:
    section.add "api-version", valid_568049
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568050 = header.getOrDefault("client-request-id")
  valid_568050 = validateParameter(valid_568050, JString, required = false,
                                 default = nil)
  if valid_568050 != nil:
    section.add "client-request-id", valid_568050
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568073: Call_DataSourcesList_567888; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all datasources available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Data-Sources
  let valid = call_568073.validator(path, query, header, formData, body)
  let scheme = call_568073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568073.url(scheme.get, call_568073.host, call_568073.base,
                         call_568073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568073, url, valid)

proc call*(call_568144: Call_DataSourcesList_567888; apiVersion: string): Recallable =
  ## dataSourcesList
  ## Lists all datasources available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Data-Sources
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568145 = newJObject()
  add(query_568145, "api-version", newJString(apiVersion))
  result = call_568144.call(nil, query_568145, nil, nil, nil)

var dataSourcesList* = Call_DataSourcesList_567888(name: "dataSourcesList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/datasources",
    validator: validate_DataSourcesList_567889, base: "", url: url_DataSourcesList_567890,
    schemes: {Scheme.Https})
type
  Call_DataSourcesCreateOrUpdate_568236 = ref object of OpenApiRestCall_567666
proc url_DataSourcesCreateOrUpdate_568238(protocol: Scheme; host: string;
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

proc validate_DataSourcesCreateOrUpdate_568237(path: JsonNode; query: JsonNode;
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
  var valid_568239 = path.getOrDefault("dataSourceName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "dataSourceName", valid_568239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568240 = query.getOrDefault("api-version")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "api-version", valid_568240
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  section = newJObject()
  var valid_568241 = header.getOrDefault("If-Match")
  valid_568241 = validateParameter(valid_568241, JString, required = false,
                                 default = nil)
  if valid_568241 != nil:
    section.add "If-Match", valid_568241
  var valid_568242 = header.getOrDefault("client-request-id")
  valid_568242 = validateParameter(valid_568242, JString, required = false,
                                 default = nil)
  if valid_568242 != nil:
    section.add "client-request-id", valid_568242
  var valid_568243 = header.getOrDefault("If-None-Match")
  valid_568243 = validateParameter(valid_568243, JString, required = false,
                                 default = nil)
  if valid_568243 != nil:
    section.add "If-None-Match", valid_568243
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

proc call*(call_568245: Call_DataSourcesCreateOrUpdate_568236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search datasource or updates a datasource if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Data-Source
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_DataSourcesCreateOrUpdate_568236; apiVersion: string;
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
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  var body_568249 = newJObject()
  add(query_568248, "api-version", newJString(apiVersion))
  add(path_568247, "dataSourceName", newJString(dataSourceName))
  if dataSource != nil:
    body_568249 = dataSource
  result = call_568246.call(path_568247, query_568248, nil, nil, body_568249)

var dataSourcesCreateOrUpdate* = Call_DataSourcesCreateOrUpdate_568236(
    name: "dataSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesCreateOrUpdate_568237, base: "",
    url: url_DataSourcesCreateOrUpdate_568238, schemes: {Scheme.Https})
type
  Call_DataSourcesGet_568212 = ref object of OpenApiRestCall_567666
proc url_DataSourcesGet_568214(protocol: Scheme; host: string; base: string;
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

proc validate_DataSourcesGet_568213(path: JsonNode; query: JsonNode;
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
  var valid_568229 = path.getOrDefault("dataSourceName")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "dataSourceName", valid_568229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568230 = query.getOrDefault("api-version")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "api-version", valid_568230
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568231 = header.getOrDefault("client-request-id")
  valid_568231 = validateParameter(valid_568231, JString, required = false,
                                 default = nil)
  if valid_568231 != nil:
    section.add "client-request-id", valid_568231
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568232: Call_DataSourcesGet_568212; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a datasource definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Data-Source
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_DataSourcesGet_568212; apiVersion: string;
          dataSourceName: string): Recallable =
  ## dataSourcesGet
  ## Retrieves a datasource definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Data-Source
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to retrieve.
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  add(query_568235, "api-version", newJString(apiVersion))
  add(path_568234, "dataSourceName", newJString(dataSourceName))
  result = call_568233.call(path_568234, query_568235, nil, nil, nil)

var dataSourcesGet* = Call_DataSourcesGet_568212(name: "dataSourcesGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesGet_568213, base: "", url: url_DataSourcesGet_568214,
    schemes: {Scheme.Https})
type
  Call_DataSourcesDelete_568250 = ref object of OpenApiRestCall_567666
proc url_DataSourcesDelete_568252(protocol: Scheme; host: string; base: string;
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

proc validate_DataSourcesDelete_568251(path: JsonNode; query: JsonNode;
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
  var valid_568253 = path.getOrDefault("dataSourceName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "dataSourceName", valid_568253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568254 = query.getOrDefault("api-version")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "api-version", valid_568254
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  section = newJObject()
  var valid_568255 = header.getOrDefault("If-Match")
  valid_568255 = validateParameter(valid_568255, JString, required = false,
                                 default = nil)
  if valid_568255 != nil:
    section.add "If-Match", valid_568255
  var valid_568256 = header.getOrDefault("client-request-id")
  valid_568256 = validateParameter(valid_568256, JString, required = false,
                                 default = nil)
  if valid_568256 != nil:
    section.add "client-request-id", valid_568256
  var valid_568257 = header.getOrDefault("If-None-Match")
  valid_568257 = validateParameter(valid_568257, JString, required = false,
                                 default = nil)
  if valid_568257 != nil:
    section.add "If-None-Match", valid_568257
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568258: Call_DataSourcesDelete_568250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search datasource.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Data-Source
  let valid = call_568258.validator(path, query, header, formData, body)
  let scheme = call_568258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568258.url(scheme.get, call_568258.host, call_568258.base,
                         call_568258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568258, url, valid)

proc call*(call_568259: Call_DataSourcesDelete_568250; apiVersion: string;
          dataSourceName: string): Recallable =
  ## dataSourcesDelete
  ## Deletes an Azure Search datasource.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Data-Source
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to delete.
  var path_568260 = newJObject()
  var query_568261 = newJObject()
  add(query_568261, "api-version", newJString(apiVersion))
  add(path_568260, "dataSourceName", newJString(dataSourceName))
  result = call_568259.call(path_568260, query_568261, nil, nil, nil)

var dataSourcesDelete* = Call_DataSourcesDelete_568250(name: "dataSourcesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesDelete_568251, base: "",
    url: url_DataSourcesDelete_568252, schemes: {Scheme.Https})
type
  Call_IndexersCreate_568270 = ref object of OpenApiRestCall_567666
proc url_IndexersCreate_568272(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexersCreate_568271(path: JsonNode; query: JsonNode;
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
  var valid_568273 = query.getOrDefault("api-version")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "api-version", valid_568273
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568274 = header.getOrDefault("client-request-id")
  valid_568274 = validateParameter(valid_568274, JString, required = false,
                                 default = nil)
  if valid_568274 != nil:
    section.add "client-request-id", valid_568274
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

proc call*(call_568276: Call_IndexersCreate_568270; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  let valid = call_568276.validator(path, query, header, formData, body)
  let scheme = call_568276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568276.url(scheme.get, call_568276.host, call_568276.base,
                         call_568276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568276, url, valid)

proc call*(call_568277: Call_IndexersCreate_568270; apiVersion: string;
          indexer: JsonNode): Recallable =
  ## indexersCreate
  ## Creates a new Azure Search indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexer: JObject (required)
  ##          : The definition of the indexer to create.
  var query_568278 = newJObject()
  var body_568279 = newJObject()
  add(query_568278, "api-version", newJString(apiVersion))
  if indexer != nil:
    body_568279 = indexer
  result = call_568277.call(nil, query_568278, nil, nil, body_568279)

var indexersCreate* = Call_IndexersCreate_568270(name: "indexersCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/indexers",
    validator: validate_IndexersCreate_568271, base: "", url: url_IndexersCreate_568272,
    schemes: {Scheme.Https})
type
  Call_IndexersList_568262 = ref object of OpenApiRestCall_567666
proc url_IndexersList_568264(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexersList_568263(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568265 = query.getOrDefault("api-version")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "api-version", valid_568265
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568266 = header.getOrDefault("client-request-id")
  valid_568266 = validateParameter(valid_568266, JString, required = false,
                                 default = nil)
  if valid_568266 != nil:
    section.add "client-request-id", valid_568266
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568267: Call_IndexersList_568262; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all indexers available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexers
  let valid = call_568267.validator(path, query, header, formData, body)
  let scheme = call_568267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568267.url(scheme.get, call_568267.host, call_568267.base,
                         call_568267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568267, url, valid)

proc call*(call_568268: Call_IndexersList_568262; apiVersion: string): Recallable =
  ## indexersList
  ## Lists all indexers available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexers
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568269 = newJObject()
  add(query_568269, "api-version", newJString(apiVersion))
  result = call_568268.call(nil, query_568269, nil, nil, nil)

var indexersList* = Call_IndexersList_568262(name: "indexersList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/indexers",
    validator: validate_IndexersList_568263, base: "", url: url_IndexersList_568264,
    schemes: {Scheme.Https})
type
  Call_IndexersCreateOrUpdate_568290 = ref object of OpenApiRestCall_567666
proc url_IndexersCreateOrUpdate_568292(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersCreateOrUpdate_568291(path: JsonNode; query: JsonNode;
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
  var valid_568293 = path.getOrDefault("indexerName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "indexerName", valid_568293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568294 = query.getOrDefault("api-version")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "api-version", valid_568294
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  section = newJObject()
  var valid_568295 = header.getOrDefault("If-Match")
  valid_568295 = validateParameter(valid_568295, JString, required = false,
                                 default = nil)
  if valid_568295 != nil:
    section.add "If-Match", valid_568295
  var valid_568296 = header.getOrDefault("client-request-id")
  valid_568296 = validateParameter(valid_568296, JString, required = false,
                                 default = nil)
  if valid_568296 != nil:
    section.add "client-request-id", valid_568296
  var valid_568297 = header.getOrDefault("If-None-Match")
  valid_568297 = validateParameter(valid_568297, JString, required = false,
                                 default = nil)
  if valid_568297 != nil:
    section.add "If-None-Match", valid_568297
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

proc call*(call_568299: Call_IndexersCreateOrUpdate_568290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search indexer or updates an indexer if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  let valid = call_568299.validator(path, query, header, formData, body)
  let scheme = call_568299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568299.url(scheme.get, call_568299.host, call_568299.base,
                         call_568299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568299, url, valid)

proc call*(call_568300: Call_IndexersCreateOrUpdate_568290; apiVersion: string;
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
  var path_568301 = newJObject()
  var query_568302 = newJObject()
  var body_568303 = newJObject()
  add(query_568302, "api-version", newJString(apiVersion))
  add(path_568301, "indexerName", newJString(indexerName))
  if indexer != nil:
    body_568303 = indexer
  result = call_568300.call(path_568301, query_568302, nil, nil, body_568303)

var indexersCreateOrUpdate* = Call_IndexersCreateOrUpdate_568290(
    name: "indexersCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/indexers(\'{indexerName}\')",
    validator: validate_IndexersCreateOrUpdate_568291, base: "",
    url: url_IndexersCreateOrUpdate_568292, schemes: {Scheme.Https})
type
  Call_IndexersGet_568280 = ref object of OpenApiRestCall_567666
proc url_IndexersGet_568282(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersGet_568281(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568283 = path.getOrDefault("indexerName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "indexerName", valid_568283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568284 = query.getOrDefault("api-version")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "api-version", valid_568284
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568285 = header.getOrDefault("client-request-id")
  valid_568285 = validateParameter(valid_568285, JString, required = false,
                                 default = nil)
  if valid_568285 != nil:
    section.add "client-request-id", valid_568285
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568286: Call_IndexersGet_568280; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an indexer definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer
  let valid = call_568286.validator(path, query, header, formData, body)
  let scheme = call_568286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568286.url(scheme.get, call_568286.host, call_568286.base,
                         call_568286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568286, url, valid)

proc call*(call_568287: Call_IndexersGet_568280; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersGet
  ## Retrieves an indexer definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to retrieve.
  var path_568288 = newJObject()
  var query_568289 = newJObject()
  add(query_568289, "api-version", newJString(apiVersion))
  add(path_568288, "indexerName", newJString(indexerName))
  result = call_568287.call(path_568288, query_568289, nil, nil, nil)

var indexersGet* = Call_IndexersGet_568280(name: "indexersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local",
                                        route: "/indexers(\'{indexerName}\')",
                                        validator: validate_IndexersGet_568281,
                                        base: "", url: url_IndexersGet_568282,
                                        schemes: {Scheme.Https})
type
  Call_IndexersDelete_568304 = ref object of OpenApiRestCall_567666
proc url_IndexersDelete_568306(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersDelete_568305(path: JsonNode; query: JsonNode;
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
  var valid_568307 = path.getOrDefault("indexerName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "indexerName", valid_568307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568308 = query.getOrDefault("api-version")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "api-version", valid_568308
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  section = newJObject()
  var valid_568309 = header.getOrDefault("If-Match")
  valid_568309 = validateParameter(valid_568309, JString, required = false,
                                 default = nil)
  if valid_568309 != nil:
    section.add "If-Match", valid_568309
  var valid_568310 = header.getOrDefault("client-request-id")
  valid_568310 = validateParameter(valid_568310, JString, required = false,
                                 default = nil)
  if valid_568310 != nil:
    section.add "client-request-id", valid_568310
  var valid_568311 = header.getOrDefault("If-None-Match")
  valid_568311 = validateParameter(valid_568311, JString, required = false,
                                 default = nil)
  if valid_568311 != nil:
    section.add "If-None-Match", valid_568311
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568312: Call_IndexersDelete_568304; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Indexer
  let valid = call_568312.validator(path, query, header, formData, body)
  let scheme = call_568312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568312.url(scheme.get, call_568312.host, call_568312.base,
                         call_568312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568312, url, valid)

proc call*(call_568313: Call_IndexersDelete_568304; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersDelete
  ## Deletes an Azure Search indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to delete.
  var path_568314 = newJObject()
  var query_568315 = newJObject()
  add(query_568315, "api-version", newJString(apiVersion))
  add(path_568314, "indexerName", newJString(indexerName))
  result = call_568313.call(path_568314, query_568315, nil, nil, nil)

var indexersDelete* = Call_IndexersDelete_568304(name: "indexersDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/indexers(\'{indexerName}\')", validator: validate_IndexersDelete_568305,
    base: "", url: url_IndexersDelete_568306, schemes: {Scheme.Https})
type
  Call_IndexersReset_568316 = ref object of OpenApiRestCall_567666
proc url_IndexersReset_568318(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersReset_568317(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568319 = path.getOrDefault("indexerName")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "indexerName", valid_568319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568320 = query.getOrDefault("api-version")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "api-version", valid_568320
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568321 = header.getOrDefault("client-request-id")
  valid_568321 = validateParameter(valid_568321, JString, required = false,
                                 default = nil)
  if valid_568321 != nil:
    section.add "client-request-id", valid_568321
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568322: Call_IndexersReset_568316; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the change tracking state associated with an Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Reset-Indexer
  let valid = call_568322.validator(path, query, header, formData, body)
  let scheme = call_568322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568322.url(scheme.get, call_568322.host, call_568322.base,
                         call_568322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568322, url, valid)

proc call*(call_568323: Call_IndexersReset_568316; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersReset
  ## Resets the change tracking state associated with an Azure Search indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Reset-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to reset.
  var path_568324 = newJObject()
  var query_568325 = newJObject()
  add(query_568325, "api-version", newJString(apiVersion))
  add(path_568324, "indexerName", newJString(indexerName))
  result = call_568323.call(path_568324, query_568325, nil, nil, nil)

var indexersReset* = Call_IndexersReset_568316(name: "indexersReset",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/indexers(\'{indexerName}\')/search.reset",
    validator: validate_IndexersReset_568317, base: "", url: url_IndexersReset_568318,
    schemes: {Scheme.Https})
type
  Call_IndexersRun_568326 = ref object of OpenApiRestCall_567666
proc url_IndexersRun_568328(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersRun_568327(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568329 = path.getOrDefault("indexerName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "indexerName", valid_568329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568330 = query.getOrDefault("api-version")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "api-version", valid_568330
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568331 = header.getOrDefault("client-request-id")
  valid_568331 = validateParameter(valid_568331, JString, required = false,
                                 default = nil)
  if valid_568331 != nil:
    section.add "client-request-id", valid_568331
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568332: Call_IndexersRun_568326; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs an Azure Search indexer on-demand.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Run-Indexer
  let valid = call_568332.validator(path, query, header, formData, body)
  let scheme = call_568332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568332.url(scheme.get, call_568332.host, call_568332.base,
                         call_568332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568332, url, valid)

proc call*(call_568333: Call_IndexersRun_568326; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersRun
  ## Runs an Azure Search indexer on-demand.
  ## https://docs.microsoft.com/rest/api/searchservice/Run-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to run.
  var path_568334 = newJObject()
  var query_568335 = newJObject()
  add(query_568335, "api-version", newJString(apiVersion))
  add(path_568334, "indexerName", newJString(indexerName))
  result = call_568333.call(path_568334, query_568335, nil, nil, nil)

var indexersRun* = Call_IndexersRun_568326(name: "indexersRun",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local", route: "/indexers(\'{indexerName}\')/search.run",
                                        validator: validate_IndexersRun_568327,
                                        base: "", url: url_IndexersRun_568328,
                                        schemes: {Scheme.Https})
type
  Call_IndexersGetStatus_568336 = ref object of OpenApiRestCall_567666
proc url_IndexersGetStatus_568338(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersGetStatus_568337(path: JsonNode; query: JsonNode;
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
  var valid_568339 = path.getOrDefault("indexerName")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "indexerName", valid_568339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568340 = query.getOrDefault("api-version")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "api-version", valid_568340
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568341 = header.getOrDefault("client-request-id")
  valid_568341 = validateParameter(valid_568341, JString, required = false,
                                 default = nil)
  if valid_568341 != nil:
    section.add "client-request-id", valid_568341
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568342: Call_IndexersGetStatus_568336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the current status and execution history of an indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer-Status
  let valid = call_568342.validator(path, query, header, formData, body)
  let scheme = call_568342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568342.url(scheme.get, call_568342.host, call_568342.base,
                         call_568342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568342, url, valid)

proc call*(call_568343: Call_IndexersGetStatus_568336; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersGetStatus
  ## Returns the current status and execution history of an indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer-Status
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer for which to retrieve status.
  var path_568344 = newJObject()
  var query_568345 = newJObject()
  add(query_568345, "api-version", newJString(apiVersion))
  add(path_568344, "indexerName", newJString(indexerName))
  result = call_568343.call(path_568344, query_568345, nil, nil, nil)

var indexersGetStatus* = Call_IndexersGetStatus_568336(name: "indexersGetStatus",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/indexers(\'{indexerName}\')/search.status",
    validator: validate_IndexersGetStatus_568337, base: "",
    url: url_IndexersGetStatus_568338, schemes: {Scheme.Https})
type
  Call_IndexesCreate_568356 = ref object of OpenApiRestCall_567666
proc url_IndexesCreate_568358(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexesCreate_568357(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568359 = query.getOrDefault("api-version")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "api-version", valid_568359
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568360 = header.getOrDefault("client-request-id")
  valid_568360 = validateParameter(valid_568360, JString, required = false,
                                 default = nil)
  if valid_568360 != nil:
    section.add "client-request-id", valid_568360
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

proc call*(call_568362: Call_IndexesCreate_568356; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Index
  let valid = call_568362.validator(path, query, header, formData, body)
  let scheme = call_568362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568362.url(scheme.get, call_568362.host, call_568362.base,
                         call_568362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568362, url, valid)

proc call*(call_568363: Call_IndexesCreate_568356; apiVersion: string;
          index: JsonNode): Recallable =
  ## indexesCreate
  ## Creates a new Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Index
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   index: JObject (required)
  ##        : The definition of the index to create.
  var query_568364 = newJObject()
  var body_568365 = newJObject()
  add(query_568364, "api-version", newJString(apiVersion))
  if index != nil:
    body_568365 = index
  result = call_568363.call(nil, query_568364, nil, nil, body_568365)

var indexesCreate* = Call_IndexesCreate_568356(name: "indexesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/indexes",
    validator: validate_IndexesCreate_568357, base: "", url: url_IndexesCreate_568358,
    schemes: {Scheme.Https})
type
  Call_IndexesList_568346 = ref object of OpenApiRestCall_567666
proc url_IndexesList_568348(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexesList_568347(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568350 = query.getOrDefault("api-version")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "api-version", valid_568350
  var valid_568351 = query.getOrDefault("$select")
  valid_568351 = validateParameter(valid_568351, JString, required = false,
                                 default = nil)
  if valid_568351 != nil:
    section.add "$select", valid_568351
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568352 = header.getOrDefault("client-request-id")
  valid_568352 = validateParameter(valid_568352, JString, required = false,
                                 default = nil)
  if valid_568352 != nil:
    section.add "client-request-id", valid_568352
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568353: Call_IndexesList_568346; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all indexes available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexes
  let valid = call_568353.validator(path, query, header, formData, body)
  let scheme = call_568353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568353.url(scheme.get, call_568353.host, call_568353.base,
                         call_568353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568353, url, valid)

proc call*(call_568354: Call_IndexesList_568346; apiVersion: string;
          Select: string = ""): Recallable =
  ## indexesList
  ## Lists all indexes available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexes
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : Selects which properties of the index definitions to retrieve. Specified as a comma-separated list of JSON property names, or '*' for all properties. The default is all properties.
  var query_568355 = newJObject()
  add(query_568355, "api-version", newJString(apiVersion))
  add(query_568355, "$select", newJString(Select))
  result = call_568354.call(nil, query_568355, nil, nil, nil)

var indexesList* = Call_IndexesList_568346(name: "indexesList",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/indexes",
                                        validator: validate_IndexesList_568347,
                                        base: "", url: url_IndexesList_568348,
                                        schemes: {Scheme.Https})
type
  Call_IndexesCreateOrUpdate_568376 = ref object of OpenApiRestCall_567666
proc url_IndexesCreateOrUpdate_568378(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesCreateOrUpdate_568377(path: JsonNode; query: JsonNode;
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
  var valid_568379 = path.getOrDefault("indexName")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "indexName", valid_568379
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   allowIndexDowntime: JBool
  ##                     : Allows new analyzers, tokenizers, token filters, or char filters to be added to an index by taking the index offline for at least a few seconds. This temporarily causes indexing and query requests to fail. Performance and write availability of the index can be impaired for several minutes after the index is updated, or longer for very large indexes.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568380 = query.getOrDefault("api-version")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "api-version", valid_568380
  var valid_568381 = query.getOrDefault("allowIndexDowntime")
  valid_568381 = validateParameter(valid_568381, JBool, required = false, default = nil)
  if valid_568381 != nil:
    section.add "allowIndexDowntime", valid_568381
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  section = newJObject()
  var valid_568382 = header.getOrDefault("If-Match")
  valid_568382 = validateParameter(valid_568382, JString, required = false,
                                 default = nil)
  if valid_568382 != nil:
    section.add "If-Match", valid_568382
  var valid_568383 = header.getOrDefault("client-request-id")
  valid_568383 = validateParameter(valid_568383, JString, required = false,
                                 default = nil)
  if valid_568383 != nil:
    section.add "client-request-id", valid_568383
  var valid_568384 = header.getOrDefault("If-None-Match")
  valid_568384 = validateParameter(valid_568384, JString, required = false,
                                 default = nil)
  if valid_568384 != nil:
    section.add "If-None-Match", valid_568384
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

proc call*(call_568386: Call_IndexesCreateOrUpdate_568376; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search index or updates an index if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Index
  let valid = call_568386.validator(path, query, header, formData, body)
  let scheme = call_568386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568386.url(scheme.get, call_568386.host, call_568386.base,
                         call_568386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568386, url, valid)

proc call*(call_568387: Call_IndexesCreateOrUpdate_568376; indexName: string;
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
  var path_568388 = newJObject()
  var query_568389 = newJObject()
  var body_568390 = newJObject()
  add(path_568388, "indexName", newJString(indexName))
  add(query_568389, "api-version", newJString(apiVersion))
  if index != nil:
    body_568390 = index
  add(query_568389, "allowIndexDowntime", newJBool(allowIndexDowntime))
  result = call_568387.call(path_568388, query_568389, nil, nil, body_568390)

var indexesCreateOrUpdate* = Call_IndexesCreateOrUpdate_568376(
    name: "indexesCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/indexes(\'{indexName}\')", validator: validate_IndexesCreateOrUpdate_568377,
    base: "", url: url_IndexesCreateOrUpdate_568378, schemes: {Scheme.Https})
type
  Call_IndexesGet_568366 = ref object of OpenApiRestCall_567666
proc url_IndexesGet_568368(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_IndexesGet_568367(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568369 = path.getOrDefault("indexName")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "indexName", valid_568369
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568370 = query.getOrDefault("api-version")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "api-version", valid_568370
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568371 = header.getOrDefault("client-request-id")
  valid_568371 = validateParameter(valid_568371, JString, required = false,
                                 default = nil)
  if valid_568371 != nil:
    section.add "client-request-id", valid_568371
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568372: Call_IndexesGet_568366; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an index definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index
  let valid = call_568372.validator(path, query, header, formData, body)
  let scheme = call_568372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568372.url(scheme.get, call_568372.host, call_568372.base,
                         call_568372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568372, url, valid)

proc call*(call_568373: Call_IndexesGet_568366; indexName: string; apiVersion: string): Recallable =
  ## indexesGet
  ## Retrieves an index definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index
  ##   indexName: string (required)
  ##            : The name of the index to retrieve.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_568374 = newJObject()
  var query_568375 = newJObject()
  add(path_568374, "indexName", newJString(indexName))
  add(query_568375, "api-version", newJString(apiVersion))
  result = call_568373.call(path_568374, query_568375, nil, nil, nil)

var indexesGet* = Call_IndexesGet_568366(name: "indexesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local",
                                      route: "/indexes(\'{indexName}\')",
                                      validator: validate_IndexesGet_568367,
                                      base: "", url: url_IndexesGet_568368,
                                      schemes: {Scheme.Https})
type
  Call_IndexesDelete_568391 = ref object of OpenApiRestCall_567666
proc url_IndexesDelete_568393(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesDelete_568392(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568394 = path.getOrDefault("indexName")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "indexName", valid_568394
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568395 = query.getOrDefault("api-version")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "api-version", valid_568395
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  section = newJObject()
  var valid_568396 = header.getOrDefault("If-Match")
  valid_568396 = validateParameter(valid_568396, JString, required = false,
                                 default = nil)
  if valid_568396 != nil:
    section.add "If-Match", valid_568396
  var valid_568397 = header.getOrDefault("client-request-id")
  valid_568397 = validateParameter(valid_568397, JString, required = false,
                                 default = nil)
  if valid_568397 != nil:
    section.add "client-request-id", valid_568397
  var valid_568398 = header.getOrDefault("If-None-Match")
  valid_568398 = validateParameter(valid_568398, JString, required = false,
                                 default = nil)
  if valid_568398 != nil:
    section.add "If-None-Match", valid_568398
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568399: Call_IndexesDelete_568391; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search index and all the documents it contains.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Index
  let valid = call_568399.validator(path, query, header, formData, body)
  let scheme = call_568399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568399.url(scheme.get, call_568399.host, call_568399.base,
                         call_568399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568399, url, valid)

proc call*(call_568400: Call_IndexesDelete_568391; indexName: string;
          apiVersion: string): Recallable =
  ## indexesDelete
  ## Deletes an Azure Search index and all the documents it contains.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Index
  ##   indexName: string (required)
  ##            : The name of the index to delete.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_568401 = newJObject()
  var query_568402 = newJObject()
  add(path_568401, "indexName", newJString(indexName))
  add(query_568402, "api-version", newJString(apiVersion))
  result = call_568400.call(path_568401, query_568402, nil, nil, nil)

var indexesDelete* = Call_IndexesDelete_568391(name: "indexesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/indexes(\'{indexName}\')", validator: validate_IndexesDelete_568392,
    base: "", url: url_IndexesDelete_568393, schemes: {Scheme.Https})
type
  Call_IndexesAnalyze_568403 = ref object of OpenApiRestCall_567666
proc url_IndexesAnalyze_568405(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesAnalyze_568404(path: JsonNode; query: JsonNode;
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
  var valid_568406 = path.getOrDefault("indexName")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "indexName", valid_568406
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568407 = query.getOrDefault("api-version")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "api-version", valid_568407
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568408 = header.getOrDefault("client-request-id")
  valid_568408 = validateParameter(valid_568408, JString, required = false,
                                 default = nil)
  if valid_568408 != nil:
    section.add "client-request-id", valid_568408
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

proc call*(call_568410: Call_IndexesAnalyze_568403; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shows how an analyzer breaks text into tokens.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/test-analyzer
  let valid = call_568410.validator(path, query, header, formData, body)
  let scheme = call_568410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568410.url(scheme.get, call_568410.host, call_568410.base,
                         call_568410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568410, url, valid)

proc call*(call_568411: Call_IndexesAnalyze_568403; indexName: string;
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
  var path_568412 = newJObject()
  var query_568413 = newJObject()
  var body_568414 = newJObject()
  add(path_568412, "indexName", newJString(indexName))
  add(query_568413, "api-version", newJString(apiVersion))
  if request != nil:
    body_568414 = request
  result = call_568411.call(path_568412, query_568413, nil, nil, body_568414)

var indexesAnalyze* = Call_IndexesAnalyze_568403(name: "indexesAnalyze",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/indexes(\'{indexName}\')/search.analyze",
    validator: validate_IndexesAnalyze_568404, base: "", url: url_IndexesAnalyze_568405,
    schemes: {Scheme.Https})
type
  Call_IndexesGetStatistics_568415 = ref object of OpenApiRestCall_567666
proc url_IndexesGetStatistics_568417(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesGetStatistics_568416(path: JsonNode; query: JsonNode;
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
  var valid_568418 = path.getOrDefault("indexName")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "indexName", valid_568418
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568419 = query.getOrDefault("api-version")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "api-version", valid_568419
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568420 = header.getOrDefault("client-request-id")
  valid_568420 = validateParameter(valid_568420, JString, required = false,
                                 default = nil)
  if valid_568420 != nil:
    section.add "client-request-id", valid_568420
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568421: Call_IndexesGetStatistics_568415; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns statistics for the given index, including a document count and storage usage.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index-Statistics
  let valid = call_568421.validator(path, query, header, formData, body)
  let scheme = call_568421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568421.url(scheme.get, call_568421.host, call_568421.base,
                         call_568421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568421, url, valid)

proc call*(call_568422: Call_IndexesGetStatistics_568415; indexName: string;
          apiVersion: string): Recallable =
  ## indexesGetStatistics
  ## Returns statistics for the given index, including a document count and storage usage.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index-Statistics
  ##   indexName: string (required)
  ##            : The name of the index for which to retrieve statistics.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_568423 = newJObject()
  var query_568424 = newJObject()
  add(path_568423, "indexName", newJString(indexName))
  add(query_568424, "api-version", newJString(apiVersion))
  result = call_568422.call(path_568423, query_568424, nil, nil, nil)

var indexesGetStatistics* = Call_IndexesGetStatistics_568415(
    name: "indexesGetStatistics", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/indexes(\'{indexName}\')/search.stats",
    validator: validate_IndexesGetStatistics_568416, base: "",
    url: url_IndexesGetStatistics_568417, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
