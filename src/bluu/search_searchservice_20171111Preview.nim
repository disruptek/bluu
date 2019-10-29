
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SearchServiceClient
## version: 2017-11-11-Preview
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

  OpenApiRestCall_563566 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563566](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563566): Option[Scheme] {.used.} =
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
  Call_DataSourcesCreate_564087 = ref object of OpenApiRestCall_563566
proc url_DataSourcesCreate_564089(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DataSourcesCreate_564088(path: JsonNode; query: JsonNode;
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
  var valid_564107 = query.getOrDefault("api-version")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "api-version", valid_564107
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564108 = header.getOrDefault("client-request-id")
  valid_564108 = validateParameter(valid_564108, JString, required = false,
                                 default = nil)
  if valid_564108 != nil:
    section.add "client-request-id", valid_564108
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

proc call*(call_564110: Call_DataSourcesCreate_564087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search datasource.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Data-Source
  let valid = call_564110.validator(path, query, header, formData, body)
  let scheme = call_564110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564110.url(scheme.get, call_564110.host, call_564110.base,
                         call_564110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564110, url, valid)

proc call*(call_564111: Call_DataSourcesCreate_564087; dataSource: JsonNode;
          apiVersion: string): Recallable =
  ## dataSourcesCreate
  ## Creates a new Azure Search datasource.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Data-Source
  ##   dataSource: JObject (required)
  ##             : The definition of the datasource to create.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564112 = newJObject()
  var body_564113 = newJObject()
  if dataSource != nil:
    body_564113 = dataSource
  add(query_564112, "api-version", newJString(apiVersion))
  result = call_564111.call(nil, query_564112, nil, nil, body_564113)

var dataSourcesCreate* = Call_DataSourcesCreate_564087(name: "dataSourcesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/datasources",
    validator: validate_DataSourcesCreate_564088, base: "",
    url: url_DataSourcesCreate_564089, schemes: {Scheme.Https})
type
  Call_DataSourcesList_563788 = ref object of OpenApiRestCall_563566
proc url_DataSourcesList_563790(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DataSourcesList_563789(path: JsonNode; query: JsonNode;
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
  var valid_563951 = query.getOrDefault("api-version")
  valid_563951 = validateParameter(valid_563951, JString, required = true,
                                 default = nil)
  if valid_563951 != nil:
    section.add "api-version", valid_563951
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_563952 = header.getOrDefault("client-request-id")
  valid_563952 = validateParameter(valid_563952, JString, required = false,
                                 default = nil)
  if valid_563952 != nil:
    section.add "client-request-id", valid_563952
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563975: Call_DataSourcesList_563788; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all datasources available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Data-Sources
  let valid = call_563975.validator(path, query, header, formData, body)
  let scheme = call_563975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563975.url(scheme.get, call_563975.host, call_563975.base,
                         call_563975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563975, url, valid)

proc call*(call_564046: Call_DataSourcesList_563788; apiVersion: string): Recallable =
  ## dataSourcesList
  ## Lists all datasources available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Data-Sources
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564047 = newJObject()
  add(query_564047, "api-version", newJString(apiVersion))
  result = call_564046.call(nil, query_564047, nil, nil, nil)

var dataSourcesList* = Call_DataSourcesList_563788(name: "dataSourcesList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/datasources",
    validator: validate_DataSourcesList_563789, base: "", url: url_DataSourcesList_563790,
    schemes: {Scheme.Https})
type
  Call_DataSourcesCreateOrUpdate_564138 = ref object of OpenApiRestCall_563566
proc url_DataSourcesCreateOrUpdate_564140(protocol: Scheme; host: string;
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

proc validate_DataSourcesCreateOrUpdate_564139(path: JsonNode; query: JsonNode;
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
  var valid_564141 = path.getOrDefault("dataSourceName")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "dataSourceName", valid_564141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564142 = query.getOrDefault("api-version")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "api-version", valid_564142
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
  var valid_564156 = header.getOrDefault("Prefer")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_564156 != nil:
    section.add "Prefer", valid_564156
  var valid_564157 = header.getOrDefault("client-request-id")
  valid_564157 = validateParameter(valid_564157, JString, required = false,
                                 default = nil)
  if valid_564157 != nil:
    section.add "client-request-id", valid_564157
  var valid_564158 = header.getOrDefault("If-None-Match")
  valid_564158 = validateParameter(valid_564158, JString, required = false,
                                 default = nil)
  if valid_564158 != nil:
    section.add "If-None-Match", valid_564158
  var valid_564159 = header.getOrDefault("If-Match")
  valid_564159 = validateParameter(valid_564159, JString, required = false,
                                 default = nil)
  if valid_564159 != nil:
    section.add "If-Match", valid_564159
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

proc call*(call_564161: Call_DataSourcesCreateOrUpdate_564138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search datasource or updates a datasource if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Data-Source
  let valid = call_564161.validator(path, query, header, formData, body)
  let scheme = call_564161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564161.url(scheme.get, call_564161.host, call_564161.base,
                         call_564161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564161, url, valid)

proc call*(call_564162: Call_DataSourcesCreateOrUpdate_564138;
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
  var path_564163 = newJObject()
  var query_564164 = newJObject()
  var body_564165 = newJObject()
  if dataSource != nil:
    body_564165 = dataSource
  add(path_564163, "dataSourceName", newJString(dataSourceName))
  add(query_564164, "api-version", newJString(apiVersion))
  result = call_564162.call(path_564163, query_564164, nil, nil, body_564165)

var dataSourcesCreateOrUpdate* = Call_DataSourcesCreateOrUpdate_564138(
    name: "dataSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesCreateOrUpdate_564139, base: "",
    url: url_DataSourcesCreateOrUpdate_564140, schemes: {Scheme.Https})
type
  Call_DataSourcesGet_564114 = ref object of OpenApiRestCall_563566
proc url_DataSourcesGet_564116(protocol: Scheme; host: string; base: string;
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

proc validate_DataSourcesGet_564115(path: JsonNode; query: JsonNode;
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
  var valid_564131 = path.getOrDefault("dataSourceName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "dataSourceName", valid_564131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564132 = query.getOrDefault("api-version")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "api-version", valid_564132
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564133 = header.getOrDefault("client-request-id")
  valid_564133 = validateParameter(valid_564133, JString, required = false,
                                 default = nil)
  if valid_564133 != nil:
    section.add "client-request-id", valid_564133
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564134: Call_DataSourcesGet_564114; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a datasource definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Data-Source
  let valid = call_564134.validator(path, query, header, formData, body)
  let scheme = call_564134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564134.url(scheme.get, call_564134.host, call_564134.base,
                         call_564134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564134, url, valid)

proc call*(call_564135: Call_DataSourcesGet_564114; dataSourceName: string;
          apiVersion: string): Recallable =
  ## dataSourcesGet
  ## Retrieves a datasource definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Data-Source
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to retrieve.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_564136 = newJObject()
  var query_564137 = newJObject()
  add(path_564136, "dataSourceName", newJString(dataSourceName))
  add(query_564137, "api-version", newJString(apiVersion))
  result = call_564135.call(path_564136, query_564137, nil, nil, nil)

var dataSourcesGet* = Call_DataSourcesGet_564114(name: "dataSourcesGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesGet_564115, base: "", url: url_DataSourcesGet_564116,
    schemes: {Scheme.Https})
type
  Call_DataSourcesDelete_564166 = ref object of OpenApiRestCall_563566
proc url_DataSourcesDelete_564168(protocol: Scheme; host: string; base: string;
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

proc validate_DataSourcesDelete_564167(path: JsonNode; query: JsonNode;
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
  var valid_564169 = path.getOrDefault("dataSourceName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "dataSourceName", valid_564169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564170 = query.getOrDefault("api-version")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "api-version", valid_564170
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  section = newJObject()
  var valid_564171 = header.getOrDefault("client-request-id")
  valid_564171 = validateParameter(valid_564171, JString, required = false,
                                 default = nil)
  if valid_564171 != nil:
    section.add "client-request-id", valid_564171
  var valid_564172 = header.getOrDefault("If-None-Match")
  valid_564172 = validateParameter(valid_564172, JString, required = false,
                                 default = nil)
  if valid_564172 != nil:
    section.add "If-None-Match", valid_564172
  var valid_564173 = header.getOrDefault("If-Match")
  valid_564173 = validateParameter(valid_564173, JString, required = false,
                                 default = nil)
  if valid_564173 != nil:
    section.add "If-Match", valid_564173
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564174: Call_DataSourcesDelete_564166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search datasource.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Data-Source
  let valid = call_564174.validator(path, query, header, formData, body)
  let scheme = call_564174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564174.url(scheme.get, call_564174.host, call_564174.base,
                         call_564174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564174, url, valid)

proc call*(call_564175: Call_DataSourcesDelete_564166; dataSourceName: string;
          apiVersion: string): Recallable =
  ## dataSourcesDelete
  ## Deletes an Azure Search datasource.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Data-Source
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to delete.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_564176 = newJObject()
  var query_564177 = newJObject()
  add(path_564176, "dataSourceName", newJString(dataSourceName))
  add(query_564177, "api-version", newJString(apiVersion))
  result = call_564175.call(path_564176, query_564177, nil, nil, nil)

var dataSourcesDelete* = Call_DataSourcesDelete_564166(name: "dataSourcesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesDelete_564167, base: "",
    url: url_DataSourcesDelete_564168, schemes: {Scheme.Https})
type
  Call_IndexersCreate_564186 = ref object of OpenApiRestCall_563566
proc url_IndexersCreate_564188(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexersCreate_564187(path: JsonNode; query: JsonNode;
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
  var valid_564189 = query.getOrDefault("api-version")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "api-version", valid_564189
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564190 = header.getOrDefault("client-request-id")
  valid_564190 = validateParameter(valid_564190, JString, required = false,
                                 default = nil)
  if valid_564190 != nil:
    section.add "client-request-id", valid_564190
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

proc call*(call_564192: Call_IndexersCreate_564186; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  let valid = call_564192.validator(path, query, header, formData, body)
  let scheme = call_564192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564192.url(scheme.get, call_564192.host, call_564192.base,
                         call_564192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564192, url, valid)

proc call*(call_564193: Call_IndexersCreate_564186; indexer: JsonNode;
          apiVersion: string): Recallable =
  ## indexersCreate
  ## Creates a new Azure Search indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  ##   indexer: JObject (required)
  ##          : The definition of the indexer to create.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564194 = newJObject()
  var body_564195 = newJObject()
  if indexer != nil:
    body_564195 = indexer
  add(query_564194, "api-version", newJString(apiVersion))
  result = call_564193.call(nil, query_564194, nil, nil, body_564195)

var indexersCreate* = Call_IndexersCreate_564186(name: "indexersCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/indexers",
    validator: validate_IndexersCreate_564187, base: "", url: url_IndexersCreate_564188,
    schemes: {Scheme.Https})
type
  Call_IndexersList_564178 = ref object of OpenApiRestCall_563566
proc url_IndexersList_564180(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexersList_564179(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564181 = query.getOrDefault("api-version")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "api-version", valid_564181
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564182 = header.getOrDefault("client-request-id")
  valid_564182 = validateParameter(valid_564182, JString, required = false,
                                 default = nil)
  if valid_564182 != nil:
    section.add "client-request-id", valid_564182
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564183: Call_IndexersList_564178; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all indexers available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexers
  let valid = call_564183.validator(path, query, header, formData, body)
  let scheme = call_564183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564183.url(scheme.get, call_564183.host, call_564183.base,
                         call_564183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564183, url, valid)

proc call*(call_564184: Call_IndexersList_564178; apiVersion: string): Recallable =
  ## indexersList
  ## Lists all indexers available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexers
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564185 = newJObject()
  add(query_564185, "api-version", newJString(apiVersion))
  result = call_564184.call(nil, query_564185, nil, nil, nil)

var indexersList* = Call_IndexersList_564178(name: "indexersList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/indexers",
    validator: validate_IndexersList_564179, base: "", url: url_IndexersList_564180,
    schemes: {Scheme.Https})
type
  Call_IndexersCreateOrUpdate_564206 = ref object of OpenApiRestCall_563566
proc url_IndexersCreateOrUpdate_564208(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersCreateOrUpdate_564207(path: JsonNode; query: JsonNode;
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
  var valid_564209 = path.getOrDefault("indexerName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "indexerName", valid_564209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564210 = query.getOrDefault("api-version")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "api-version", valid_564210
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
  var valid_564211 = header.getOrDefault("Prefer")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_564211 != nil:
    section.add "Prefer", valid_564211
  var valid_564212 = header.getOrDefault("client-request-id")
  valid_564212 = validateParameter(valid_564212, JString, required = false,
                                 default = nil)
  if valid_564212 != nil:
    section.add "client-request-id", valid_564212
  var valid_564213 = header.getOrDefault("If-None-Match")
  valid_564213 = validateParameter(valid_564213, JString, required = false,
                                 default = nil)
  if valid_564213 != nil:
    section.add "If-None-Match", valid_564213
  var valid_564214 = header.getOrDefault("If-Match")
  valid_564214 = validateParameter(valid_564214, JString, required = false,
                                 default = nil)
  if valid_564214 != nil:
    section.add "If-Match", valid_564214
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

proc call*(call_564216: Call_IndexersCreateOrUpdate_564206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search indexer or updates an indexer if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  let valid = call_564216.validator(path, query, header, formData, body)
  let scheme = call_564216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564216.url(scheme.get, call_564216.host, call_564216.base,
                         call_564216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564216, url, valid)

proc call*(call_564217: Call_IndexersCreateOrUpdate_564206; indexer: JsonNode;
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
  var path_564218 = newJObject()
  var query_564219 = newJObject()
  var body_564220 = newJObject()
  if indexer != nil:
    body_564220 = indexer
  add(query_564219, "api-version", newJString(apiVersion))
  add(path_564218, "indexerName", newJString(indexerName))
  result = call_564217.call(path_564218, query_564219, nil, nil, body_564220)

var indexersCreateOrUpdate* = Call_IndexersCreateOrUpdate_564206(
    name: "indexersCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/indexers(\'{indexerName}\')",
    validator: validate_IndexersCreateOrUpdate_564207, base: "",
    url: url_IndexersCreateOrUpdate_564208, schemes: {Scheme.Https})
type
  Call_IndexersGet_564196 = ref object of OpenApiRestCall_563566
proc url_IndexersGet_564198(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersGet_564197(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564199 = path.getOrDefault("indexerName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "indexerName", valid_564199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564200 = query.getOrDefault("api-version")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "api-version", valid_564200
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564201 = header.getOrDefault("client-request-id")
  valid_564201 = validateParameter(valid_564201, JString, required = false,
                                 default = nil)
  if valid_564201 != nil:
    section.add "client-request-id", valid_564201
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564202: Call_IndexersGet_564196; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an indexer definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer
  let valid = call_564202.validator(path, query, header, formData, body)
  let scheme = call_564202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564202.url(scheme.get, call_564202.host, call_564202.base,
                         call_564202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564202, url, valid)

proc call*(call_564203: Call_IndexersGet_564196; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersGet
  ## Retrieves an indexer definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to retrieve.
  var path_564204 = newJObject()
  var query_564205 = newJObject()
  add(query_564205, "api-version", newJString(apiVersion))
  add(path_564204, "indexerName", newJString(indexerName))
  result = call_564203.call(path_564204, query_564205, nil, nil, nil)

var indexersGet* = Call_IndexersGet_564196(name: "indexersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local",
                                        route: "/indexers(\'{indexerName}\')",
                                        validator: validate_IndexersGet_564197,
                                        base: "", url: url_IndexersGet_564198,
                                        schemes: {Scheme.Https})
type
  Call_IndexersDelete_564221 = ref object of OpenApiRestCall_563566
proc url_IndexersDelete_564223(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersDelete_564222(path: JsonNode; query: JsonNode;
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
  var valid_564224 = path.getOrDefault("indexerName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "indexerName", valid_564224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564225 = query.getOrDefault("api-version")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "api-version", valid_564225
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  section = newJObject()
  var valid_564226 = header.getOrDefault("client-request-id")
  valid_564226 = validateParameter(valid_564226, JString, required = false,
                                 default = nil)
  if valid_564226 != nil:
    section.add "client-request-id", valid_564226
  var valid_564227 = header.getOrDefault("If-None-Match")
  valid_564227 = validateParameter(valid_564227, JString, required = false,
                                 default = nil)
  if valid_564227 != nil:
    section.add "If-None-Match", valid_564227
  var valid_564228 = header.getOrDefault("If-Match")
  valid_564228 = validateParameter(valid_564228, JString, required = false,
                                 default = nil)
  if valid_564228 != nil:
    section.add "If-Match", valid_564228
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564229: Call_IndexersDelete_564221; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Indexer
  let valid = call_564229.validator(path, query, header, formData, body)
  let scheme = call_564229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564229.url(scheme.get, call_564229.host, call_564229.base,
                         call_564229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564229, url, valid)

proc call*(call_564230: Call_IndexersDelete_564221; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersDelete
  ## Deletes an Azure Search indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to delete.
  var path_564231 = newJObject()
  var query_564232 = newJObject()
  add(query_564232, "api-version", newJString(apiVersion))
  add(path_564231, "indexerName", newJString(indexerName))
  result = call_564230.call(path_564231, query_564232, nil, nil, nil)

var indexersDelete* = Call_IndexersDelete_564221(name: "indexersDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/indexers(\'{indexerName}\')", validator: validate_IndexersDelete_564222,
    base: "", url: url_IndexersDelete_564223, schemes: {Scheme.Https})
type
  Call_IndexersReset_564233 = ref object of OpenApiRestCall_563566
proc url_IndexersReset_564235(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersReset_564234(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564236 = path.getOrDefault("indexerName")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "indexerName", valid_564236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564237 = query.getOrDefault("api-version")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "api-version", valid_564237
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564238 = header.getOrDefault("client-request-id")
  valid_564238 = validateParameter(valid_564238, JString, required = false,
                                 default = nil)
  if valid_564238 != nil:
    section.add "client-request-id", valid_564238
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564239: Call_IndexersReset_564233; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the change tracking state associated with an Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Reset-Indexer
  let valid = call_564239.validator(path, query, header, formData, body)
  let scheme = call_564239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564239.url(scheme.get, call_564239.host, call_564239.base,
                         call_564239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564239, url, valid)

proc call*(call_564240: Call_IndexersReset_564233; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersReset
  ## Resets the change tracking state associated with an Azure Search indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Reset-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to reset.
  var path_564241 = newJObject()
  var query_564242 = newJObject()
  add(query_564242, "api-version", newJString(apiVersion))
  add(path_564241, "indexerName", newJString(indexerName))
  result = call_564240.call(path_564241, query_564242, nil, nil, nil)

var indexersReset* = Call_IndexersReset_564233(name: "indexersReset",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/indexers(\'{indexerName}\')/search.reset",
    validator: validate_IndexersReset_564234, base: "", url: url_IndexersReset_564235,
    schemes: {Scheme.Https})
type
  Call_IndexersRun_564243 = ref object of OpenApiRestCall_563566
proc url_IndexersRun_564245(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersRun_564244(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564246 = path.getOrDefault("indexerName")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "indexerName", valid_564246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564247 = query.getOrDefault("api-version")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "api-version", valid_564247
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564248 = header.getOrDefault("client-request-id")
  valid_564248 = validateParameter(valid_564248, JString, required = false,
                                 default = nil)
  if valid_564248 != nil:
    section.add "client-request-id", valid_564248
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564249: Call_IndexersRun_564243; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs an Azure Search indexer on-demand.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Run-Indexer
  let valid = call_564249.validator(path, query, header, formData, body)
  let scheme = call_564249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564249.url(scheme.get, call_564249.host, call_564249.base,
                         call_564249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564249, url, valid)

proc call*(call_564250: Call_IndexersRun_564243; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersRun
  ## Runs an Azure Search indexer on-demand.
  ## https://docs.microsoft.com/rest/api/searchservice/Run-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to run.
  var path_564251 = newJObject()
  var query_564252 = newJObject()
  add(query_564252, "api-version", newJString(apiVersion))
  add(path_564251, "indexerName", newJString(indexerName))
  result = call_564250.call(path_564251, query_564252, nil, nil, nil)

var indexersRun* = Call_IndexersRun_564243(name: "indexersRun",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local", route: "/indexers(\'{indexerName}\')/search.run",
                                        validator: validate_IndexersRun_564244,
                                        base: "", url: url_IndexersRun_564245,
                                        schemes: {Scheme.Https})
type
  Call_IndexersGetStatus_564253 = ref object of OpenApiRestCall_563566
proc url_IndexersGetStatus_564255(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersGetStatus_564254(path: JsonNode; query: JsonNode;
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
  var valid_564256 = path.getOrDefault("indexerName")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "indexerName", valid_564256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564257 = query.getOrDefault("api-version")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "api-version", valid_564257
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564258 = header.getOrDefault("client-request-id")
  valid_564258 = validateParameter(valid_564258, JString, required = false,
                                 default = nil)
  if valid_564258 != nil:
    section.add "client-request-id", valid_564258
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564259: Call_IndexersGetStatus_564253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the current status and execution history of an indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer-Status
  let valid = call_564259.validator(path, query, header, formData, body)
  let scheme = call_564259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564259.url(scheme.get, call_564259.host, call_564259.base,
                         call_564259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564259, url, valid)

proc call*(call_564260: Call_IndexersGetStatus_564253; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersGetStatus
  ## Returns the current status and execution history of an indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer-Status
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer for which to retrieve status.
  var path_564261 = newJObject()
  var query_564262 = newJObject()
  add(query_564262, "api-version", newJString(apiVersion))
  add(path_564261, "indexerName", newJString(indexerName))
  result = call_564260.call(path_564261, query_564262, nil, nil, nil)

var indexersGetStatus* = Call_IndexersGetStatus_564253(name: "indexersGetStatus",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/indexers(\'{indexerName}\')/search.status",
    validator: validate_IndexersGetStatus_564254, base: "",
    url: url_IndexersGetStatus_564255, schemes: {Scheme.Https})
type
  Call_IndexesCreate_564273 = ref object of OpenApiRestCall_563566
proc url_IndexesCreate_564275(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexesCreate_564274(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564276 = query.getOrDefault("api-version")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "api-version", valid_564276
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564277 = header.getOrDefault("client-request-id")
  valid_564277 = validateParameter(valid_564277, JString, required = false,
                                 default = nil)
  if valid_564277 != nil:
    section.add "client-request-id", valid_564277
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

proc call*(call_564279: Call_IndexesCreate_564273; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Index
  let valid = call_564279.validator(path, query, header, formData, body)
  let scheme = call_564279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564279.url(scheme.get, call_564279.host, call_564279.base,
                         call_564279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564279, url, valid)

proc call*(call_564280: Call_IndexesCreate_564273; index: JsonNode;
          apiVersion: string): Recallable =
  ## indexesCreate
  ## Creates a new Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Index
  ##   index: JObject (required)
  ##        : The definition of the index to create.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564281 = newJObject()
  var body_564282 = newJObject()
  if index != nil:
    body_564282 = index
  add(query_564281, "api-version", newJString(apiVersion))
  result = call_564280.call(nil, query_564281, nil, nil, body_564282)

var indexesCreate* = Call_IndexesCreate_564273(name: "indexesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/indexes",
    validator: validate_IndexesCreate_564274, base: "", url: url_IndexesCreate_564275,
    schemes: {Scheme.Https})
type
  Call_IndexesList_564263 = ref object of OpenApiRestCall_563566
proc url_IndexesList_564265(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexesList_564264(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564267 = query.getOrDefault("api-version")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "api-version", valid_564267
  var valid_564268 = query.getOrDefault("$select")
  valid_564268 = validateParameter(valid_564268, JString, required = false,
                                 default = nil)
  if valid_564268 != nil:
    section.add "$select", valid_564268
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564269 = header.getOrDefault("client-request-id")
  valid_564269 = validateParameter(valid_564269, JString, required = false,
                                 default = nil)
  if valid_564269 != nil:
    section.add "client-request-id", valid_564269
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564270: Call_IndexesList_564263; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all indexes available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexes
  let valid = call_564270.validator(path, query, header, formData, body)
  let scheme = call_564270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564270.url(scheme.get, call_564270.host, call_564270.base,
                         call_564270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564270, url, valid)

proc call*(call_564271: Call_IndexesList_564263; apiVersion: string;
          Select: string = ""): Recallable =
  ## indexesList
  ## Lists all indexes available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexes
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : Selects which properties of the index definitions to retrieve. Specified as a comma-separated list of JSON property names, or '*' for all properties. The default is all properties.
  var query_564272 = newJObject()
  add(query_564272, "api-version", newJString(apiVersion))
  add(query_564272, "$select", newJString(Select))
  result = call_564271.call(nil, query_564272, nil, nil, nil)

var indexesList* = Call_IndexesList_564263(name: "indexesList",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/indexes",
                                        validator: validate_IndexesList_564264,
                                        base: "", url: url_IndexesList_564265,
                                        schemes: {Scheme.Https})
type
  Call_IndexesCreateOrUpdate_564293 = ref object of OpenApiRestCall_563566
proc url_IndexesCreateOrUpdate_564295(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesCreateOrUpdate_564294(path: JsonNode; query: JsonNode;
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
  var valid_564296 = path.getOrDefault("indexName")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "indexName", valid_564296
  result.add "path", section
  ## parameters in `query` object:
  ##   allowIndexDowntime: JBool
  ##                     : Allows new analyzers, tokenizers, token filters, or char filters to be added to an index by taking the index offline for at least a few seconds. This temporarily causes indexing and query requests to fail. Performance and write availability of the index can be impaired for several minutes after the index is updated, or longer for very large indexes.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_564297 = query.getOrDefault("allowIndexDowntime")
  valid_564297 = validateParameter(valid_564297, JBool, required = false, default = nil)
  if valid_564297 != nil:
    section.add "allowIndexDowntime", valid_564297
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564298 = query.getOrDefault("api-version")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "api-version", valid_564298
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
  var valid_564299 = header.getOrDefault("Prefer")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_564299 != nil:
    section.add "Prefer", valid_564299
  var valid_564300 = header.getOrDefault("client-request-id")
  valid_564300 = validateParameter(valid_564300, JString, required = false,
                                 default = nil)
  if valid_564300 != nil:
    section.add "client-request-id", valid_564300
  var valid_564301 = header.getOrDefault("If-None-Match")
  valid_564301 = validateParameter(valid_564301, JString, required = false,
                                 default = nil)
  if valid_564301 != nil:
    section.add "If-None-Match", valid_564301
  var valid_564302 = header.getOrDefault("If-Match")
  valid_564302 = validateParameter(valid_564302, JString, required = false,
                                 default = nil)
  if valid_564302 != nil:
    section.add "If-Match", valid_564302
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

proc call*(call_564304: Call_IndexesCreateOrUpdate_564293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search index or updates an index if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Index
  let valid = call_564304.validator(path, query, header, formData, body)
  let scheme = call_564304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564304.url(scheme.get, call_564304.host, call_564304.base,
                         call_564304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564304, url, valid)

proc call*(call_564305: Call_IndexesCreateOrUpdate_564293; index: JsonNode;
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
  var path_564306 = newJObject()
  var query_564307 = newJObject()
  var body_564308 = newJObject()
  if index != nil:
    body_564308 = index
  add(query_564307, "allowIndexDowntime", newJBool(allowIndexDowntime))
  add(query_564307, "api-version", newJString(apiVersion))
  add(path_564306, "indexName", newJString(indexName))
  result = call_564305.call(path_564306, query_564307, nil, nil, body_564308)

var indexesCreateOrUpdate* = Call_IndexesCreateOrUpdate_564293(
    name: "indexesCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/indexes(\'{indexName}\')", validator: validate_IndexesCreateOrUpdate_564294,
    base: "", url: url_IndexesCreateOrUpdate_564295, schemes: {Scheme.Https})
type
  Call_IndexesGet_564283 = ref object of OpenApiRestCall_563566
proc url_IndexesGet_564285(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_IndexesGet_564284(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564286 = path.getOrDefault("indexName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "indexName", valid_564286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564287 = query.getOrDefault("api-version")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "api-version", valid_564287
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564288 = header.getOrDefault("client-request-id")
  valid_564288 = validateParameter(valid_564288, JString, required = false,
                                 default = nil)
  if valid_564288 != nil:
    section.add "client-request-id", valid_564288
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564289: Call_IndexesGet_564283; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an index definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index
  let valid = call_564289.validator(path, query, header, formData, body)
  let scheme = call_564289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564289.url(scheme.get, call_564289.host, call_564289.base,
                         call_564289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564289, url, valid)

proc call*(call_564290: Call_IndexesGet_564283; apiVersion: string; indexName: string): Recallable =
  ## indexesGet
  ## Retrieves an index definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexName: string (required)
  ##            : The name of the index to retrieve.
  var path_564291 = newJObject()
  var query_564292 = newJObject()
  add(query_564292, "api-version", newJString(apiVersion))
  add(path_564291, "indexName", newJString(indexName))
  result = call_564290.call(path_564291, query_564292, nil, nil, nil)

var indexesGet* = Call_IndexesGet_564283(name: "indexesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local",
                                      route: "/indexes(\'{indexName}\')",
                                      validator: validate_IndexesGet_564284,
                                      base: "", url: url_IndexesGet_564285,
                                      schemes: {Scheme.Https})
type
  Call_IndexesDelete_564309 = ref object of OpenApiRestCall_563566
proc url_IndexesDelete_564311(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesDelete_564310(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564312 = path.getOrDefault("indexName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "indexName", valid_564312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564313 = query.getOrDefault("api-version")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "api-version", valid_564313
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  section = newJObject()
  var valid_564314 = header.getOrDefault("client-request-id")
  valid_564314 = validateParameter(valid_564314, JString, required = false,
                                 default = nil)
  if valid_564314 != nil:
    section.add "client-request-id", valid_564314
  var valid_564315 = header.getOrDefault("If-None-Match")
  valid_564315 = validateParameter(valid_564315, JString, required = false,
                                 default = nil)
  if valid_564315 != nil:
    section.add "If-None-Match", valid_564315
  var valid_564316 = header.getOrDefault("If-Match")
  valid_564316 = validateParameter(valid_564316, JString, required = false,
                                 default = nil)
  if valid_564316 != nil:
    section.add "If-Match", valid_564316
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564317: Call_IndexesDelete_564309; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search index and all the documents it contains.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Index
  let valid = call_564317.validator(path, query, header, formData, body)
  let scheme = call_564317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564317.url(scheme.get, call_564317.host, call_564317.base,
                         call_564317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564317, url, valid)

proc call*(call_564318: Call_IndexesDelete_564309; apiVersion: string;
          indexName: string): Recallable =
  ## indexesDelete
  ## Deletes an Azure Search index and all the documents it contains.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Index
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexName: string (required)
  ##            : The name of the index to delete.
  var path_564319 = newJObject()
  var query_564320 = newJObject()
  add(query_564320, "api-version", newJString(apiVersion))
  add(path_564319, "indexName", newJString(indexName))
  result = call_564318.call(path_564319, query_564320, nil, nil, nil)

var indexesDelete* = Call_IndexesDelete_564309(name: "indexesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/indexes(\'{indexName}\')", validator: validate_IndexesDelete_564310,
    base: "", url: url_IndexesDelete_564311, schemes: {Scheme.Https})
type
  Call_IndexesAnalyze_564321 = ref object of OpenApiRestCall_563566
proc url_IndexesAnalyze_564323(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesAnalyze_564322(path: JsonNode; query: JsonNode;
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
  var valid_564324 = path.getOrDefault("indexName")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "indexName", valid_564324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564325 = query.getOrDefault("api-version")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "api-version", valid_564325
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564326 = header.getOrDefault("client-request-id")
  valid_564326 = validateParameter(valid_564326, JString, required = false,
                                 default = nil)
  if valid_564326 != nil:
    section.add "client-request-id", valid_564326
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

proc call*(call_564328: Call_IndexesAnalyze_564321; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shows how an analyzer breaks text into tokens.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/test-analyzer
  let valid = call_564328.validator(path, query, header, formData, body)
  let scheme = call_564328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564328.url(scheme.get, call_564328.host, call_564328.base,
                         call_564328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564328, url, valid)

proc call*(call_564329: Call_IndexesAnalyze_564321; apiVersion: string;
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
  var path_564330 = newJObject()
  var query_564331 = newJObject()
  var body_564332 = newJObject()
  add(query_564331, "api-version", newJString(apiVersion))
  add(path_564330, "indexName", newJString(indexName))
  if request != nil:
    body_564332 = request
  result = call_564329.call(path_564330, query_564331, nil, nil, body_564332)

var indexesAnalyze* = Call_IndexesAnalyze_564321(name: "indexesAnalyze",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/indexes(\'{indexName}\')/search.analyze",
    validator: validate_IndexesAnalyze_564322, base: "", url: url_IndexesAnalyze_564323,
    schemes: {Scheme.Https})
type
  Call_IndexesGetStatistics_564333 = ref object of OpenApiRestCall_563566
proc url_IndexesGetStatistics_564335(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesGetStatistics_564334(path: JsonNode; query: JsonNode;
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
  var valid_564336 = path.getOrDefault("indexName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "indexName", valid_564336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564337 = query.getOrDefault("api-version")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "api-version", valid_564337
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564338 = header.getOrDefault("client-request-id")
  valid_564338 = validateParameter(valid_564338, JString, required = false,
                                 default = nil)
  if valid_564338 != nil:
    section.add "client-request-id", valid_564338
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564339: Call_IndexesGetStatistics_564333; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns statistics for the given index, including a document count and storage usage.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index-Statistics
  let valid = call_564339.validator(path, query, header, formData, body)
  let scheme = call_564339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564339.url(scheme.get, call_564339.host, call_564339.base,
                         call_564339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564339, url, valid)

proc call*(call_564340: Call_IndexesGetStatistics_564333; apiVersion: string;
          indexName: string): Recallable =
  ## indexesGetStatistics
  ## Returns statistics for the given index, including a document count and storage usage.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index-Statistics
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexName: string (required)
  ##            : The name of the index for which to retrieve statistics.
  var path_564341 = newJObject()
  var query_564342 = newJObject()
  add(query_564342, "api-version", newJString(apiVersion))
  add(path_564341, "indexName", newJString(indexName))
  result = call_564340.call(path_564341, query_564342, nil, nil, nil)

var indexesGetStatistics* = Call_IndexesGetStatistics_564333(
    name: "indexesGetStatistics", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/indexes(\'{indexName}\')/search.stats",
    validator: validate_IndexesGetStatistics_564334, base: "",
    url: url_IndexesGetStatistics_564335, schemes: {Scheme.Https})
type
  Call_GetServiceStatistics_564343 = ref object of OpenApiRestCall_563566
proc url_GetServiceStatistics_564345(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetServiceStatistics_564344(path: JsonNode; query: JsonNode;
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
  var valid_564346 = query.getOrDefault("api-version")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "api-version", valid_564346
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564347 = header.getOrDefault("client-request-id")
  valid_564347 = validateParameter(valid_564347, JString, required = false,
                                 default = nil)
  if valid_564347 != nil:
    section.add "client-request-id", valid_564347
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564348: Call_GetServiceStatistics_564343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets service level statistics for an Azure Search service.
  ## 
  let valid = call_564348.validator(path, query, header, formData, body)
  let scheme = call_564348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564348.url(scheme.get, call_564348.host, call_564348.base,
                         call_564348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564348, url, valid)

proc call*(call_564349: Call_GetServiceStatistics_564343; apiVersion: string): Recallable =
  ## getServiceStatistics
  ## Gets service level statistics for an Azure Search service.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564350 = newJObject()
  add(query_564350, "api-version", newJString(apiVersion))
  result = call_564349.call(nil, query_564350, nil, nil, nil)

var getServiceStatistics* = Call_GetServiceStatistics_564343(
    name: "getServiceStatistics", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/servicestats", validator: validate_GetServiceStatistics_564344,
    base: "", url: url_GetServiceStatistics_564345, schemes: {Scheme.Https})
type
  Call_SkillsetsCreate_564359 = ref object of OpenApiRestCall_563566
proc url_SkillsetsCreate_564361(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SkillsetsCreate_564360(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Creates a new cognitive skillset in an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/create-skillset
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
  var valid_564362 = query.getOrDefault("api-version")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "api-version", valid_564362
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564363 = header.getOrDefault("client-request-id")
  valid_564363 = validateParameter(valid_564363, JString, required = false,
                                 default = nil)
  if valid_564363 != nil:
    section.add "client-request-id", valid_564363
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   skillset: JObject (required)
  ##           : The skillset containing one or more cognitive skills to create in an Azure Search service.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564365: Call_SkillsetsCreate_564359; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new cognitive skillset in an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/create-skillset
  let valid = call_564365.validator(path, query, header, formData, body)
  let scheme = call_564365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564365.url(scheme.get, call_564365.host, call_564365.base,
                         call_564365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564365, url, valid)

proc call*(call_564366: Call_SkillsetsCreate_564359; skillset: JsonNode;
          apiVersion: string): Recallable =
  ## skillsetsCreate
  ## Creates a new cognitive skillset in an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/create-skillset
  ##   skillset: JObject (required)
  ##           : The skillset containing one or more cognitive skills to create in an Azure Search service.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564367 = newJObject()
  var body_564368 = newJObject()
  if skillset != nil:
    body_564368 = skillset
  add(query_564367, "api-version", newJString(apiVersion))
  result = call_564366.call(nil, query_564367, nil, nil, body_564368)

var skillsetsCreate* = Call_SkillsetsCreate_564359(name: "skillsetsCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/skillsets",
    validator: validate_SkillsetsCreate_564360, base: "", url: url_SkillsetsCreate_564361,
    schemes: {Scheme.Https})
type
  Call_SkillsetsList_564351 = ref object of OpenApiRestCall_563566
proc url_SkillsetsList_564353(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SkillsetsList_564352(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## List all cognitive skillsets in an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/list-skillset
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
  var valid_564354 = query.getOrDefault("api-version")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "api-version", valid_564354
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564355 = header.getOrDefault("client-request-id")
  valid_564355 = validateParameter(valid_564355, JString, required = false,
                                 default = nil)
  if valid_564355 != nil:
    section.add "client-request-id", valid_564355
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564356: Call_SkillsetsList_564351; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all cognitive skillsets in an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/list-skillset
  let valid = call_564356.validator(path, query, header, formData, body)
  let scheme = call_564356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564356.url(scheme.get, call_564356.host, call_564356.base,
                         call_564356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564356, url, valid)

proc call*(call_564357: Call_SkillsetsList_564351; apiVersion: string): Recallable =
  ## skillsetsList
  ## List all cognitive skillsets in an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/list-skillset
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564358 = newJObject()
  add(query_564358, "api-version", newJString(apiVersion))
  result = call_564357.call(nil, query_564358, nil, nil, nil)

var skillsetsList* = Call_SkillsetsList_564351(name: "skillsetsList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/skillsets",
    validator: validate_SkillsetsList_564352, base: "", url: url_SkillsetsList_564353,
    schemes: {Scheme.Https})
type
  Call_SkillsetsCreateOrUpdate_564379 = ref object of OpenApiRestCall_563566
proc url_SkillsetsCreateOrUpdate_564381(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "skillsetName" in path, "`skillsetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/skillsets(\'"),
               (kind: VariableSegment, value: "skillsetName"),
               (kind: ConstantSegment, value: "\')")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SkillsetsCreateOrUpdate_564380(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new cognitive skillset in an Azure Search service or updates the skillset if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/update-skillset
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skillsetName: JString (required)
  ##               : The name of the skillset to create or update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `skillsetName` field"
  var valid_564382 = path.getOrDefault("skillsetName")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "skillsetName", valid_564382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564383 = query.getOrDefault("api-version")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "api-version", valid_564383
  result.add "query", section
  ## parameters in `header` object:
  ##   Prefer: JString (required)
  ##         : For HTTP PUT requests, instructs the service to return the created/updated resource on success.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_564384 = header.getOrDefault("Prefer")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_564384 != nil:
    section.add "Prefer", valid_564384
  var valid_564385 = header.getOrDefault("client-request-id")
  valid_564385 = validateParameter(valid_564385, JString, required = false,
                                 default = nil)
  if valid_564385 != nil:
    section.add "client-request-id", valid_564385
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   skillset: JObject (required)
  ##           : The skillset containing one or more cognitive skills to create or update in an Azure Search service.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564387: Call_SkillsetsCreateOrUpdate_564379; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new cognitive skillset in an Azure Search service or updates the skillset if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/update-skillset
  let valid = call_564387.validator(path, query, header, formData, body)
  let scheme = call_564387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564387.url(scheme.get, call_564387.host, call_564387.base,
                         call_564387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564387, url, valid)

proc call*(call_564388: Call_SkillsetsCreateOrUpdate_564379; skillset: JsonNode;
          apiVersion: string; skillsetName: string): Recallable =
  ## skillsetsCreateOrUpdate
  ## Creates a new cognitive skillset in an Azure Search service or updates the skillset if it already exists.
  ## https://docs.microsoft.com/rest/api/searchservice/update-skillset
  ##   skillset: JObject (required)
  ##           : The skillset containing one or more cognitive skills to create or update in an Azure Search service.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skillsetName: string (required)
  ##               : The name of the skillset to create or update.
  var path_564389 = newJObject()
  var query_564390 = newJObject()
  var body_564391 = newJObject()
  if skillset != nil:
    body_564391 = skillset
  add(query_564390, "api-version", newJString(apiVersion))
  add(path_564389, "skillsetName", newJString(skillsetName))
  result = call_564388.call(path_564389, query_564390, nil, nil, body_564391)

var skillsetsCreateOrUpdate* = Call_SkillsetsCreateOrUpdate_564379(
    name: "skillsetsCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/skillsets(\'{skillsetName}\')",
    validator: validate_SkillsetsCreateOrUpdate_564380, base: "",
    url: url_SkillsetsCreateOrUpdate_564381, schemes: {Scheme.Https})
type
  Call_SkillsetsGet_564369 = ref object of OpenApiRestCall_563566
proc url_SkillsetsGet_564371(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "skillsetName" in path, "`skillsetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/skillsets(\'"),
               (kind: VariableSegment, value: "skillsetName"),
               (kind: ConstantSegment, value: "\')")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SkillsetsGet_564370(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a cognitive skillset in an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/get-skillset
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skillsetName: JString (required)
  ##               : The name of the skillset to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `skillsetName` field"
  var valid_564372 = path.getOrDefault("skillsetName")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "skillsetName", valid_564372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564374 = header.getOrDefault("client-request-id")
  valid_564374 = validateParameter(valid_564374, JString, required = false,
                                 default = nil)
  if valid_564374 != nil:
    section.add "client-request-id", valid_564374
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564375: Call_SkillsetsGet_564369; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a cognitive skillset in an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/get-skillset
  let valid = call_564375.validator(path, query, header, formData, body)
  let scheme = call_564375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564375.url(scheme.get, call_564375.host, call_564375.base,
                         call_564375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564375, url, valid)

proc call*(call_564376: Call_SkillsetsGet_564369; apiVersion: string;
          skillsetName: string): Recallable =
  ## skillsetsGet
  ## Retrieves a cognitive skillset in an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/get-skillset
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skillsetName: string (required)
  ##               : The name of the skillset to retrieve.
  var path_564377 = newJObject()
  var query_564378 = newJObject()
  add(query_564378, "api-version", newJString(apiVersion))
  add(path_564377, "skillsetName", newJString(skillsetName))
  result = call_564376.call(path_564377, query_564378, nil, nil, nil)

var skillsetsGet* = Call_SkillsetsGet_564369(name: "skillsetsGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/skillsets(\'{skillsetName}\')", validator: validate_SkillsetsGet_564370,
    base: "", url: url_SkillsetsGet_564371, schemes: {Scheme.Https})
type
  Call_SkillsetsDelete_564392 = ref object of OpenApiRestCall_563566
proc url_SkillsetsDelete_564394(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "skillsetName" in path, "`skillsetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/skillsets(\'"),
               (kind: VariableSegment, value: "skillsetName"),
               (kind: ConstantSegment, value: "\')")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SkillsetsDelete_564393(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a cognitive skillset in an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/delete-skillset
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skillsetName: JString (required)
  ##               : The name of the skillset to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `skillsetName` field"
  var valid_564395 = path.getOrDefault("skillsetName")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "skillsetName", valid_564395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564396 = query.getOrDefault("api-version")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "api-version", valid_564396
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564397 = header.getOrDefault("client-request-id")
  valid_564397 = validateParameter(valid_564397, JString, required = false,
                                 default = nil)
  if valid_564397 != nil:
    section.add "client-request-id", valid_564397
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564398: Call_SkillsetsDelete_564392; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a cognitive skillset in an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/delete-skillset
  let valid = call_564398.validator(path, query, header, formData, body)
  let scheme = call_564398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564398.url(scheme.get, call_564398.host, call_564398.base,
                         call_564398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564398, url, valid)

proc call*(call_564399: Call_SkillsetsDelete_564392; apiVersion: string;
          skillsetName: string): Recallable =
  ## skillsetsDelete
  ## Deletes a cognitive skillset in an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/delete-skillset
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skillsetName: string (required)
  ##               : The name of the skillset to delete.
  var path_564400 = newJObject()
  var query_564401 = newJObject()
  add(query_564401, "api-version", newJString(apiVersion))
  add(path_564400, "skillsetName", newJString(skillsetName))
  result = call_564399.call(path_564400, query_564401, nil, nil, nil)

var skillsetsDelete* = Call_SkillsetsDelete_564392(name: "skillsetsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/skillsets(\'{skillsetName}\')", validator: validate_SkillsetsDelete_564393,
    base: "", url: url_SkillsetsDelete_564394, schemes: {Scheme.Https})
type
  Call_SynonymMapsCreate_564410 = ref object of OpenApiRestCall_563566
proc url_SynonymMapsCreate_564412(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SynonymMapsCreate_564411(path: JsonNode; query: JsonNode;
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
  var valid_564413 = query.getOrDefault("api-version")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "api-version", valid_564413
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564414 = header.getOrDefault("client-request-id")
  valid_564414 = validateParameter(valid_564414, JString, required = false,
                                 default = nil)
  if valid_564414 != nil:
    section.add "client-request-id", valid_564414
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

proc call*(call_564416: Call_SynonymMapsCreate_564410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search synonym map.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Synonym-Map
  let valid = call_564416.validator(path, query, header, formData, body)
  let scheme = call_564416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564416.url(scheme.get, call_564416.host, call_564416.base,
                         call_564416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564416, url, valid)

proc call*(call_564417: Call_SynonymMapsCreate_564410; synonymMap: JsonNode;
          apiVersion: string): Recallable =
  ## synonymMapsCreate
  ## Creates a new Azure Search synonym map.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Synonym-Map
  ##   synonymMap: JObject (required)
  ##             : The definition of the synonym map to create.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564418 = newJObject()
  var body_564419 = newJObject()
  if synonymMap != nil:
    body_564419 = synonymMap
  add(query_564418, "api-version", newJString(apiVersion))
  result = call_564417.call(nil, query_564418, nil, nil, body_564419)

var synonymMapsCreate* = Call_SynonymMapsCreate_564410(name: "synonymMapsCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/synonymmaps",
    validator: validate_SynonymMapsCreate_564411, base: "",
    url: url_SynonymMapsCreate_564412, schemes: {Scheme.Https})
type
  Call_SynonymMapsList_564402 = ref object of OpenApiRestCall_563566
proc url_SynonymMapsList_564404(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SynonymMapsList_564403(path: JsonNode; query: JsonNode;
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
  var valid_564405 = query.getOrDefault("api-version")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "api-version", valid_564405
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564406 = header.getOrDefault("client-request-id")
  valid_564406 = validateParameter(valid_564406, JString, required = false,
                                 default = nil)
  if valid_564406 != nil:
    section.add "client-request-id", valid_564406
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564407: Call_SynonymMapsList_564402; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all synonym maps available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Synonym-Maps
  let valid = call_564407.validator(path, query, header, formData, body)
  let scheme = call_564407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564407.url(scheme.get, call_564407.host, call_564407.base,
                         call_564407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564407, url, valid)

proc call*(call_564408: Call_SynonymMapsList_564402; apiVersion: string): Recallable =
  ## synonymMapsList
  ## Lists all synonym maps available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Synonym-Maps
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564409 = newJObject()
  add(query_564409, "api-version", newJString(apiVersion))
  result = call_564408.call(nil, query_564409, nil, nil, nil)

var synonymMapsList* = Call_SynonymMapsList_564402(name: "synonymMapsList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/synonymmaps",
    validator: validate_SynonymMapsList_564403, base: "", url: url_SynonymMapsList_564404,
    schemes: {Scheme.Https})
type
  Call_SynonymMapsCreateOrUpdate_564430 = ref object of OpenApiRestCall_563566
proc url_SynonymMapsCreateOrUpdate_564432(protocol: Scheme; host: string;
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

proc validate_SynonymMapsCreateOrUpdate_564431(path: JsonNode; query: JsonNode;
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
  var valid_564433 = path.getOrDefault("synonymMapName")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "synonymMapName", valid_564433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564434 = query.getOrDefault("api-version")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "api-version", valid_564434
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
  var valid_564435 = header.getOrDefault("Prefer")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_564435 != nil:
    section.add "Prefer", valid_564435
  var valid_564436 = header.getOrDefault("client-request-id")
  valid_564436 = validateParameter(valid_564436, JString, required = false,
                                 default = nil)
  if valid_564436 != nil:
    section.add "client-request-id", valid_564436
  var valid_564437 = header.getOrDefault("If-None-Match")
  valid_564437 = validateParameter(valid_564437, JString, required = false,
                                 default = nil)
  if valid_564437 != nil:
    section.add "If-None-Match", valid_564437
  var valid_564438 = header.getOrDefault("If-Match")
  valid_564438 = validateParameter(valid_564438, JString, required = false,
                                 default = nil)
  if valid_564438 != nil:
    section.add "If-Match", valid_564438
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

proc call*(call_564440: Call_SynonymMapsCreateOrUpdate_564430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search synonym map or updates a synonym map if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Synonym-Map
  let valid = call_564440.validator(path, query, header, formData, body)
  let scheme = call_564440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564440.url(scheme.get, call_564440.host, call_564440.base,
                         call_564440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564440, url, valid)

proc call*(call_564441: Call_SynonymMapsCreateOrUpdate_564430;
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
  var path_564442 = newJObject()
  var query_564443 = newJObject()
  var body_564444 = newJObject()
  if synonymMap != nil:
    body_564444 = synonymMap
  add(query_564443, "api-version", newJString(apiVersion))
  add(path_564442, "synonymMapName", newJString(synonymMapName))
  result = call_564441.call(path_564442, query_564443, nil, nil, body_564444)

var synonymMapsCreateOrUpdate* = Call_SynonymMapsCreateOrUpdate_564430(
    name: "synonymMapsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/synonymmaps(\'{synonymMapName}\')",
    validator: validate_SynonymMapsCreateOrUpdate_564431, base: "",
    url: url_SynonymMapsCreateOrUpdate_564432, schemes: {Scheme.Https})
type
  Call_SynonymMapsGet_564420 = ref object of OpenApiRestCall_563566
proc url_SynonymMapsGet_564422(protocol: Scheme; host: string; base: string;
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

proc validate_SynonymMapsGet_564421(path: JsonNode; query: JsonNode;
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
  var valid_564423 = path.getOrDefault("synonymMapName")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "synonymMapName", valid_564423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564424 = query.getOrDefault("api-version")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "api-version", valid_564424
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_564425 = header.getOrDefault("client-request-id")
  valid_564425 = validateParameter(valid_564425, JString, required = false,
                                 default = nil)
  if valid_564425 != nil:
    section.add "client-request-id", valid_564425
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564426: Call_SynonymMapsGet_564420; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a synonym map definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Synonym-Map
  let valid = call_564426.validator(path, query, header, formData, body)
  let scheme = call_564426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564426.url(scheme.get, call_564426.host, call_564426.base,
                         call_564426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564426, url, valid)

proc call*(call_564427: Call_SynonymMapsGet_564420; apiVersion: string;
          synonymMapName: string): Recallable =
  ## synonymMapsGet
  ## Retrieves a synonym map definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Synonym-Map
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   synonymMapName: string (required)
  ##                 : The name of the synonym map to retrieve.
  var path_564428 = newJObject()
  var query_564429 = newJObject()
  add(query_564429, "api-version", newJString(apiVersion))
  add(path_564428, "synonymMapName", newJString(synonymMapName))
  result = call_564427.call(path_564428, query_564429, nil, nil, nil)

var synonymMapsGet* = Call_SynonymMapsGet_564420(name: "synonymMapsGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/synonymmaps(\'{synonymMapName}\')",
    validator: validate_SynonymMapsGet_564421, base: "", url: url_SynonymMapsGet_564422,
    schemes: {Scheme.Https})
type
  Call_SynonymMapsDelete_564445 = ref object of OpenApiRestCall_563566
proc url_SynonymMapsDelete_564447(protocol: Scheme; host: string; base: string;
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

proc validate_SynonymMapsDelete_564446(path: JsonNode; query: JsonNode;
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
  var valid_564448 = path.getOrDefault("synonymMapName")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "synonymMapName", valid_564448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564449 = query.getOrDefault("api-version")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "api-version", valid_564449
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  section = newJObject()
  var valid_564450 = header.getOrDefault("client-request-id")
  valid_564450 = validateParameter(valid_564450, JString, required = false,
                                 default = nil)
  if valid_564450 != nil:
    section.add "client-request-id", valid_564450
  var valid_564451 = header.getOrDefault("If-None-Match")
  valid_564451 = validateParameter(valid_564451, JString, required = false,
                                 default = nil)
  if valid_564451 != nil:
    section.add "If-None-Match", valid_564451
  var valid_564452 = header.getOrDefault("If-Match")
  valid_564452 = validateParameter(valid_564452, JString, required = false,
                                 default = nil)
  if valid_564452 != nil:
    section.add "If-Match", valid_564452
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564453: Call_SynonymMapsDelete_564445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search synonym map.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Synonym-Map
  let valid = call_564453.validator(path, query, header, formData, body)
  let scheme = call_564453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564453.url(scheme.get, call_564453.host, call_564453.base,
                         call_564453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564453, url, valid)

proc call*(call_564454: Call_SynonymMapsDelete_564445; apiVersion: string;
          synonymMapName: string): Recallable =
  ## synonymMapsDelete
  ## Deletes an Azure Search synonym map.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Synonym-Map
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   synonymMapName: string (required)
  ##                 : The name of the synonym map to delete.
  var path_564455 = newJObject()
  var query_564456 = newJObject()
  add(query_564456, "api-version", newJString(apiVersion))
  add(path_564455, "synonymMapName", newJString(synonymMapName))
  result = call_564454.call(path_564455, query_564456, nil, nil, nil)

var synonymMapsDelete* = Call_SynonymMapsDelete_564445(name: "synonymMapsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/synonymmaps(\'{synonymMapName}\')",
    validator: validate_SynonymMapsDelete_564446, base: "",
    url: url_SynonymMapsDelete_564447, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
