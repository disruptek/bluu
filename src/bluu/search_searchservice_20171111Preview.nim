
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567668 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567668](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567668): Option[Scheme] {.used.} =
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
  Call_DataSourcesCreate_568187 = ref object of OpenApiRestCall_567668
proc url_DataSourcesCreate_568189(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DataSourcesCreate_568188(path: JsonNode; query: JsonNode;
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
  var valid_568207 = query.getOrDefault("api-version")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "api-version", valid_568207
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568208 = header.getOrDefault("client-request-id")
  valid_568208 = validateParameter(valid_568208, JString, required = false,
                                 default = nil)
  if valid_568208 != nil:
    section.add "client-request-id", valid_568208
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

proc call*(call_568210: Call_DataSourcesCreate_568187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search datasource.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Data-Source
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_DataSourcesCreate_568187; apiVersion: string;
          dataSource: JsonNode): Recallable =
  ## dataSourcesCreate
  ## Creates a new Azure Search datasource.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Data-Source
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSource: JObject (required)
  ##             : The definition of the datasource to create.
  var query_568212 = newJObject()
  var body_568213 = newJObject()
  add(query_568212, "api-version", newJString(apiVersion))
  if dataSource != nil:
    body_568213 = dataSource
  result = call_568211.call(nil, query_568212, nil, nil, body_568213)

var dataSourcesCreate* = Call_DataSourcesCreate_568187(name: "dataSourcesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/datasources",
    validator: validate_DataSourcesCreate_568188, base: "",
    url: url_DataSourcesCreate_568189, schemes: {Scheme.Https})
type
  Call_DataSourcesList_567890 = ref object of OpenApiRestCall_567668
proc url_DataSourcesList_567892(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DataSourcesList_567891(path: JsonNode; query: JsonNode;
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
  var valid_568051 = query.getOrDefault("api-version")
  valid_568051 = validateParameter(valid_568051, JString, required = true,
                                 default = nil)
  if valid_568051 != nil:
    section.add "api-version", valid_568051
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568052 = header.getOrDefault("client-request-id")
  valid_568052 = validateParameter(valid_568052, JString, required = false,
                                 default = nil)
  if valid_568052 != nil:
    section.add "client-request-id", valid_568052
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568075: Call_DataSourcesList_567890; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all datasources available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Data-Sources
  let valid = call_568075.validator(path, query, header, formData, body)
  let scheme = call_568075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568075.url(scheme.get, call_568075.host, call_568075.base,
                         call_568075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568075, url, valid)

proc call*(call_568146: Call_DataSourcesList_567890; apiVersion: string): Recallable =
  ## dataSourcesList
  ## Lists all datasources available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Data-Sources
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568147 = newJObject()
  add(query_568147, "api-version", newJString(apiVersion))
  result = call_568146.call(nil, query_568147, nil, nil, nil)

var dataSourcesList* = Call_DataSourcesList_567890(name: "dataSourcesList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/datasources",
    validator: validate_DataSourcesList_567891, base: "", url: url_DataSourcesList_567892,
    schemes: {Scheme.Https})
type
  Call_DataSourcesCreateOrUpdate_568238 = ref object of OpenApiRestCall_567668
proc url_DataSourcesCreateOrUpdate_568240(protocol: Scheme; host: string;
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

proc validate_DataSourcesCreateOrUpdate_568239(path: JsonNode; query: JsonNode;
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
  var valid_568241 = path.getOrDefault("dataSourceName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "dataSourceName", valid_568241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568242 = query.getOrDefault("api-version")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "api-version", valid_568242
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
  var valid_568243 = header.getOrDefault("If-Match")
  valid_568243 = validateParameter(valid_568243, JString, required = false,
                                 default = nil)
  if valid_568243 != nil:
    section.add "If-Match", valid_568243
  var valid_568244 = header.getOrDefault("client-request-id")
  valid_568244 = validateParameter(valid_568244, JString, required = false,
                                 default = nil)
  if valid_568244 != nil:
    section.add "client-request-id", valid_568244
  var valid_568245 = header.getOrDefault("If-None-Match")
  valid_568245 = validateParameter(valid_568245, JString, required = false,
                                 default = nil)
  if valid_568245 != nil:
    section.add "If-None-Match", valid_568245
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_568259 = header.getOrDefault("Prefer")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_568259 != nil:
    section.add "Prefer", valid_568259
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

proc call*(call_568261: Call_DataSourcesCreateOrUpdate_568238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search datasource or updates a datasource if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Data-Source
  let valid = call_568261.validator(path, query, header, formData, body)
  let scheme = call_568261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568261.url(scheme.get, call_568261.host, call_568261.base,
                         call_568261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568261, url, valid)

proc call*(call_568262: Call_DataSourcesCreateOrUpdate_568238; apiVersion: string;
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
  var path_568263 = newJObject()
  var query_568264 = newJObject()
  var body_568265 = newJObject()
  add(query_568264, "api-version", newJString(apiVersion))
  add(path_568263, "dataSourceName", newJString(dataSourceName))
  if dataSource != nil:
    body_568265 = dataSource
  result = call_568262.call(path_568263, query_568264, nil, nil, body_568265)

var dataSourcesCreateOrUpdate* = Call_DataSourcesCreateOrUpdate_568238(
    name: "dataSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesCreateOrUpdate_568239, base: "",
    url: url_DataSourcesCreateOrUpdate_568240, schemes: {Scheme.Https})
type
  Call_DataSourcesGet_568214 = ref object of OpenApiRestCall_567668
proc url_DataSourcesGet_568216(protocol: Scheme; host: string; base: string;
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

proc validate_DataSourcesGet_568215(path: JsonNode; query: JsonNode;
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
  var valid_568231 = path.getOrDefault("dataSourceName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "dataSourceName", valid_568231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568232 = query.getOrDefault("api-version")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "api-version", valid_568232
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568233 = header.getOrDefault("client-request-id")
  valid_568233 = validateParameter(valid_568233, JString, required = false,
                                 default = nil)
  if valid_568233 != nil:
    section.add "client-request-id", valid_568233
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568234: Call_DataSourcesGet_568214; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a datasource definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Data-Source
  let valid = call_568234.validator(path, query, header, formData, body)
  let scheme = call_568234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568234.url(scheme.get, call_568234.host, call_568234.base,
                         call_568234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568234, url, valid)

proc call*(call_568235: Call_DataSourcesGet_568214; apiVersion: string;
          dataSourceName: string): Recallable =
  ## dataSourcesGet
  ## Retrieves a datasource definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Data-Source
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to retrieve.
  var path_568236 = newJObject()
  var query_568237 = newJObject()
  add(query_568237, "api-version", newJString(apiVersion))
  add(path_568236, "dataSourceName", newJString(dataSourceName))
  result = call_568235.call(path_568236, query_568237, nil, nil, nil)

var dataSourcesGet* = Call_DataSourcesGet_568214(name: "dataSourcesGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesGet_568215, base: "", url: url_DataSourcesGet_568216,
    schemes: {Scheme.Https})
type
  Call_DataSourcesDelete_568266 = ref object of OpenApiRestCall_567668
proc url_DataSourcesDelete_568268(protocol: Scheme; host: string; base: string;
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

proc validate_DataSourcesDelete_568267(path: JsonNode; query: JsonNode;
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
  var valid_568269 = path.getOrDefault("dataSourceName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "dataSourceName", valid_568269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568270 = query.getOrDefault("api-version")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "api-version", valid_568270
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  section = newJObject()
  var valid_568271 = header.getOrDefault("If-Match")
  valid_568271 = validateParameter(valid_568271, JString, required = false,
                                 default = nil)
  if valid_568271 != nil:
    section.add "If-Match", valid_568271
  var valid_568272 = header.getOrDefault("client-request-id")
  valid_568272 = validateParameter(valid_568272, JString, required = false,
                                 default = nil)
  if valid_568272 != nil:
    section.add "client-request-id", valid_568272
  var valid_568273 = header.getOrDefault("If-None-Match")
  valid_568273 = validateParameter(valid_568273, JString, required = false,
                                 default = nil)
  if valid_568273 != nil:
    section.add "If-None-Match", valid_568273
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568274: Call_DataSourcesDelete_568266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search datasource.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Data-Source
  let valid = call_568274.validator(path, query, header, formData, body)
  let scheme = call_568274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568274.url(scheme.get, call_568274.host, call_568274.base,
                         call_568274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568274, url, valid)

proc call*(call_568275: Call_DataSourcesDelete_568266; apiVersion: string;
          dataSourceName: string): Recallable =
  ## dataSourcesDelete
  ## Deletes an Azure Search datasource.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Data-Source
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to delete.
  var path_568276 = newJObject()
  var query_568277 = newJObject()
  add(query_568277, "api-version", newJString(apiVersion))
  add(path_568276, "dataSourceName", newJString(dataSourceName))
  result = call_568275.call(path_568276, query_568277, nil, nil, nil)

var dataSourcesDelete* = Call_DataSourcesDelete_568266(name: "dataSourcesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesDelete_568267, base: "",
    url: url_DataSourcesDelete_568268, schemes: {Scheme.Https})
type
  Call_IndexersCreate_568286 = ref object of OpenApiRestCall_567668
proc url_IndexersCreate_568288(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexersCreate_568287(path: JsonNode; query: JsonNode;
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
  var valid_568289 = query.getOrDefault("api-version")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "api-version", valid_568289
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568290 = header.getOrDefault("client-request-id")
  valid_568290 = validateParameter(valid_568290, JString, required = false,
                                 default = nil)
  if valid_568290 != nil:
    section.add "client-request-id", valid_568290
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

proc call*(call_568292: Call_IndexersCreate_568286; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  let valid = call_568292.validator(path, query, header, formData, body)
  let scheme = call_568292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568292.url(scheme.get, call_568292.host, call_568292.base,
                         call_568292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568292, url, valid)

proc call*(call_568293: Call_IndexersCreate_568286; apiVersion: string;
          indexer: JsonNode): Recallable =
  ## indexersCreate
  ## Creates a new Azure Search indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexer: JObject (required)
  ##          : The definition of the indexer to create.
  var query_568294 = newJObject()
  var body_568295 = newJObject()
  add(query_568294, "api-version", newJString(apiVersion))
  if indexer != nil:
    body_568295 = indexer
  result = call_568293.call(nil, query_568294, nil, nil, body_568295)

var indexersCreate* = Call_IndexersCreate_568286(name: "indexersCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/indexers",
    validator: validate_IndexersCreate_568287, base: "", url: url_IndexersCreate_568288,
    schemes: {Scheme.Https})
type
  Call_IndexersList_568278 = ref object of OpenApiRestCall_567668
proc url_IndexersList_568280(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexersList_568279(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568281 = query.getOrDefault("api-version")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "api-version", valid_568281
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568282 = header.getOrDefault("client-request-id")
  valid_568282 = validateParameter(valid_568282, JString, required = false,
                                 default = nil)
  if valid_568282 != nil:
    section.add "client-request-id", valid_568282
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568283: Call_IndexersList_568278; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all indexers available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexers
  let valid = call_568283.validator(path, query, header, formData, body)
  let scheme = call_568283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568283.url(scheme.get, call_568283.host, call_568283.base,
                         call_568283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568283, url, valid)

proc call*(call_568284: Call_IndexersList_568278; apiVersion: string): Recallable =
  ## indexersList
  ## Lists all indexers available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexers
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568285 = newJObject()
  add(query_568285, "api-version", newJString(apiVersion))
  result = call_568284.call(nil, query_568285, nil, nil, nil)

var indexersList* = Call_IndexersList_568278(name: "indexersList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/indexers",
    validator: validate_IndexersList_568279, base: "", url: url_IndexersList_568280,
    schemes: {Scheme.Https})
type
  Call_IndexersCreateOrUpdate_568306 = ref object of OpenApiRestCall_567668
proc url_IndexersCreateOrUpdate_568308(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersCreateOrUpdate_568307(path: JsonNode; query: JsonNode;
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
  var valid_568309 = path.getOrDefault("indexerName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "indexerName", valid_568309
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568310 = query.getOrDefault("api-version")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "api-version", valid_568310
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
  var valid_568311 = header.getOrDefault("If-Match")
  valid_568311 = validateParameter(valid_568311, JString, required = false,
                                 default = nil)
  if valid_568311 != nil:
    section.add "If-Match", valid_568311
  var valid_568312 = header.getOrDefault("client-request-id")
  valid_568312 = validateParameter(valid_568312, JString, required = false,
                                 default = nil)
  if valid_568312 != nil:
    section.add "client-request-id", valid_568312
  var valid_568313 = header.getOrDefault("If-None-Match")
  valid_568313 = validateParameter(valid_568313, JString, required = false,
                                 default = nil)
  if valid_568313 != nil:
    section.add "If-None-Match", valid_568313
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_568314 = header.getOrDefault("Prefer")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_568314 != nil:
    section.add "Prefer", valid_568314
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

proc call*(call_568316: Call_IndexersCreateOrUpdate_568306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search indexer or updates an indexer if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  let valid = call_568316.validator(path, query, header, formData, body)
  let scheme = call_568316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568316.url(scheme.get, call_568316.host, call_568316.base,
                         call_568316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568316, url, valid)

proc call*(call_568317: Call_IndexersCreateOrUpdate_568306; apiVersion: string;
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
  var path_568318 = newJObject()
  var query_568319 = newJObject()
  var body_568320 = newJObject()
  add(query_568319, "api-version", newJString(apiVersion))
  add(path_568318, "indexerName", newJString(indexerName))
  if indexer != nil:
    body_568320 = indexer
  result = call_568317.call(path_568318, query_568319, nil, nil, body_568320)

var indexersCreateOrUpdate* = Call_IndexersCreateOrUpdate_568306(
    name: "indexersCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/indexers(\'{indexerName}\')",
    validator: validate_IndexersCreateOrUpdate_568307, base: "",
    url: url_IndexersCreateOrUpdate_568308, schemes: {Scheme.Https})
type
  Call_IndexersGet_568296 = ref object of OpenApiRestCall_567668
proc url_IndexersGet_568298(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersGet_568297(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568299 = path.getOrDefault("indexerName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "indexerName", valid_568299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568300 = query.getOrDefault("api-version")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "api-version", valid_568300
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568301 = header.getOrDefault("client-request-id")
  valid_568301 = validateParameter(valid_568301, JString, required = false,
                                 default = nil)
  if valid_568301 != nil:
    section.add "client-request-id", valid_568301
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568302: Call_IndexersGet_568296; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an indexer definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer
  let valid = call_568302.validator(path, query, header, formData, body)
  let scheme = call_568302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568302.url(scheme.get, call_568302.host, call_568302.base,
                         call_568302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568302, url, valid)

proc call*(call_568303: Call_IndexersGet_568296; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersGet
  ## Retrieves an indexer definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to retrieve.
  var path_568304 = newJObject()
  var query_568305 = newJObject()
  add(query_568305, "api-version", newJString(apiVersion))
  add(path_568304, "indexerName", newJString(indexerName))
  result = call_568303.call(path_568304, query_568305, nil, nil, nil)

var indexersGet* = Call_IndexersGet_568296(name: "indexersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local",
                                        route: "/indexers(\'{indexerName}\')",
                                        validator: validate_IndexersGet_568297,
                                        base: "", url: url_IndexersGet_568298,
                                        schemes: {Scheme.Https})
type
  Call_IndexersDelete_568321 = ref object of OpenApiRestCall_567668
proc url_IndexersDelete_568323(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersDelete_568322(path: JsonNode; query: JsonNode;
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
  var valid_568324 = path.getOrDefault("indexerName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "indexerName", valid_568324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568325 = query.getOrDefault("api-version")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "api-version", valid_568325
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  section = newJObject()
  var valid_568326 = header.getOrDefault("If-Match")
  valid_568326 = validateParameter(valid_568326, JString, required = false,
                                 default = nil)
  if valid_568326 != nil:
    section.add "If-Match", valid_568326
  var valid_568327 = header.getOrDefault("client-request-id")
  valid_568327 = validateParameter(valid_568327, JString, required = false,
                                 default = nil)
  if valid_568327 != nil:
    section.add "client-request-id", valid_568327
  var valid_568328 = header.getOrDefault("If-None-Match")
  valid_568328 = validateParameter(valid_568328, JString, required = false,
                                 default = nil)
  if valid_568328 != nil:
    section.add "If-None-Match", valid_568328
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568329: Call_IndexersDelete_568321; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Indexer
  let valid = call_568329.validator(path, query, header, formData, body)
  let scheme = call_568329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568329.url(scheme.get, call_568329.host, call_568329.base,
                         call_568329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568329, url, valid)

proc call*(call_568330: Call_IndexersDelete_568321; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersDelete
  ## Deletes an Azure Search indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to delete.
  var path_568331 = newJObject()
  var query_568332 = newJObject()
  add(query_568332, "api-version", newJString(apiVersion))
  add(path_568331, "indexerName", newJString(indexerName))
  result = call_568330.call(path_568331, query_568332, nil, nil, nil)

var indexersDelete* = Call_IndexersDelete_568321(name: "indexersDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/indexers(\'{indexerName}\')", validator: validate_IndexersDelete_568322,
    base: "", url: url_IndexersDelete_568323, schemes: {Scheme.Https})
type
  Call_IndexersReset_568333 = ref object of OpenApiRestCall_567668
proc url_IndexersReset_568335(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersReset_568334(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568336 = path.getOrDefault("indexerName")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "indexerName", valid_568336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568337 = query.getOrDefault("api-version")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "api-version", valid_568337
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568338 = header.getOrDefault("client-request-id")
  valid_568338 = validateParameter(valid_568338, JString, required = false,
                                 default = nil)
  if valid_568338 != nil:
    section.add "client-request-id", valid_568338
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568339: Call_IndexersReset_568333; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the change tracking state associated with an Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Reset-Indexer
  let valid = call_568339.validator(path, query, header, formData, body)
  let scheme = call_568339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568339.url(scheme.get, call_568339.host, call_568339.base,
                         call_568339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568339, url, valid)

proc call*(call_568340: Call_IndexersReset_568333; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersReset
  ## Resets the change tracking state associated with an Azure Search indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Reset-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to reset.
  var path_568341 = newJObject()
  var query_568342 = newJObject()
  add(query_568342, "api-version", newJString(apiVersion))
  add(path_568341, "indexerName", newJString(indexerName))
  result = call_568340.call(path_568341, query_568342, nil, nil, nil)

var indexersReset* = Call_IndexersReset_568333(name: "indexersReset",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/indexers(\'{indexerName}\')/search.reset",
    validator: validate_IndexersReset_568334, base: "", url: url_IndexersReset_568335,
    schemes: {Scheme.Https})
type
  Call_IndexersRun_568343 = ref object of OpenApiRestCall_567668
proc url_IndexersRun_568345(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersRun_568344(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568346 = path.getOrDefault("indexerName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "indexerName", valid_568346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568347 = query.getOrDefault("api-version")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "api-version", valid_568347
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568348 = header.getOrDefault("client-request-id")
  valid_568348 = validateParameter(valid_568348, JString, required = false,
                                 default = nil)
  if valid_568348 != nil:
    section.add "client-request-id", valid_568348
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568349: Call_IndexersRun_568343; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs an Azure Search indexer on-demand.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Run-Indexer
  let valid = call_568349.validator(path, query, header, formData, body)
  let scheme = call_568349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568349.url(scheme.get, call_568349.host, call_568349.base,
                         call_568349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568349, url, valid)

proc call*(call_568350: Call_IndexersRun_568343; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersRun
  ## Runs an Azure Search indexer on-demand.
  ## https://docs.microsoft.com/rest/api/searchservice/Run-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to run.
  var path_568351 = newJObject()
  var query_568352 = newJObject()
  add(query_568352, "api-version", newJString(apiVersion))
  add(path_568351, "indexerName", newJString(indexerName))
  result = call_568350.call(path_568351, query_568352, nil, nil, nil)

var indexersRun* = Call_IndexersRun_568343(name: "indexersRun",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local", route: "/indexers(\'{indexerName}\')/search.run",
                                        validator: validate_IndexersRun_568344,
                                        base: "", url: url_IndexersRun_568345,
                                        schemes: {Scheme.Https})
type
  Call_IndexersGetStatus_568353 = ref object of OpenApiRestCall_567668
proc url_IndexersGetStatus_568355(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersGetStatus_568354(path: JsonNode; query: JsonNode;
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
  var valid_568356 = path.getOrDefault("indexerName")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "indexerName", valid_568356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568357 = query.getOrDefault("api-version")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "api-version", valid_568357
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568358 = header.getOrDefault("client-request-id")
  valid_568358 = validateParameter(valid_568358, JString, required = false,
                                 default = nil)
  if valid_568358 != nil:
    section.add "client-request-id", valid_568358
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568359: Call_IndexersGetStatus_568353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the current status and execution history of an indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer-Status
  let valid = call_568359.validator(path, query, header, formData, body)
  let scheme = call_568359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568359.url(scheme.get, call_568359.host, call_568359.base,
                         call_568359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568359, url, valid)

proc call*(call_568360: Call_IndexersGetStatus_568353; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersGetStatus
  ## Returns the current status and execution history of an indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer-Status
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer for which to retrieve status.
  var path_568361 = newJObject()
  var query_568362 = newJObject()
  add(query_568362, "api-version", newJString(apiVersion))
  add(path_568361, "indexerName", newJString(indexerName))
  result = call_568360.call(path_568361, query_568362, nil, nil, nil)

var indexersGetStatus* = Call_IndexersGetStatus_568353(name: "indexersGetStatus",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/indexers(\'{indexerName}\')/search.status",
    validator: validate_IndexersGetStatus_568354, base: "",
    url: url_IndexersGetStatus_568355, schemes: {Scheme.Https})
type
  Call_IndexesCreate_568373 = ref object of OpenApiRestCall_567668
proc url_IndexesCreate_568375(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexesCreate_568374(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568376 = query.getOrDefault("api-version")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "api-version", valid_568376
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568377 = header.getOrDefault("client-request-id")
  valid_568377 = validateParameter(valid_568377, JString, required = false,
                                 default = nil)
  if valid_568377 != nil:
    section.add "client-request-id", valid_568377
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

proc call*(call_568379: Call_IndexesCreate_568373; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Index
  let valid = call_568379.validator(path, query, header, formData, body)
  let scheme = call_568379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568379.url(scheme.get, call_568379.host, call_568379.base,
                         call_568379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568379, url, valid)

proc call*(call_568380: Call_IndexesCreate_568373; apiVersion: string;
          index: JsonNode): Recallable =
  ## indexesCreate
  ## Creates a new Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Index
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   index: JObject (required)
  ##        : The definition of the index to create.
  var query_568381 = newJObject()
  var body_568382 = newJObject()
  add(query_568381, "api-version", newJString(apiVersion))
  if index != nil:
    body_568382 = index
  result = call_568380.call(nil, query_568381, nil, nil, body_568382)

var indexesCreate* = Call_IndexesCreate_568373(name: "indexesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/indexes",
    validator: validate_IndexesCreate_568374, base: "", url: url_IndexesCreate_568375,
    schemes: {Scheme.Https})
type
  Call_IndexesList_568363 = ref object of OpenApiRestCall_567668
proc url_IndexesList_568365(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexesList_568364(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568367 = query.getOrDefault("api-version")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "api-version", valid_568367
  var valid_568368 = query.getOrDefault("$select")
  valid_568368 = validateParameter(valid_568368, JString, required = false,
                                 default = nil)
  if valid_568368 != nil:
    section.add "$select", valid_568368
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568369 = header.getOrDefault("client-request-id")
  valid_568369 = validateParameter(valid_568369, JString, required = false,
                                 default = nil)
  if valid_568369 != nil:
    section.add "client-request-id", valid_568369
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568370: Call_IndexesList_568363; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all indexes available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexes
  let valid = call_568370.validator(path, query, header, formData, body)
  let scheme = call_568370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568370.url(scheme.get, call_568370.host, call_568370.base,
                         call_568370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568370, url, valid)

proc call*(call_568371: Call_IndexesList_568363; apiVersion: string;
          Select: string = ""): Recallable =
  ## indexesList
  ## Lists all indexes available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexes
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : Selects which properties of the index definitions to retrieve. Specified as a comma-separated list of JSON property names, or '*' for all properties. The default is all properties.
  var query_568372 = newJObject()
  add(query_568372, "api-version", newJString(apiVersion))
  add(query_568372, "$select", newJString(Select))
  result = call_568371.call(nil, query_568372, nil, nil, nil)

var indexesList* = Call_IndexesList_568363(name: "indexesList",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/indexes",
                                        validator: validate_IndexesList_568364,
                                        base: "", url: url_IndexesList_568365,
                                        schemes: {Scheme.Https})
type
  Call_IndexesCreateOrUpdate_568393 = ref object of OpenApiRestCall_567668
proc url_IndexesCreateOrUpdate_568395(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesCreateOrUpdate_568394(path: JsonNode; query: JsonNode;
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
  var valid_568396 = path.getOrDefault("indexName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "indexName", valid_568396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   allowIndexDowntime: JBool
  ##                     : Allows new analyzers, tokenizers, token filters, or char filters to be added to an index by taking the index offline for at least a few seconds. This temporarily causes indexing and query requests to fail. Performance and write availability of the index can be impaired for several minutes after the index is updated, or longer for very large indexes.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568397 = query.getOrDefault("api-version")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "api-version", valid_568397
  var valid_568398 = query.getOrDefault("allowIndexDowntime")
  valid_568398 = validateParameter(valid_568398, JBool, required = false, default = nil)
  if valid_568398 != nil:
    section.add "allowIndexDowntime", valid_568398
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
  var valid_568399 = header.getOrDefault("If-Match")
  valid_568399 = validateParameter(valid_568399, JString, required = false,
                                 default = nil)
  if valid_568399 != nil:
    section.add "If-Match", valid_568399
  var valid_568400 = header.getOrDefault("client-request-id")
  valid_568400 = validateParameter(valid_568400, JString, required = false,
                                 default = nil)
  if valid_568400 != nil:
    section.add "client-request-id", valid_568400
  var valid_568401 = header.getOrDefault("If-None-Match")
  valid_568401 = validateParameter(valid_568401, JString, required = false,
                                 default = nil)
  if valid_568401 != nil:
    section.add "If-None-Match", valid_568401
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_568402 = header.getOrDefault("Prefer")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_568402 != nil:
    section.add "Prefer", valid_568402
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

proc call*(call_568404: Call_IndexesCreateOrUpdate_568393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search index or updates an index if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Index
  let valid = call_568404.validator(path, query, header, formData, body)
  let scheme = call_568404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568404.url(scheme.get, call_568404.host, call_568404.base,
                         call_568404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568404, url, valid)

proc call*(call_568405: Call_IndexesCreateOrUpdate_568393; indexName: string;
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
  var path_568406 = newJObject()
  var query_568407 = newJObject()
  var body_568408 = newJObject()
  add(path_568406, "indexName", newJString(indexName))
  add(query_568407, "api-version", newJString(apiVersion))
  if index != nil:
    body_568408 = index
  add(query_568407, "allowIndexDowntime", newJBool(allowIndexDowntime))
  result = call_568405.call(path_568406, query_568407, nil, nil, body_568408)

var indexesCreateOrUpdate* = Call_IndexesCreateOrUpdate_568393(
    name: "indexesCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/indexes(\'{indexName}\')", validator: validate_IndexesCreateOrUpdate_568394,
    base: "", url: url_IndexesCreateOrUpdate_568395, schemes: {Scheme.Https})
type
  Call_IndexesGet_568383 = ref object of OpenApiRestCall_567668
proc url_IndexesGet_568385(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_IndexesGet_568384(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568386 = path.getOrDefault("indexName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "indexName", valid_568386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568387 = query.getOrDefault("api-version")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "api-version", valid_568387
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568388 = header.getOrDefault("client-request-id")
  valid_568388 = validateParameter(valid_568388, JString, required = false,
                                 default = nil)
  if valid_568388 != nil:
    section.add "client-request-id", valid_568388
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568389: Call_IndexesGet_568383; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an index definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index
  let valid = call_568389.validator(path, query, header, formData, body)
  let scheme = call_568389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568389.url(scheme.get, call_568389.host, call_568389.base,
                         call_568389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568389, url, valid)

proc call*(call_568390: Call_IndexesGet_568383; indexName: string; apiVersion: string): Recallable =
  ## indexesGet
  ## Retrieves an index definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index
  ##   indexName: string (required)
  ##            : The name of the index to retrieve.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_568391 = newJObject()
  var query_568392 = newJObject()
  add(path_568391, "indexName", newJString(indexName))
  add(query_568392, "api-version", newJString(apiVersion))
  result = call_568390.call(path_568391, query_568392, nil, nil, nil)

var indexesGet* = Call_IndexesGet_568383(name: "indexesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local",
                                      route: "/indexes(\'{indexName}\')",
                                      validator: validate_IndexesGet_568384,
                                      base: "", url: url_IndexesGet_568385,
                                      schemes: {Scheme.Https})
type
  Call_IndexesDelete_568409 = ref object of OpenApiRestCall_567668
proc url_IndexesDelete_568411(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesDelete_568410(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568412 = path.getOrDefault("indexName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "indexName", valid_568412
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568413 = query.getOrDefault("api-version")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "api-version", valid_568413
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  section = newJObject()
  var valid_568414 = header.getOrDefault("If-Match")
  valid_568414 = validateParameter(valid_568414, JString, required = false,
                                 default = nil)
  if valid_568414 != nil:
    section.add "If-Match", valid_568414
  var valid_568415 = header.getOrDefault("client-request-id")
  valid_568415 = validateParameter(valid_568415, JString, required = false,
                                 default = nil)
  if valid_568415 != nil:
    section.add "client-request-id", valid_568415
  var valid_568416 = header.getOrDefault("If-None-Match")
  valid_568416 = validateParameter(valid_568416, JString, required = false,
                                 default = nil)
  if valid_568416 != nil:
    section.add "If-None-Match", valid_568416
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568417: Call_IndexesDelete_568409; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search index and all the documents it contains.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Index
  let valid = call_568417.validator(path, query, header, formData, body)
  let scheme = call_568417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568417.url(scheme.get, call_568417.host, call_568417.base,
                         call_568417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568417, url, valid)

proc call*(call_568418: Call_IndexesDelete_568409; indexName: string;
          apiVersion: string): Recallable =
  ## indexesDelete
  ## Deletes an Azure Search index and all the documents it contains.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Index
  ##   indexName: string (required)
  ##            : The name of the index to delete.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_568419 = newJObject()
  var query_568420 = newJObject()
  add(path_568419, "indexName", newJString(indexName))
  add(query_568420, "api-version", newJString(apiVersion))
  result = call_568418.call(path_568419, query_568420, nil, nil, nil)

var indexesDelete* = Call_IndexesDelete_568409(name: "indexesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/indexes(\'{indexName}\')", validator: validate_IndexesDelete_568410,
    base: "", url: url_IndexesDelete_568411, schemes: {Scheme.Https})
type
  Call_IndexesAnalyze_568421 = ref object of OpenApiRestCall_567668
proc url_IndexesAnalyze_568423(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesAnalyze_568422(path: JsonNode; query: JsonNode;
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
  var valid_568424 = path.getOrDefault("indexName")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "indexName", valid_568424
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568425 = query.getOrDefault("api-version")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "api-version", valid_568425
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568426 = header.getOrDefault("client-request-id")
  valid_568426 = validateParameter(valid_568426, JString, required = false,
                                 default = nil)
  if valid_568426 != nil:
    section.add "client-request-id", valid_568426
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

proc call*(call_568428: Call_IndexesAnalyze_568421; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shows how an analyzer breaks text into tokens.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/test-analyzer
  let valid = call_568428.validator(path, query, header, formData, body)
  let scheme = call_568428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568428.url(scheme.get, call_568428.host, call_568428.base,
                         call_568428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568428, url, valid)

proc call*(call_568429: Call_IndexesAnalyze_568421; indexName: string;
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
  var path_568430 = newJObject()
  var query_568431 = newJObject()
  var body_568432 = newJObject()
  add(path_568430, "indexName", newJString(indexName))
  add(query_568431, "api-version", newJString(apiVersion))
  if request != nil:
    body_568432 = request
  result = call_568429.call(path_568430, query_568431, nil, nil, body_568432)

var indexesAnalyze* = Call_IndexesAnalyze_568421(name: "indexesAnalyze",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/indexes(\'{indexName}\')/search.analyze",
    validator: validate_IndexesAnalyze_568422, base: "", url: url_IndexesAnalyze_568423,
    schemes: {Scheme.Https})
type
  Call_IndexesGetStatistics_568433 = ref object of OpenApiRestCall_567668
proc url_IndexesGetStatistics_568435(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesGetStatistics_568434(path: JsonNode; query: JsonNode;
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
  var valid_568436 = path.getOrDefault("indexName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "indexName", valid_568436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568437 = query.getOrDefault("api-version")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "api-version", valid_568437
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568438 = header.getOrDefault("client-request-id")
  valid_568438 = validateParameter(valid_568438, JString, required = false,
                                 default = nil)
  if valid_568438 != nil:
    section.add "client-request-id", valid_568438
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568439: Call_IndexesGetStatistics_568433; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns statistics for the given index, including a document count and storage usage.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index-Statistics
  let valid = call_568439.validator(path, query, header, formData, body)
  let scheme = call_568439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568439.url(scheme.get, call_568439.host, call_568439.base,
                         call_568439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568439, url, valid)

proc call*(call_568440: Call_IndexesGetStatistics_568433; indexName: string;
          apiVersion: string): Recallable =
  ## indexesGetStatistics
  ## Returns statistics for the given index, including a document count and storage usage.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index-Statistics
  ##   indexName: string (required)
  ##            : The name of the index for which to retrieve statistics.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_568441 = newJObject()
  var query_568442 = newJObject()
  add(path_568441, "indexName", newJString(indexName))
  add(query_568442, "api-version", newJString(apiVersion))
  result = call_568440.call(path_568441, query_568442, nil, nil, nil)

var indexesGetStatistics* = Call_IndexesGetStatistics_568433(
    name: "indexesGetStatistics", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/indexes(\'{indexName}\')/search.stats",
    validator: validate_IndexesGetStatistics_568434, base: "",
    url: url_IndexesGetStatistics_568435, schemes: {Scheme.Https})
type
  Call_GetServiceStatistics_568443 = ref object of OpenApiRestCall_567668
proc url_GetServiceStatistics_568445(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetServiceStatistics_568444(path: JsonNode; query: JsonNode;
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
  var valid_568446 = query.getOrDefault("api-version")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "api-version", valid_568446
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568447 = header.getOrDefault("client-request-id")
  valid_568447 = validateParameter(valid_568447, JString, required = false,
                                 default = nil)
  if valid_568447 != nil:
    section.add "client-request-id", valid_568447
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568448: Call_GetServiceStatistics_568443; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets service level statistics for an Azure Search service.
  ## 
  let valid = call_568448.validator(path, query, header, formData, body)
  let scheme = call_568448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568448.url(scheme.get, call_568448.host, call_568448.base,
                         call_568448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568448, url, valid)

proc call*(call_568449: Call_GetServiceStatistics_568443; apiVersion: string): Recallable =
  ## getServiceStatistics
  ## Gets service level statistics for an Azure Search service.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568450 = newJObject()
  add(query_568450, "api-version", newJString(apiVersion))
  result = call_568449.call(nil, query_568450, nil, nil, nil)

var getServiceStatistics* = Call_GetServiceStatistics_568443(
    name: "getServiceStatistics", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/servicestats", validator: validate_GetServiceStatistics_568444,
    base: "", url: url_GetServiceStatistics_568445, schemes: {Scheme.Https})
type
  Call_SkillsetsCreate_568459 = ref object of OpenApiRestCall_567668
proc url_SkillsetsCreate_568461(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SkillsetsCreate_568460(path: JsonNode; query: JsonNode;
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
  var valid_568462 = query.getOrDefault("api-version")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "api-version", valid_568462
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568463 = header.getOrDefault("client-request-id")
  valid_568463 = validateParameter(valid_568463, JString, required = false,
                                 default = nil)
  if valid_568463 != nil:
    section.add "client-request-id", valid_568463
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

proc call*(call_568465: Call_SkillsetsCreate_568459; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new cognitive skillset in an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/create-skillset
  let valid = call_568465.validator(path, query, header, formData, body)
  let scheme = call_568465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568465.url(scheme.get, call_568465.host, call_568465.base,
                         call_568465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568465, url, valid)

proc call*(call_568466: Call_SkillsetsCreate_568459; apiVersion: string;
          skillset: JsonNode): Recallable =
  ## skillsetsCreate
  ## Creates a new cognitive skillset in an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/create-skillset
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skillset: JObject (required)
  ##           : The skillset containing one or more cognitive skills to create in an Azure Search service.
  var query_568467 = newJObject()
  var body_568468 = newJObject()
  add(query_568467, "api-version", newJString(apiVersion))
  if skillset != nil:
    body_568468 = skillset
  result = call_568466.call(nil, query_568467, nil, nil, body_568468)

var skillsetsCreate* = Call_SkillsetsCreate_568459(name: "skillsetsCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/skillsets",
    validator: validate_SkillsetsCreate_568460, base: "", url: url_SkillsetsCreate_568461,
    schemes: {Scheme.Https})
type
  Call_SkillsetsList_568451 = ref object of OpenApiRestCall_567668
proc url_SkillsetsList_568453(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SkillsetsList_568452(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568454 = query.getOrDefault("api-version")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "api-version", valid_568454
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568455 = header.getOrDefault("client-request-id")
  valid_568455 = validateParameter(valid_568455, JString, required = false,
                                 default = nil)
  if valid_568455 != nil:
    section.add "client-request-id", valid_568455
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568456: Call_SkillsetsList_568451; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all cognitive skillsets in an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/list-skillset
  let valid = call_568456.validator(path, query, header, formData, body)
  let scheme = call_568456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568456.url(scheme.get, call_568456.host, call_568456.base,
                         call_568456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568456, url, valid)

proc call*(call_568457: Call_SkillsetsList_568451; apiVersion: string): Recallable =
  ## skillsetsList
  ## List all cognitive skillsets in an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/list-skillset
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568458 = newJObject()
  add(query_568458, "api-version", newJString(apiVersion))
  result = call_568457.call(nil, query_568458, nil, nil, nil)

var skillsetsList* = Call_SkillsetsList_568451(name: "skillsetsList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/skillsets",
    validator: validate_SkillsetsList_568452, base: "", url: url_SkillsetsList_568453,
    schemes: {Scheme.Https})
type
  Call_SkillsetsCreateOrUpdate_568479 = ref object of OpenApiRestCall_567668
proc url_SkillsetsCreateOrUpdate_568481(protocol: Scheme; host: string; base: string;
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

proc validate_SkillsetsCreateOrUpdate_568480(path: JsonNode; query: JsonNode;
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
  var valid_568482 = path.getOrDefault("skillsetName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "skillsetName", valid_568482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568483 = query.getOrDefault("api-version")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "api-version", valid_568483
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   Prefer: JString (required)
  ##         : For HTTP PUT requests, instructs the service to return the created/updated resource on success.
  section = newJObject()
  var valid_568484 = header.getOrDefault("client-request-id")
  valid_568484 = validateParameter(valid_568484, JString, required = false,
                                 default = nil)
  if valid_568484 != nil:
    section.add "client-request-id", valid_568484
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_568485 = header.getOrDefault("Prefer")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_568485 != nil:
    section.add "Prefer", valid_568485
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

proc call*(call_568487: Call_SkillsetsCreateOrUpdate_568479; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new cognitive skillset in an Azure Search service or updates the skillset if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/update-skillset
  let valid = call_568487.validator(path, query, header, formData, body)
  let scheme = call_568487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568487.url(scheme.get, call_568487.host, call_568487.base,
                         call_568487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568487, url, valid)

proc call*(call_568488: Call_SkillsetsCreateOrUpdate_568479; apiVersion: string;
          skillsetName: string; skillset: JsonNode): Recallable =
  ## skillsetsCreateOrUpdate
  ## Creates a new cognitive skillset in an Azure Search service or updates the skillset if it already exists.
  ## https://docs.microsoft.com/rest/api/searchservice/update-skillset
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skillsetName: string (required)
  ##               : The name of the skillset to create or update.
  ##   skillset: JObject (required)
  ##           : The skillset containing one or more cognitive skills to create or update in an Azure Search service.
  var path_568489 = newJObject()
  var query_568490 = newJObject()
  var body_568491 = newJObject()
  add(query_568490, "api-version", newJString(apiVersion))
  add(path_568489, "skillsetName", newJString(skillsetName))
  if skillset != nil:
    body_568491 = skillset
  result = call_568488.call(path_568489, query_568490, nil, nil, body_568491)

var skillsetsCreateOrUpdate* = Call_SkillsetsCreateOrUpdate_568479(
    name: "skillsetsCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/skillsets(\'{skillsetName}\')",
    validator: validate_SkillsetsCreateOrUpdate_568480, base: "",
    url: url_SkillsetsCreateOrUpdate_568481, schemes: {Scheme.Https})
type
  Call_SkillsetsGet_568469 = ref object of OpenApiRestCall_567668
proc url_SkillsetsGet_568471(protocol: Scheme; host: string; base: string;
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

proc validate_SkillsetsGet_568470(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568472 = path.getOrDefault("skillsetName")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "skillsetName", valid_568472
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568473 = query.getOrDefault("api-version")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "api-version", valid_568473
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568474 = header.getOrDefault("client-request-id")
  valid_568474 = validateParameter(valid_568474, JString, required = false,
                                 default = nil)
  if valid_568474 != nil:
    section.add "client-request-id", valid_568474
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568475: Call_SkillsetsGet_568469; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a cognitive skillset in an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/get-skillset
  let valid = call_568475.validator(path, query, header, formData, body)
  let scheme = call_568475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568475.url(scheme.get, call_568475.host, call_568475.base,
                         call_568475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568475, url, valid)

proc call*(call_568476: Call_SkillsetsGet_568469; apiVersion: string;
          skillsetName: string): Recallable =
  ## skillsetsGet
  ## Retrieves a cognitive skillset in an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/get-skillset
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skillsetName: string (required)
  ##               : The name of the skillset to retrieve.
  var path_568477 = newJObject()
  var query_568478 = newJObject()
  add(query_568478, "api-version", newJString(apiVersion))
  add(path_568477, "skillsetName", newJString(skillsetName))
  result = call_568476.call(path_568477, query_568478, nil, nil, nil)

var skillsetsGet* = Call_SkillsetsGet_568469(name: "skillsetsGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/skillsets(\'{skillsetName}\')", validator: validate_SkillsetsGet_568470,
    base: "", url: url_SkillsetsGet_568471, schemes: {Scheme.Https})
type
  Call_SkillsetsDelete_568492 = ref object of OpenApiRestCall_567668
proc url_SkillsetsDelete_568494(protocol: Scheme; host: string; base: string;
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

proc validate_SkillsetsDelete_568493(path: JsonNode; query: JsonNode;
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
  var valid_568495 = path.getOrDefault("skillsetName")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "skillsetName", valid_568495
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568496 = query.getOrDefault("api-version")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "api-version", valid_568496
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568497 = header.getOrDefault("client-request-id")
  valid_568497 = validateParameter(valid_568497, JString, required = false,
                                 default = nil)
  if valid_568497 != nil:
    section.add "client-request-id", valid_568497
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568498: Call_SkillsetsDelete_568492; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a cognitive skillset in an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/delete-skillset
  let valid = call_568498.validator(path, query, header, formData, body)
  let scheme = call_568498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568498.url(scheme.get, call_568498.host, call_568498.base,
                         call_568498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568498, url, valid)

proc call*(call_568499: Call_SkillsetsDelete_568492; apiVersion: string;
          skillsetName: string): Recallable =
  ## skillsetsDelete
  ## Deletes a cognitive skillset in an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/delete-skillset
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skillsetName: string (required)
  ##               : The name of the skillset to delete.
  var path_568500 = newJObject()
  var query_568501 = newJObject()
  add(query_568501, "api-version", newJString(apiVersion))
  add(path_568500, "skillsetName", newJString(skillsetName))
  result = call_568499.call(path_568500, query_568501, nil, nil, nil)

var skillsetsDelete* = Call_SkillsetsDelete_568492(name: "skillsetsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/skillsets(\'{skillsetName}\')", validator: validate_SkillsetsDelete_568493,
    base: "", url: url_SkillsetsDelete_568494, schemes: {Scheme.Https})
type
  Call_SynonymMapsCreate_568510 = ref object of OpenApiRestCall_567668
proc url_SynonymMapsCreate_568512(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SynonymMapsCreate_568511(path: JsonNode; query: JsonNode;
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
  var valid_568513 = query.getOrDefault("api-version")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "api-version", valid_568513
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568514 = header.getOrDefault("client-request-id")
  valid_568514 = validateParameter(valid_568514, JString, required = false,
                                 default = nil)
  if valid_568514 != nil:
    section.add "client-request-id", valid_568514
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

proc call*(call_568516: Call_SynonymMapsCreate_568510; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search synonym map.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Synonym-Map
  let valid = call_568516.validator(path, query, header, formData, body)
  let scheme = call_568516.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568516.url(scheme.get, call_568516.host, call_568516.base,
                         call_568516.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568516, url, valid)

proc call*(call_568517: Call_SynonymMapsCreate_568510; apiVersion: string;
          synonymMap: JsonNode): Recallable =
  ## synonymMapsCreate
  ## Creates a new Azure Search synonym map.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Synonym-Map
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   synonymMap: JObject (required)
  ##             : The definition of the synonym map to create.
  var query_568518 = newJObject()
  var body_568519 = newJObject()
  add(query_568518, "api-version", newJString(apiVersion))
  if synonymMap != nil:
    body_568519 = synonymMap
  result = call_568517.call(nil, query_568518, nil, nil, body_568519)

var synonymMapsCreate* = Call_SynonymMapsCreate_568510(name: "synonymMapsCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/synonymmaps",
    validator: validate_SynonymMapsCreate_568511, base: "",
    url: url_SynonymMapsCreate_568512, schemes: {Scheme.Https})
type
  Call_SynonymMapsList_568502 = ref object of OpenApiRestCall_567668
proc url_SynonymMapsList_568504(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SynonymMapsList_568503(path: JsonNode; query: JsonNode;
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
  var valid_568505 = query.getOrDefault("api-version")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "api-version", valid_568505
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568506 = header.getOrDefault("client-request-id")
  valid_568506 = validateParameter(valid_568506, JString, required = false,
                                 default = nil)
  if valid_568506 != nil:
    section.add "client-request-id", valid_568506
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568507: Call_SynonymMapsList_568502; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all synonym maps available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Synonym-Maps
  let valid = call_568507.validator(path, query, header, formData, body)
  let scheme = call_568507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568507.url(scheme.get, call_568507.host, call_568507.base,
                         call_568507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568507, url, valid)

proc call*(call_568508: Call_SynonymMapsList_568502; apiVersion: string): Recallable =
  ## synonymMapsList
  ## Lists all synonym maps available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Synonym-Maps
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568509 = newJObject()
  add(query_568509, "api-version", newJString(apiVersion))
  result = call_568508.call(nil, query_568509, nil, nil, nil)

var synonymMapsList* = Call_SynonymMapsList_568502(name: "synonymMapsList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/synonymmaps",
    validator: validate_SynonymMapsList_568503, base: "", url: url_SynonymMapsList_568504,
    schemes: {Scheme.Https})
type
  Call_SynonymMapsCreateOrUpdate_568530 = ref object of OpenApiRestCall_567668
proc url_SynonymMapsCreateOrUpdate_568532(protocol: Scheme; host: string;
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

proc validate_SynonymMapsCreateOrUpdate_568531(path: JsonNode; query: JsonNode;
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
  var valid_568533 = path.getOrDefault("synonymMapName")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "synonymMapName", valid_568533
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568534 = query.getOrDefault("api-version")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "api-version", valid_568534
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
  var valid_568535 = header.getOrDefault("If-Match")
  valid_568535 = validateParameter(valid_568535, JString, required = false,
                                 default = nil)
  if valid_568535 != nil:
    section.add "If-Match", valid_568535
  var valid_568536 = header.getOrDefault("client-request-id")
  valid_568536 = validateParameter(valid_568536, JString, required = false,
                                 default = nil)
  if valid_568536 != nil:
    section.add "client-request-id", valid_568536
  var valid_568537 = header.getOrDefault("If-None-Match")
  valid_568537 = validateParameter(valid_568537, JString, required = false,
                                 default = nil)
  if valid_568537 != nil:
    section.add "If-None-Match", valid_568537
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_568538 = header.getOrDefault("Prefer")
  valid_568538 = validateParameter(valid_568538, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_568538 != nil:
    section.add "Prefer", valid_568538
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

proc call*(call_568540: Call_SynonymMapsCreateOrUpdate_568530; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search synonym map or updates a synonym map if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Synonym-Map
  let valid = call_568540.validator(path, query, header, formData, body)
  let scheme = call_568540.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568540.url(scheme.get, call_568540.host, call_568540.base,
                         call_568540.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568540, url, valid)

proc call*(call_568541: Call_SynonymMapsCreateOrUpdate_568530; apiVersion: string;
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
  var path_568542 = newJObject()
  var query_568543 = newJObject()
  var body_568544 = newJObject()
  add(query_568543, "api-version", newJString(apiVersion))
  if synonymMap != nil:
    body_568544 = synonymMap
  add(path_568542, "synonymMapName", newJString(synonymMapName))
  result = call_568541.call(path_568542, query_568543, nil, nil, body_568544)

var synonymMapsCreateOrUpdate* = Call_SynonymMapsCreateOrUpdate_568530(
    name: "synonymMapsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/synonymmaps(\'{synonymMapName}\')",
    validator: validate_SynonymMapsCreateOrUpdate_568531, base: "",
    url: url_SynonymMapsCreateOrUpdate_568532, schemes: {Scheme.Https})
type
  Call_SynonymMapsGet_568520 = ref object of OpenApiRestCall_567668
proc url_SynonymMapsGet_568522(protocol: Scheme; host: string; base: string;
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

proc validate_SynonymMapsGet_568521(path: JsonNode; query: JsonNode;
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
  var valid_568523 = path.getOrDefault("synonymMapName")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "synonymMapName", valid_568523
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568524 = query.getOrDefault("api-version")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "api-version", valid_568524
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568525 = header.getOrDefault("client-request-id")
  valid_568525 = validateParameter(valid_568525, JString, required = false,
                                 default = nil)
  if valid_568525 != nil:
    section.add "client-request-id", valid_568525
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568526: Call_SynonymMapsGet_568520; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a synonym map definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Synonym-Map
  let valid = call_568526.validator(path, query, header, formData, body)
  let scheme = call_568526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568526.url(scheme.get, call_568526.host, call_568526.base,
                         call_568526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568526, url, valid)

proc call*(call_568527: Call_SynonymMapsGet_568520; apiVersion: string;
          synonymMapName: string): Recallable =
  ## synonymMapsGet
  ## Retrieves a synonym map definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Synonym-Map
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   synonymMapName: string (required)
  ##                 : The name of the synonym map to retrieve.
  var path_568528 = newJObject()
  var query_568529 = newJObject()
  add(query_568529, "api-version", newJString(apiVersion))
  add(path_568528, "synonymMapName", newJString(synonymMapName))
  result = call_568527.call(path_568528, query_568529, nil, nil, nil)

var synonymMapsGet* = Call_SynonymMapsGet_568520(name: "synonymMapsGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/synonymmaps(\'{synonymMapName}\')",
    validator: validate_SynonymMapsGet_568521, base: "", url: url_SynonymMapsGet_568522,
    schemes: {Scheme.Https})
type
  Call_SynonymMapsDelete_568545 = ref object of OpenApiRestCall_567668
proc url_SynonymMapsDelete_568547(protocol: Scheme; host: string; base: string;
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

proc validate_SynonymMapsDelete_568546(path: JsonNode; query: JsonNode;
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
  var valid_568548 = path.getOrDefault("synonymMapName")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "synonymMapName", valid_568548
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568549 = query.getOrDefault("api-version")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "api-version", valid_568549
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  section = newJObject()
  var valid_568550 = header.getOrDefault("If-Match")
  valid_568550 = validateParameter(valid_568550, JString, required = false,
                                 default = nil)
  if valid_568550 != nil:
    section.add "If-Match", valid_568550
  var valid_568551 = header.getOrDefault("client-request-id")
  valid_568551 = validateParameter(valid_568551, JString, required = false,
                                 default = nil)
  if valid_568551 != nil:
    section.add "client-request-id", valid_568551
  var valid_568552 = header.getOrDefault("If-None-Match")
  valid_568552 = validateParameter(valid_568552, JString, required = false,
                                 default = nil)
  if valid_568552 != nil:
    section.add "If-None-Match", valid_568552
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568553: Call_SynonymMapsDelete_568545; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search synonym map.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Synonym-Map
  let valid = call_568553.validator(path, query, header, formData, body)
  let scheme = call_568553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568553.url(scheme.get, call_568553.host, call_568553.base,
                         call_568553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568553, url, valid)

proc call*(call_568554: Call_SynonymMapsDelete_568545; apiVersion: string;
          synonymMapName: string): Recallable =
  ## synonymMapsDelete
  ## Deletes an Azure Search synonym map.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Synonym-Map
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   synonymMapName: string (required)
  ##                 : The name of the synonym map to delete.
  var path_568555 = newJObject()
  var query_568556 = newJObject()
  add(query_568556, "api-version", newJString(apiVersion))
  add(path_568555, "synonymMapName", newJString(synonymMapName))
  result = call_568554.call(path_568555, query_568556, nil, nil, nil)

var synonymMapsDelete* = Call_SynonymMapsDelete_568545(name: "synonymMapsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/synonymmaps(\'{synonymMapName}\')",
    validator: validate_SynonymMapsDelete_568546, base: "",
    url: url_SynonymMapsDelete_568547, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
