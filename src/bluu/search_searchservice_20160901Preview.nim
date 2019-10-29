
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SearchServiceClient
## version: 2016-09-01-Preview
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

  OpenApiRestCall_563565 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563565](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563565): Option[Scheme] {.used.} =
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
  macServiceName = "search-searchservice"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DataSourcesCreate_564086 = ref object of OpenApiRestCall_563565
proc url_DataSourcesCreate_564088(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DataSourcesCreate_564087(path: JsonNode; query: JsonNode;
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
  var valid_564106 = query.getOrDefault("api-version")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "api-version", valid_564106
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564107 = header.getOrDefault("client-request-id")
  valid_564107 = validateParameter(valid_564107, JString, required = false,
                                 default = nil)
  if valid_564107 != nil:
    section.add "client-request-id", valid_564107
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

proc call*(call_564109: Call_DataSourcesCreate_564086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search datasource.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Data-Source
  let valid = call_564109.validator(path, query, header, formData, body)
  let scheme = call_564109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564109.url(scheme.get, call_564109.host, call_564109.base,
                         call_564109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564109, url, valid)

proc call*(call_564110: Call_DataSourcesCreate_564086; dataSource: JsonNode;
          apiVersion: string): Recallable =
  ## dataSourcesCreate
  ## Creates a new Azure Search datasource.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Data-Source
  ##   dataSource: JObject (required)
  ##             : The definition of the datasource to create.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564111 = newJObject()
  var body_564112 = newJObject()
  if dataSource != nil:
    body_564112 = dataSource
  add(query_564111, "api-version", newJString(apiVersion))
  result = call_564110.call(nil, query_564111, nil, nil, body_564112)

var dataSourcesCreate* = Call_DataSourcesCreate_564086(name: "dataSourcesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/datasources",
    validator: validate_DataSourcesCreate_564087, base: "",
    url: url_DataSourcesCreate_564088, schemes: {Scheme.Https})
type
  Call_DataSourcesList_563787 = ref object of OpenApiRestCall_563565
proc url_DataSourcesList_563789(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DataSourcesList_563788(path: JsonNode; query: JsonNode;
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
  var valid_563950 = query.getOrDefault("api-version")
  valid_563950 = validateParameter(valid_563950, JString, required = true,
                                 default = nil)
  if valid_563950 != nil:
    section.add "api-version", valid_563950
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_563951 = header.getOrDefault("client-request-id")
  valid_563951 = validateParameter(valid_563951, JString, required = false,
                                 default = nil)
  if valid_563951 != nil:
    section.add "client-request-id", valid_563951
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563974: Call_DataSourcesList_563787; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all datasources available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Data-Sources
  let valid = call_563974.validator(path, query, header, formData, body)
  let scheme = call_563974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563974.url(scheme.get, call_563974.host, call_563974.base,
                         call_563974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563974, url, valid)

proc call*(call_564045: Call_DataSourcesList_563787; apiVersion: string): Recallable =
  ## dataSourcesList
  ## Lists all datasources available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Data-Sources
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564046 = newJObject()
  add(query_564046, "api-version", newJString(apiVersion))
  result = call_564045.call(nil, query_564046, nil, nil, nil)

var dataSourcesList* = Call_DataSourcesList_563787(name: "dataSourcesList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/datasources",
    validator: validate_DataSourcesList_563788, base: "", url: url_DataSourcesList_563789,
    schemes: {Scheme.Https})
type
  Call_DataSourcesCreateOrUpdate_564137 = ref object of OpenApiRestCall_563565
proc url_DataSourcesCreateOrUpdate_564139(protocol: Scheme; host: string;
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

proc validate_DataSourcesCreateOrUpdate_564138(path: JsonNode; query: JsonNode;
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
  var valid_564140 = path.getOrDefault("dataSourceName")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "dataSourceName", valid_564140
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564141 = query.getOrDefault("api-version")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "api-version", valid_564141
  result.add "query", section
  ## parameters in `header` object:
  ##   Prefer: JString (required)
  ##         : For HTTP PUT requests, instructs the service to return the created/updated resource on success.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_564155 = header.getOrDefault("Prefer")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_564155 != nil:
    section.add "Prefer", valid_564155
  var valid_564156 = header.getOrDefault("client-request-id")
  valid_564156 = validateParameter(valid_564156, JString, required = false,
                                 default = nil)
  if valid_564156 != nil:
    section.add "client-request-id", valid_564156
  var valid_564157 = header.getOrDefault("If-None-Match")
  valid_564157 = validateParameter(valid_564157, JString, required = false,
                                 default = nil)
  if valid_564157 != nil:
    section.add "If-None-Match", valid_564157
  var valid_564158 = header.getOrDefault("If-Match")
  valid_564158 = validateParameter(valid_564158, JString, required = false,
                                 default = nil)
  if valid_564158 != nil:
    section.add "If-Match", valid_564158
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

proc call*(call_564160: Call_DataSourcesCreateOrUpdate_564137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search datasource or updates a datasource if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Data-Source
  let valid = call_564160.validator(path, query, header, formData, body)
  let scheme = call_564160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564160.url(scheme.get, call_564160.host, call_564160.base,
                         call_564160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564160, url, valid)

proc call*(call_564161: Call_DataSourcesCreateOrUpdate_564137;
          dataSource: JsonNode; dataSourceName: string; apiVersion: string): Recallable =
  ## dataSourcesCreateOrUpdate
  ## Creates a new Azure Search datasource or updates a datasource if it already exists.
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Data-Source
  ##   dataSource: JObject (required)
  ##             : The definition of the datasource to create or update.
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to create or update.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_564162 = newJObject()
  var query_564163 = newJObject()
  var body_564164 = newJObject()
  if dataSource != nil:
    body_564164 = dataSource
  add(path_564162, "dataSourceName", newJString(dataSourceName))
  add(query_564163, "api-version", newJString(apiVersion))
  result = call_564161.call(path_564162, query_564163, nil, nil, body_564164)

var dataSourcesCreateOrUpdate* = Call_DataSourcesCreateOrUpdate_564137(
    name: "dataSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesCreateOrUpdate_564138, base: "",
    url: url_DataSourcesCreateOrUpdate_564139, schemes: {Scheme.Https})
type
  Call_DataSourcesGet_564113 = ref object of OpenApiRestCall_563565
proc url_DataSourcesGet_564115(protocol: Scheme; host: string; base: string;
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

proc validate_DataSourcesGet_564114(path: JsonNode; query: JsonNode;
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
  var valid_564130 = path.getOrDefault("dataSourceName")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "dataSourceName", valid_564130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564131 = query.getOrDefault("api-version")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "api-version", valid_564131
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564132 = header.getOrDefault("client-request-id")
  valid_564132 = validateParameter(valid_564132, JString, required = false,
                                 default = nil)
  if valid_564132 != nil:
    section.add "client-request-id", valid_564132
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564133: Call_DataSourcesGet_564113; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a datasource definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Data-Source
  let valid = call_564133.validator(path, query, header, formData, body)
  let scheme = call_564133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564133.url(scheme.get, call_564133.host, call_564133.base,
                         call_564133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564133, url, valid)

proc call*(call_564134: Call_DataSourcesGet_564113; dataSourceName: string;
          apiVersion: string): Recallable =
  ## dataSourcesGet
  ## Retrieves a datasource definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Data-Source
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to retrieve.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_564135 = newJObject()
  var query_564136 = newJObject()
  add(path_564135, "dataSourceName", newJString(dataSourceName))
  add(query_564136, "api-version", newJString(apiVersion))
  result = call_564134.call(path_564135, query_564136, nil, nil, nil)

var dataSourcesGet* = Call_DataSourcesGet_564113(name: "dataSourcesGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesGet_564114, base: "", url: url_DataSourcesGet_564115,
    schemes: {Scheme.Https})
type
  Call_DataSourcesDelete_564165 = ref object of OpenApiRestCall_563565
proc url_DataSourcesDelete_564167(protocol: Scheme; host: string; base: string;
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

proc validate_DataSourcesDelete_564166(path: JsonNode; query: JsonNode;
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
  var valid_564168 = path.getOrDefault("dataSourceName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "dataSourceName", valid_564168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564169 = query.getOrDefault("api-version")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "api-version", valid_564169
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  section = newJObject()
  var valid_564170 = header.getOrDefault("client-request-id")
  valid_564170 = validateParameter(valid_564170, JString, required = false,
                                 default = nil)
  if valid_564170 != nil:
    section.add "client-request-id", valid_564170
  var valid_564171 = header.getOrDefault("If-None-Match")
  valid_564171 = validateParameter(valid_564171, JString, required = false,
                                 default = nil)
  if valid_564171 != nil:
    section.add "If-None-Match", valid_564171
  var valid_564172 = header.getOrDefault("If-Match")
  valid_564172 = validateParameter(valid_564172, JString, required = false,
                                 default = nil)
  if valid_564172 != nil:
    section.add "If-Match", valid_564172
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564173: Call_DataSourcesDelete_564165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search datasource.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Data-Source
  let valid = call_564173.validator(path, query, header, formData, body)
  let scheme = call_564173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564173.url(scheme.get, call_564173.host, call_564173.base,
                         call_564173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564173, url, valid)

proc call*(call_564174: Call_DataSourcesDelete_564165; dataSourceName: string;
          apiVersion: string): Recallable =
  ## dataSourcesDelete
  ## Deletes an Azure Search datasource.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Data-Source
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to delete.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_564175 = newJObject()
  var query_564176 = newJObject()
  add(path_564175, "dataSourceName", newJString(dataSourceName))
  add(query_564176, "api-version", newJString(apiVersion))
  result = call_564174.call(path_564175, query_564176, nil, nil, nil)

var dataSourcesDelete* = Call_DataSourcesDelete_564165(name: "dataSourcesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesDelete_564166, base: "",
    url: url_DataSourcesDelete_564167, schemes: {Scheme.Https})
type
  Call_IndexersCreate_564185 = ref object of OpenApiRestCall_563565
proc url_IndexersCreate_564187(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexersCreate_564186(path: JsonNode; query: JsonNode;
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
  var valid_564188 = query.getOrDefault("api-version")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "api-version", valid_564188
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564189 = header.getOrDefault("client-request-id")
  valid_564189 = validateParameter(valid_564189, JString, required = false,
                                 default = nil)
  if valid_564189 != nil:
    section.add "client-request-id", valid_564189
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

proc call*(call_564191: Call_IndexersCreate_564185; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  let valid = call_564191.validator(path, query, header, formData, body)
  let scheme = call_564191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564191.url(scheme.get, call_564191.host, call_564191.base,
                         call_564191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564191, url, valid)

proc call*(call_564192: Call_IndexersCreate_564185; indexer: JsonNode;
          apiVersion: string): Recallable =
  ## indexersCreate
  ## Creates a new Azure Search indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  ##   indexer: JObject (required)
  ##          : The definition of the indexer to create.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564193 = newJObject()
  var body_564194 = newJObject()
  if indexer != nil:
    body_564194 = indexer
  add(query_564193, "api-version", newJString(apiVersion))
  result = call_564192.call(nil, query_564193, nil, nil, body_564194)

var indexersCreate* = Call_IndexersCreate_564185(name: "indexersCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/indexers",
    validator: validate_IndexersCreate_564186, base: "", url: url_IndexersCreate_564187,
    schemes: {Scheme.Https})
type
  Call_IndexersList_564177 = ref object of OpenApiRestCall_563565
proc url_IndexersList_564179(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexersList_564178(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564180 = query.getOrDefault("api-version")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "api-version", valid_564180
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564181 = header.getOrDefault("client-request-id")
  valid_564181 = validateParameter(valid_564181, JString, required = false,
                                 default = nil)
  if valid_564181 != nil:
    section.add "client-request-id", valid_564181
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564182: Call_IndexersList_564177; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all indexers available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexers
  let valid = call_564182.validator(path, query, header, formData, body)
  let scheme = call_564182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564182.url(scheme.get, call_564182.host, call_564182.base,
                         call_564182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564182, url, valid)

proc call*(call_564183: Call_IndexersList_564177; apiVersion: string): Recallable =
  ## indexersList
  ## Lists all indexers available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexers
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564184 = newJObject()
  add(query_564184, "api-version", newJString(apiVersion))
  result = call_564183.call(nil, query_564184, nil, nil, nil)

var indexersList* = Call_IndexersList_564177(name: "indexersList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/indexers",
    validator: validate_IndexersList_564178, base: "", url: url_IndexersList_564179,
    schemes: {Scheme.Https})
type
  Call_IndexersCreateOrUpdate_564205 = ref object of OpenApiRestCall_563565
proc url_IndexersCreateOrUpdate_564207(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersCreateOrUpdate_564206(path: JsonNode; query: JsonNode;
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
  var valid_564208 = path.getOrDefault("indexerName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "indexerName", valid_564208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564209 = query.getOrDefault("api-version")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "api-version", valid_564209
  result.add "query", section
  ## parameters in `header` object:
  ##   Prefer: JString (required)
  ##         : For HTTP PUT requests, instructs the service to return the created/updated resource on success.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_564210 = header.getOrDefault("Prefer")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_564210 != nil:
    section.add "Prefer", valid_564210
  var valid_564211 = header.getOrDefault("client-request-id")
  valid_564211 = validateParameter(valid_564211, JString, required = false,
                                 default = nil)
  if valid_564211 != nil:
    section.add "client-request-id", valid_564211
  var valid_564212 = header.getOrDefault("If-None-Match")
  valid_564212 = validateParameter(valid_564212, JString, required = false,
                                 default = nil)
  if valid_564212 != nil:
    section.add "If-None-Match", valid_564212
  var valid_564213 = header.getOrDefault("If-Match")
  valid_564213 = validateParameter(valid_564213, JString, required = false,
                                 default = nil)
  if valid_564213 != nil:
    section.add "If-Match", valid_564213
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

proc call*(call_564215: Call_IndexersCreateOrUpdate_564205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search indexer or updates an indexer if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  let valid = call_564215.validator(path, query, header, formData, body)
  let scheme = call_564215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564215.url(scheme.get, call_564215.host, call_564215.base,
                         call_564215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564215, url, valid)

proc call*(call_564216: Call_IndexersCreateOrUpdate_564205; indexer: JsonNode;
          apiVersion: string; indexerName: string): Recallable =
  ## indexersCreateOrUpdate
  ## Creates a new Azure Search indexer or updates an indexer if it already exists.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  ##   indexer: JObject (required)
  ##          : The definition of the indexer to create or update.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to create or update.
  var path_564217 = newJObject()
  var query_564218 = newJObject()
  var body_564219 = newJObject()
  if indexer != nil:
    body_564219 = indexer
  add(query_564218, "api-version", newJString(apiVersion))
  add(path_564217, "indexerName", newJString(indexerName))
  result = call_564216.call(path_564217, query_564218, nil, nil, body_564219)

var indexersCreateOrUpdate* = Call_IndexersCreateOrUpdate_564205(
    name: "indexersCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/indexers(\'{indexerName}\')",
    validator: validate_IndexersCreateOrUpdate_564206, base: "",
    url: url_IndexersCreateOrUpdate_564207, schemes: {Scheme.Https})
type
  Call_IndexersGet_564195 = ref object of OpenApiRestCall_563565
proc url_IndexersGet_564197(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersGet_564196(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564198 = path.getOrDefault("indexerName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "indexerName", valid_564198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564199 = query.getOrDefault("api-version")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "api-version", valid_564199
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564200 = header.getOrDefault("client-request-id")
  valid_564200 = validateParameter(valid_564200, JString, required = false,
                                 default = nil)
  if valid_564200 != nil:
    section.add "client-request-id", valid_564200
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564201: Call_IndexersGet_564195; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an indexer definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer
  let valid = call_564201.validator(path, query, header, formData, body)
  let scheme = call_564201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564201.url(scheme.get, call_564201.host, call_564201.base,
                         call_564201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564201, url, valid)

proc call*(call_564202: Call_IndexersGet_564195; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersGet
  ## Retrieves an indexer definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to retrieve.
  var path_564203 = newJObject()
  var query_564204 = newJObject()
  add(query_564204, "api-version", newJString(apiVersion))
  add(path_564203, "indexerName", newJString(indexerName))
  result = call_564202.call(path_564203, query_564204, nil, nil, nil)

var indexersGet* = Call_IndexersGet_564195(name: "indexersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local",
                                        route: "/indexers(\'{indexerName}\')",
                                        validator: validate_IndexersGet_564196,
                                        base: "", url: url_IndexersGet_564197,
                                        schemes: {Scheme.Https})
type
  Call_IndexersDelete_564220 = ref object of OpenApiRestCall_563565
proc url_IndexersDelete_564222(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersDelete_564221(path: JsonNode; query: JsonNode;
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
  var valid_564223 = path.getOrDefault("indexerName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "indexerName", valid_564223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564224 = query.getOrDefault("api-version")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "api-version", valid_564224
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  section = newJObject()
  var valid_564225 = header.getOrDefault("client-request-id")
  valid_564225 = validateParameter(valid_564225, JString, required = false,
                                 default = nil)
  if valid_564225 != nil:
    section.add "client-request-id", valid_564225
  var valid_564226 = header.getOrDefault("If-None-Match")
  valid_564226 = validateParameter(valid_564226, JString, required = false,
                                 default = nil)
  if valid_564226 != nil:
    section.add "If-None-Match", valid_564226
  var valid_564227 = header.getOrDefault("If-Match")
  valid_564227 = validateParameter(valid_564227, JString, required = false,
                                 default = nil)
  if valid_564227 != nil:
    section.add "If-Match", valid_564227
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564228: Call_IndexersDelete_564220; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Indexer
  let valid = call_564228.validator(path, query, header, formData, body)
  let scheme = call_564228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564228.url(scheme.get, call_564228.host, call_564228.base,
                         call_564228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564228, url, valid)

proc call*(call_564229: Call_IndexersDelete_564220; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersDelete
  ## Deletes an Azure Search indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to delete.
  var path_564230 = newJObject()
  var query_564231 = newJObject()
  add(query_564231, "api-version", newJString(apiVersion))
  add(path_564230, "indexerName", newJString(indexerName))
  result = call_564229.call(path_564230, query_564231, nil, nil, nil)

var indexersDelete* = Call_IndexersDelete_564220(name: "indexersDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/indexers(\'{indexerName}\')", validator: validate_IndexersDelete_564221,
    base: "", url: url_IndexersDelete_564222, schemes: {Scheme.Https})
type
  Call_IndexersReset_564232 = ref object of OpenApiRestCall_563565
proc url_IndexersReset_564234(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersReset_564233(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564235 = path.getOrDefault("indexerName")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "indexerName", valid_564235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564236 = query.getOrDefault("api-version")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "api-version", valid_564236
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564237 = header.getOrDefault("client-request-id")
  valid_564237 = validateParameter(valid_564237, JString, required = false,
                                 default = nil)
  if valid_564237 != nil:
    section.add "client-request-id", valid_564237
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564238: Call_IndexersReset_564232; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the change tracking state associated with an Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Reset-Indexer
  let valid = call_564238.validator(path, query, header, formData, body)
  let scheme = call_564238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564238.url(scheme.get, call_564238.host, call_564238.base,
                         call_564238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564238, url, valid)

proc call*(call_564239: Call_IndexersReset_564232; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersReset
  ## Resets the change tracking state associated with an Azure Search indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Reset-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to reset.
  var path_564240 = newJObject()
  var query_564241 = newJObject()
  add(query_564241, "api-version", newJString(apiVersion))
  add(path_564240, "indexerName", newJString(indexerName))
  result = call_564239.call(path_564240, query_564241, nil, nil, nil)

var indexersReset* = Call_IndexersReset_564232(name: "indexersReset",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/indexers(\'{indexerName}\')/search.reset",
    validator: validate_IndexersReset_564233, base: "", url: url_IndexersReset_564234,
    schemes: {Scheme.Https})
type
  Call_IndexersRun_564242 = ref object of OpenApiRestCall_563565
proc url_IndexersRun_564244(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersRun_564243(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564245 = path.getOrDefault("indexerName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "indexerName", valid_564245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564246 = query.getOrDefault("api-version")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "api-version", valid_564246
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564247 = header.getOrDefault("client-request-id")
  valid_564247 = validateParameter(valid_564247, JString, required = false,
                                 default = nil)
  if valid_564247 != nil:
    section.add "client-request-id", valid_564247
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564248: Call_IndexersRun_564242; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs an Azure Search indexer on-demand.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Run-Indexer
  let valid = call_564248.validator(path, query, header, formData, body)
  let scheme = call_564248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564248.url(scheme.get, call_564248.host, call_564248.base,
                         call_564248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564248, url, valid)

proc call*(call_564249: Call_IndexersRun_564242; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersRun
  ## Runs an Azure Search indexer on-demand.
  ## https://docs.microsoft.com/rest/api/searchservice/Run-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to run.
  var path_564250 = newJObject()
  var query_564251 = newJObject()
  add(query_564251, "api-version", newJString(apiVersion))
  add(path_564250, "indexerName", newJString(indexerName))
  result = call_564249.call(path_564250, query_564251, nil, nil, nil)

var indexersRun* = Call_IndexersRun_564242(name: "indexersRun",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local", route: "/indexers(\'{indexerName}\')/search.run",
                                        validator: validate_IndexersRun_564243,
                                        base: "", url: url_IndexersRun_564244,
                                        schemes: {Scheme.Https})
type
  Call_IndexersGetStatus_564252 = ref object of OpenApiRestCall_563565
proc url_IndexersGetStatus_564254(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersGetStatus_564253(path: JsonNode; query: JsonNode;
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
  var valid_564255 = path.getOrDefault("indexerName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "indexerName", valid_564255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564256 = query.getOrDefault("api-version")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "api-version", valid_564256
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564257 = header.getOrDefault("client-request-id")
  valid_564257 = validateParameter(valid_564257, JString, required = false,
                                 default = nil)
  if valid_564257 != nil:
    section.add "client-request-id", valid_564257
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564258: Call_IndexersGetStatus_564252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the current status and execution history of an indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer-Status
  let valid = call_564258.validator(path, query, header, formData, body)
  let scheme = call_564258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564258.url(scheme.get, call_564258.host, call_564258.base,
                         call_564258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564258, url, valid)

proc call*(call_564259: Call_IndexersGetStatus_564252; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersGetStatus
  ## Returns the current status and execution history of an indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer-Status
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer for which to retrieve status.
  var path_564260 = newJObject()
  var query_564261 = newJObject()
  add(query_564261, "api-version", newJString(apiVersion))
  add(path_564260, "indexerName", newJString(indexerName))
  result = call_564259.call(path_564260, query_564261, nil, nil, nil)

var indexersGetStatus* = Call_IndexersGetStatus_564252(name: "indexersGetStatus",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/indexers(\'{indexerName}\')/search.status",
    validator: validate_IndexersGetStatus_564253, base: "",
    url: url_IndexersGetStatus_564254, schemes: {Scheme.Https})
type
  Call_IndexesCreate_564272 = ref object of OpenApiRestCall_563565
proc url_IndexesCreate_564274(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexesCreate_564273(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564275 = query.getOrDefault("api-version")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "api-version", valid_564275
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564276 = header.getOrDefault("client-request-id")
  valid_564276 = validateParameter(valid_564276, JString, required = false,
                                 default = nil)
  if valid_564276 != nil:
    section.add "client-request-id", valid_564276
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

proc call*(call_564278: Call_IndexesCreate_564272; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Index
  let valid = call_564278.validator(path, query, header, formData, body)
  let scheme = call_564278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564278.url(scheme.get, call_564278.host, call_564278.base,
                         call_564278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564278, url, valid)

proc call*(call_564279: Call_IndexesCreate_564272; index: JsonNode;
          apiVersion: string): Recallable =
  ## indexesCreate
  ## Creates a new Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Index
  ##   index: JObject (required)
  ##        : The definition of the index to create.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564280 = newJObject()
  var body_564281 = newJObject()
  if index != nil:
    body_564281 = index
  add(query_564280, "api-version", newJString(apiVersion))
  result = call_564279.call(nil, query_564280, nil, nil, body_564281)

var indexesCreate* = Call_IndexesCreate_564272(name: "indexesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/indexes",
    validator: validate_IndexesCreate_564273, base: "", url: url_IndexesCreate_564274,
    schemes: {Scheme.Https})
type
  Call_IndexesList_564262 = ref object of OpenApiRestCall_563565
proc url_IndexesList_564264(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexesList_564263(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564266 = query.getOrDefault("api-version")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "api-version", valid_564266
  var valid_564267 = query.getOrDefault("$select")
  valid_564267 = validateParameter(valid_564267, JString, required = false,
                                 default = nil)
  if valid_564267 != nil:
    section.add "$select", valid_564267
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564268 = header.getOrDefault("client-request-id")
  valid_564268 = validateParameter(valid_564268, JString, required = false,
                                 default = nil)
  if valid_564268 != nil:
    section.add "client-request-id", valid_564268
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564269: Call_IndexesList_564262; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all indexes available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexes
  let valid = call_564269.validator(path, query, header, formData, body)
  let scheme = call_564269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564269.url(scheme.get, call_564269.host, call_564269.base,
                         call_564269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564269, url, valid)

proc call*(call_564270: Call_IndexesList_564262; apiVersion: string;
          Select: string = ""): Recallable =
  ## indexesList
  ## Lists all indexes available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexes
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : Selects which properties of the index definitions to retrieve. Specified as a comma-separated list of JSON property names, or '*' for all properties. The default is all properties.
  var query_564271 = newJObject()
  add(query_564271, "api-version", newJString(apiVersion))
  add(query_564271, "$select", newJString(Select))
  result = call_564270.call(nil, query_564271, nil, nil, nil)

var indexesList* = Call_IndexesList_564262(name: "indexesList",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/indexes",
                                        validator: validate_IndexesList_564263,
                                        base: "", url: url_IndexesList_564264,
                                        schemes: {Scheme.Https})
type
  Call_IndexesCreateOrUpdate_564292 = ref object of OpenApiRestCall_563565
proc url_IndexesCreateOrUpdate_564294(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesCreateOrUpdate_564293(path: JsonNode; query: JsonNode;
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
  var valid_564295 = path.getOrDefault("indexName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "indexName", valid_564295
  result.add "path", section
  ## parameters in `query` object:
  ##   allowIndexDowntime: JBool
  ##                     : Allows new analyzers, tokenizers, token filters, or char filters to be added to an index by taking the index offline for at least a few seconds. This temporarily causes indexing and query requests to fail. Performance and write availability of the index can be impaired for several minutes after the index is updated, or longer for very large indexes.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_564296 = query.getOrDefault("allowIndexDowntime")
  valid_564296 = validateParameter(valid_564296, JBool, required = false, default = nil)
  if valid_564296 != nil:
    section.add "allowIndexDowntime", valid_564296
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564297 = query.getOrDefault("api-version")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "api-version", valid_564297
  result.add "query", section
  ## parameters in `header` object:
  ##   Prefer: JString (required)
  ##         : For HTTP PUT requests, instructs the service to return the created/updated resource on success.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_564298 = header.getOrDefault("Prefer")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_564298 != nil:
    section.add "Prefer", valid_564298
  var valid_564299 = header.getOrDefault("client-request-id")
  valid_564299 = validateParameter(valid_564299, JString, required = false,
                                 default = nil)
  if valid_564299 != nil:
    section.add "client-request-id", valid_564299
  var valid_564300 = header.getOrDefault("If-None-Match")
  valid_564300 = validateParameter(valid_564300, JString, required = false,
                                 default = nil)
  if valid_564300 != nil:
    section.add "If-None-Match", valid_564300
  var valid_564301 = header.getOrDefault("If-Match")
  valid_564301 = validateParameter(valid_564301, JString, required = false,
                                 default = nil)
  if valid_564301 != nil:
    section.add "If-Match", valid_564301
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

proc call*(call_564303: Call_IndexesCreateOrUpdate_564292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search index or updates an index if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Index
  let valid = call_564303.validator(path, query, header, formData, body)
  let scheme = call_564303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564303.url(scheme.get, call_564303.host, call_564303.base,
                         call_564303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564303, url, valid)

proc call*(call_564304: Call_IndexesCreateOrUpdate_564292; index: JsonNode;
          apiVersion: string; indexName: string; allowIndexDowntime: bool = false): Recallable =
  ## indexesCreateOrUpdate
  ## Creates a new Azure Search index or updates an index if it already exists.
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Index
  ##   index: JObject (required)
  ##        : The definition of the index to create or update.
  ##   allowIndexDowntime: bool
  ##                     : Allows new analyzers, tokenizers, token filters, or char filters to be added to an index by taking the index offline for at least a few seconds. This temporarily causes indexing and query requests to fail. Performance and write availability of the index can be impaired for several minutes after the index is updated, or longer for very large indexes.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexName: string (required)
  ##            : The definition of the index to create or update.
  var path_564305 = newJObject()
  var query_564306 = newJObject()
  var body_564307 = newJObject()
  if index != nil:
    body_564307 = index
  add(query_564306, "allowIndexDowntime", newJBool(allowIndexDowntime))
  add(query_564306, "api-version", newJString(apiVersion))
  add(path_564305, "indexName", newJString(indexName))
  result = call_564304.call(path_564305, query_564306, nil, nil, body_564307)

var indexesCreateOrUpdate* = Call_IndexesCreateOrUpdate_564292(
    name: "indexesCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/indexes(\'{indexName}\')", validator: validate_IndexesCreateOrUpdate_564293,
    base: "", url: url_IndexesCreateOrUpdate_564294, schemes: {Scheme.Https})
type
  Call_IndexesGet_564282 = ref object of OpenApiRestCall_563565
proc url_IndexesGet_564284(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_IndexesGet_564283(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564285 = path.getOrDefault("indexName")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "indexName", valid_564285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564286 = query.getOrDefault("api-version")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "api-version", valid_564286
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564287 = header.getOrDefault("client-request-id")
  valid_564287 = validateParameter(valid_564287, JString, required = false,
                                 default = nil)
  if valid_564287 != nil:
    section.add "client-request-id", valid_564287
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564288: Call_IndexesGet_564282; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an index definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index
  let valid = call_564288.validator(path, query, header, formData, body)
  let scheme = call_564288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564288.url(scheme.get, call_564288.host, call_564288.base,
                         call_564288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564288, url, valid)

proc call*(call_564289: Call_IndexesGet_564282; apiVersion: string; indexName: string): Recallable =
  ## indexesGet
  ## Retrieves an index definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexName: string (required)
  ##            : The name of the index to retrieve.
  var path_564290 = newJObject()
  var query_564291 = newJObject()
  add(query_564291, "api-version", newJString(apiVersion))
  add(path_564290, "indexName", newJString(indexName))
  result = call_564289.call(path_564290, query_564291, nil, nil, nil)

var indexesGet* = Call_IndexesGet_564282(name: "indexesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local",
                                      route: "/indexes(\'{indexName}\')",
                                      validator: validate_IndexesGet_564283,
                                      base: "", url: url_IndexesGet_564284,
                                      schemes: {Scheme.Https})
type
  Call_IndexesDelete_564308 = ref object of OpenApiRestCall_563565
proc url_IndexesDelete_564310(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesDelete_564309(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564311 = path.getOrDefault("indexName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "indexName", valid_564311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564312 = query.getOrDefault("api-version")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "api-version", valid_564312
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  section = newJObject()
  var valid_564313 = header.getOrDefault("client-request-id")
  valid_564313 = validateParameter(valid_564313, JString, required = false,
                                 default = nil)
  if valid_564313 != nil:
    section.add "client-request-id", valid_564313
  var valid_564314 = header.getOrDefault("If-None-Match")
  valid_564314 = validateParameter(valid_564314, JString, required = false,
                                 default = nil)
  if valid_564314 != nil:
    section.add "If-None-Match", valid_564314
  var valid_564315 = header.getOrDefault("If-Match")
  valid_564315 = validateParameter(valid_564315, JString, required = false,
                                 default = nil)
  if valid_564315 != nil:
    section.add "If-Match", valid_564315
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564316: Call_IndexesDelete_564308; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search index and all the documents it contains.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Index
  let valid = call_564316.validator(path, query, header, formData, body)
  let scheme = call_564316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564316.url(scheme.get, call_564316.host, call_564316.base,
                         call_564316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564316, url, valid)

proc call*(call_564317: Call_IndexesDelete_564308; apiVersion: string;
          indexName: string): Recallable =
  ## indexesDelete
  ## Deletes an Azure Search index and all the documents it contains.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Index
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexName: string (required)
  ##            : The name of the index to delete.
  var path_564318 = newJObject()
  var query_564319 = newJObject()
  add(query_564319, "api-version", newJString(apiVersion))
  add(path_564318, "indexName", newJString(indexName))
  result = call_564317.call(path_564318, query_564319, nil, nil, nil)

var indexesDelete* = Call_IndexesDelete_564308(name: "indexesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/indexes(\'{indexName}\')", validator: validate_IndexesDelete_564309,
    base: "", url: url_IndexesDelete_564310, schemes: {Scheme.Https})
type
  Call_IndexesAnalyze_564320 = ref object of OpenApiRestCall_563565
proc url_IndexesAnalyze_564322(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesAnalyze_564321(path: JsonNode; query: JsonNode;
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
  var valid_564323 = path.getOrDefault("indexName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "indexName", valid_564323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564324 = query.getOrDefault("api-version")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "api-version", valid_564324
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564325 = header.getOrDefault("client-request-id")
  valid_564325 = validateParameter(valid_564325, JString, required = false,
                                 default = nil)
  if valid_564325 != nil:
    section.add "client-request-id", valid_564325
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

proc call*(call_564327: Call_IndexesAnalyze_564320; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shows how an analyzer breaks text into tokens.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/test-analyzer
  let valid = call_564327.validator(path, query, header, formData, body)
  let scheme = call_564327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564327.url(scheme.get, call_564327.host, call_564327.base,
                         call_564327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564327, url, valid)

proc call*(call_564328: Call_IndexesAnalyze_564320; apiVersion: string;
          indexName: string; request: JsonNode): Recallable =
  ## indexesAnalyze
  ## Shows how an analyzer breaks text into tokens.
  ## https://docs.microsoft.com/rest/api/searchservice/test-analyzer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexName: string (required)
  ##            : The name of the index for which to test an analyzer.
  ##   request: JObject (required)
  ##          : The text and analyzer or analysis components to test.
  var path_564329 = newJObject()
  var query_564330 = newJObject()
  var body_564331 = newJObject()
  add(query_564330, "api-version", newJString(apiVersion))
  add(path_564329, "indexName", newJString(indexName))
  if request != nil:
    body_564331 = request
  result = call_564328.call(path_564329, query_564330, nil, nil, body_564331)

var indexesAnalyze* = Call_IndexesAnalyze_564320(name: "indexesAnalyze",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/indexes(\'{indexName}\')/search.analyze",
    validator: validate_IndexesAnalyze_564321, base: "", url: url_IndexesAnalyze_564322,
    schemes: {Scheme.Https})
type
  Call_IndexesGetStatistics_564332 = ref object of OpenApiRestCall_563565
proc url_IndexesGetStatistics_564334(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesGetStatistics_564333(path: JsonNode; query: JsonNode;
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
  var valid_564335 = path.getOrDefault("indexName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "indexName", valid_564335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564336 = query.getOrDefault("api-version")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "api-version", valid_564336
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564337 = header.getOrDefault("client-request-id")
  valid_564337 = validateParameter(valid_564337, JString, required = false,
                                 default = nil)
  if valid_564337 != nil:
    section.add "client-request-id", valid_564337
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564338: Call_IndexesGetStatistics_564332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns statistics for the given index, including a document count and storage usage.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index-Statistics
  let valid = call_564338.validator(path, query, header, formData, body)
  let scheme = call_564338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564338.url(scheme.get, call_564338.host, call_564338.base,
                         call_564338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564338, url, valid)

proc call*(call_564339: Call_IndexesGetStatistics_564332; apiVersion: string;
          indexName: string): Recallable =
  ## indexesGetStatistics
  ## Returns statistics for the given index, including a document count and storage usage.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index-Statistics
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexName: string (required)
  ##            : The name of the index for which to retrieve statistics.
  var path_564340 = newJObject()
  var query_564341 = newJObject()
  add(query_564341, "api-version", newJString(apiVersion))
  add(path_564340, "indexName", newJString(indexName))
  result = call_564339.call(path_564340, query_564341, nil, nil, nil)

var indexesGetStatistics* = Call_IndexesGetStatistics_564332(
    name: "indexesGetStatistics", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/indexes(\'{indexName}\')/search.stats",
    validator: validate_IndexesGetStatistics_564333, base: "",
    url: url_IndexesGetStatistics_564334, schemes: {Scheme.Https})
type
  Call_GetServiceStatistics_564342 = ref object of OpenApiRestCall_563565
proc url_GetServiceStatistics_564344(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetServiceStatistics_564343(path: JsonNode; query: JsonNode;
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
  var valid_564345 = query.getOrDefault("api-version")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "api-version", valid_564345
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564346 = header.getOrDefault("client-request-id")
  valid_564346 = validateParameter(valid_564346, JString, required = false,
                                 default = nil)
  if valid_564346 != nil:
    section.add "client-request-id", valid_564346
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564347: Call_GetServiceStatistics_564342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets service level statistics for an Azure Search service.
  ## 
  let valid = call_564347.validator(path, query, header, formData, body)
  let scheme = call_564347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564347.url(scheme.get, call_564347.host, call_564347.base,
                         call_564347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564347, url, valid)

proc call*(call_564348: Call_GetServiceStatistics_564342; apiVersion: string): Recallable =
  ## getServiceStatistics
  ## Gets service level statistics for an Azure Search service.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564349 = newJObject()
  add(query_564349, "api-version", newJString(apiVersion))
  result = call_564348.call(nil, query_564349, nil, nil, nil)

var getServiceStatistics* = Call_GetServiceStatistics_564342(
    name: "getServiceStatistics", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/servicestats", validator: validate_GetServiceStatistics_564343,
    base: "", url: url_GetServiceStatistics_564344, schemes: {Scheme.Https})
type
  Call_SynonymMapsCreate_564358 = ref object of OpenApiRestCall_563565
proc url_SynonymMapsCreate_564360(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SynonymMapsCreate_564359(path: JsonNode; query: JsonNode;
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
  var valid_564361 = query.getOrDefault("api-version")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "api-version", valid_564361
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564362 = header.getOrDefault("client-request-id")
  valid_564362 = validateParameter(valid_564362, JString, required = false,
                                 default = nil)
  if valid_564362 != nil:
    section.add "client-request-id", valid_564362
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

proc call*(call_564364: Call_SynonymMapsCreate_564358; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search synonym map.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Synonym-Map
  let valid = call_564364.validator(path, query, header, formData, body)
  let scheme = call_564364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564364.url(scheme.get, call_564364.host, call_564364.base,
                         call_564364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564364, url, valid)

proc call*(call_564365: Call_SynonymMapsCreate_564358; synonymMap: JsonNode;
          apiVersion: string): Recallable =
  ## synonymMapsCreate
  ## Creates a new Azure Search synonym map.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Synonym-Map
  ##   synonymMap: JObject (required)
  ##             : The definition of the synonym map to create.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564366 = newJObject()
  var body_564367 = newJObject()
  if synonymMap != nil:
    body_564367 = synonymMap
  add(query_564366, "api-version", newJString(apiVersion))
  result = call_564365.call(nil, query_564366, nil, nil, body_564367)

var synonymMapsCreate* = Call_SynonymMapsCreate_564358(name: "synonymMapsCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/synonymmaps",
    validator: validate_SynonymMapsCreate_564359, base: "",
    url: url_SynonymMapsCreate_564360, schemes: {Scheme.Https})
type
  Call_SynonymMapsList_564350 = ref object of OpenApiRestCall_563565
proc url_SynonymMapsList_564352(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SynonymMapsList_564351(path: JsonNode; query: JsonNode;
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
  var valid_564353 = query.getOrDefault("api-version")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "api-version", valid_564353
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564354 = header.getOrDefault("client-request-id")
  valid_564354 = validateParameter(valid_564354, JString, required = false,
                                 default = nil)
  if valid_564354 != nil:
    section.add "client-request-id", valid_564354
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564355: Call_SynonymMapsList_564350; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all synonym maps available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Synonym-Maps
  let valid = call_564355.validator(path, query, header, formData, body)
  let scheme = call_564355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564355.url(scheme.get, call_564355.host, call_564355.base,
                         call_564355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564355, url, valid)

proc call*(call_564356: Call_SynonymMapsList_564350; apiVersion: string): Recallable =
  ## synonymMapsList
  ## Lists all synonym maps available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Synonym-Maps
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564357 = newJObject()
  add(query_564357, "api-version", newJString(apiVersion))
  result = call_564356.call(nil, query_564357, nil, nil, nil)

var synonymMapsList* = Call_SynonymMapsList_564350(name: "synonymMapsList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/synonymmaps",
    validator: validate_SynonymMapsList_564351, base: "", url: url_SynonymMapsList_564352,
    schemes: {Scheme.Https})
type
  Call_SynonymMapsCreateOrUpdate_564378 = ref object of OpenApiRestCall_563565
proc url_SynonymMapsCreateOrUpdate_564380(protocol: Scheme; host: string;
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

proc validate_SynonymMapsCreateOrUpdate_564379(path: JsonNode; query: JsonNode;
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
  var valid_564381 = path.getOrDefault("synonymMapName")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "synonymMapName", valid_564381
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564382 = query.getOrDefault("api-version")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "api-version", valid_564382
  result.add "query", section
  ## parameters in `header` object:
  ##   Prefer: JString (required)
  ##         : For HTTP PUT requests, instructs the service to return the created/updated resource on success.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_564383 = header.getOrDefault("Prefer")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_564383 != nil:
    section.add "Prefer", valid_564383
  var valid_564384 = header.getOrDefault("client-request-id")
  valid_564384 = validateParameter(valid_564384, JString, required = false,
                                 default = nil)
  if valid_564384 != nil:
    section.add "client-request-id", valid_564384
  var valid_564385 = header.getOrDefault("If-None-Match")
  valid_564385 = validateParameter(valid_564385, JString, required = false,
                                 default = nil)
  if valid_564385 != nil:
    section.add "If-None-Match", valid_564385
  var valid_564386 = header.getOrDefault("If-Match")
  valid_564386 = validateParameter(valid_564386, JString, required = false,
                                 default = nil)
  if valid_564386 != nil:
    section.add "If-Match", valid_564386
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

proc call*(call_564388: Call_SynonymMapsCreateOrUpdate_564378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search synonym map or updates a synonym map if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Synonym-Map
  let valid = call_564388.validator(path, query, header, formData, body)
  let scheme = call_564388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564388.url(scheme.get, call_564388.host, call_564388.base,
                         call_564388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564388, url, valid)

proc call*(call_564389: Call_SynonymMapsCreateOrUpdate_564378;
          synonymMap: JsonNode; apiVersion: string; synonymMapName: string): Recallable =
  ## synonymMapsCreateOrUpdate
  ## Creates a new Azure Search synonym map or updates a synonym map if it already exists.
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Synonym-Map
  ##   synonymMap: JObject (required)
  ##             : The definition of the synonym map to create or update.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   synonymMapName: string (required)
  ##                 : The name of the synonym map to create or update.
  var path_564390 = newJObject()
  var query_564391 = newJObject()
  var body_564392 = newJObject()
  if synonymMap != nil:
    body_564392 = synonymMap
  add(query_564391, "api-version", newJString(apiVersion))
  add(path_564390, "synonymMapName", newJString(synonymMapName))
  result = call_564389.call(path_564390, query_564391, nil, nil, body_564392)

var synonymMapsCreateOrUpdate* = Call_SynonymMapsCreateOrUpdate_564378(
    name: "synonymMapsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/synonymmaps(\'{synonymMapName}\')",
    validator: validate_SynonymMapsCreateOrUpdate_564379, base: "",
    url: url_SynonymMapsCreateOrUpdate_564380, schemes: {Scheme.Https})
type
  Call_SynonymMapsGet_564368 = ref object of OpenApiRestCall_563565
proc url_SynonymMapsGet_564370(protocol: Scheme; host: string; base: string;
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

proc validate_SynonymMapsGet_564369(path: JsonNode; query: JsonNode;
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
  var valid_564371 = path.getOrDefault("synonymMapName")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "synonymMapName", valid_564371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564372 = query.getOrDefault("api-version")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "api-version", valid_564372
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564373 = header.getOrDefault("client-request-id")
  valid_564373 = validateParameter(valid_564373, JString, required = false,
                                 default = nil)
  if valid_564373 != nil:
    section.add "client-request-id", valid_564373
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564374: Call_SynonymMapsGet_564368; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a synonym map definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Synonym-Map
  let valid = call_564374.validator(path, query, header, formData, body)
  let scheme = call_564374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564374.url(scheme.get, call_564374.host, call_564374.base,
                         call_564374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564374, url, valid)

proc call*(call_564375: Call_SynonymMapsGet_564368; apiVersion: string;
          synonymMapName: string): Recallable =
  ## synonymMapsGet
  ## Retrieves a synonym map definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Synonym-Map
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   synonymMapName: string (required)
  ##                 : The name of the synonym map to retrieve.
  var path_564376 = newJObject()
  var query_564377 = newJObject()
  add(query_564377, "api-version", newJString(apiVersion))
  add(path_564376, "synonymMapName", newJString(synonymMapName))
  result = call_564375.call(path_564376, query_564377, nil, nil, nil)

var synonymMapsGet* = Call_SynonymMapsGet_564368(name: "synonymMapsGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/synonymmaps(\'{synonymMapName}\')",
    validator: validate_SynonymMapsGet_564369, base: "", url: url_SynonymMapsGet_564370,
    schemes: {Scheme.Https})
type
  Call_SynonymMapsDelete_564393 = ref object of OpenApiRestCall_563565
proc url_SynonymMapsDelete_564395(protocol: Scheme; host: string; base: string;
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

proc validate_SynonymMapsDelete_564394(path: JsonNode; query: JsonNode;
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
  var valid_564396 = path.getOrDefault("synonymMapName")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "synonymMapName", valid_564396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564397 = query.getOrDefault("api-version")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "api-version", valid_564397
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  section = newJObject()
  var valid_564398 = header.getOrDefault("client-request-id")
  valid_564398 = validateParameter(valid_564398, JString, required = false,
                                 default = nil)
  if valid_564398 != nil:
    section.add "client-request-id", valid_564398
  var valid_564399 = header.getOrDefault("If-None-Match")
  valid_564399 = validateParameter(valid_564399, JString, required = false,
                                 default = nil)
  if valid_564399 != nil:
    section.add "If-None-Match", valid_564399
  var valid_564400 = header.getOrDefault("If-Match")
  valid_564400 = validateParameter(valid_564400, JString, required = false,
                                 default = nil)
  if valid_564400 != nil:
    section.add "If-Match", valid_564400
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564401: Call_SynonymMapsDelete_564393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search synonym map.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Synonym-Map
  let valid = call_564401.validator(path, query, header, formData, body)
  let scheme = call_564401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564401.url(scheme.get, call_564401.host, call_564401.base,
                         call_564401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564401, url, valid)

proc call*(call_564402: Call_SynonymMapsDelete_564393; apiVersion: string;
          synonymMapName: string): Recallable =
  ## synonymMapsDelete
  ## Deletes an Azure Search synonym map.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Synonym-Map
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   synonymMapName: string (required)
  ##                 : The name of the synonym map to delete.
  var path_564403 = newJObject()
  var query_564404 = newJObject()
  add(query_564404, "api-version", newJString(apiVersion))
  add(path_564403, "synonymMapName", newJString(synonymMapName))
  result = call_564402.call(path_564403, query_564404, nil, nil, nil)

var synonymMapsDelete* = Call_SynonymMapsDelete_564393(name: "synonymMapsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/synonymmaps(\'{synonymMapName}\')",
    validator: validate_SynonymMapsDelete_564394, base: "",
    url: url_SynonymMapsDelete_564395, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
