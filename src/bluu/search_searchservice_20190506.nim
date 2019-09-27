
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SearchServiceClient
## version: 2019-05-06
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

  OpenApiRestCall_593439 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593439](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593439): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_DataSourcesCreate_593958 = ref object of OpenApiRestCall_593439
proc url_DataSourcesCreate_593960(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DataSourcesCreate_593959(path: JsonNode; query: JsonNode;
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
  var valid_593978 = query.getOrDefault("api-version")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "api-version", valid_593978
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_593979 = header.getOrDefault("client-request-id")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "client-request-id", valid_593979
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

proc call*(call_593981: Call_DataSourcesCreate_593958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search datasource.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Data-Source
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_DataSourcesCreate_593958; apiVersion: string;
          dataSource: JsonNode): Recallable =
  ## dataSourcesCreate
  ## Creates a new Azure Search datasource.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Data-Source
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSource: JObject (required)
  ##             : The definition of the datasource to create.
  var query_593983 = newJObject()
  var body_593984 = newJObject()
  add(query_593983, "api-version", newJString(apiVersion))
  if dataSource != nil:
    body_593984 = dataSource
  result = call_593982.call(nil, query_593983, nil, nil, body_593984)

var dataSourcesCreate* = Call_DataSourcesCreate_593958(name: "dataSourcesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/datasources",
    validator: validate_DataSourcesCreate_593959, base: "",
    url: url_DataSourcesCreate_593960, schemes: {Scheme.Https})
type
  Call_DataSourcesList_593661 = ref object of OpenApiRestCall_593439
proc url_DataSourcesList_593663(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DataSourcesList_593662(path: JsonNode; query: JsonNode;
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
  var valid_593822 = query.getOrDefault("api-version")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "api-version", valid_593822
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_593823 = header.getOrDefault("client-request-id")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "client-request-id", valid_593823
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593846: Call_DataSourcesList_593661; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all datasources available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Data-Sources
  let valid = call_593846.validator(path, query, header, formData, body)
  let scheme = call_593846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593846.url(scheme.get, call_593846.host, call_593846.base,
                         call_593846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593846, url, valid)

proc call*(call_593917: Call_DataSourcesList_593661; apiVersion: string): Recallable =
  ## dataSourcesList
  ## Lists all datasources available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Data-Sources
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_593918 = newJObject()
  add(query_593918, "api-version", newJString(apiVersion))
  result = call_593917.call(nil, query_593918, nil, nil, nil)

var dataSourcesList* = Call_DataSourcesList_593661(name: "dataSourcesList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/datasources",
    validator: validate_DataSourcesList_593662, base: "", url: url_DataSourcesList_593663,
    schemes: {Scheme.Https})
type
  Call_DataSourcesCreateOrUpdate_594009 = ref object of OpenApiRestCall_593439
proc url_DataSourcesCreateOrUpdate_594011(protocol: Scheme; host: string;
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

proc validate_DataSourcesCreateOrUpdate_594010(path: JsonNode; query: JsonNode;
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
  var valid_594012 = path.getOrDefault("dataSourceName")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "dataSourceName", valid_594012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594013 = query.getOrDefault("api-version")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "api-version", valid_594013
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
  var valid_594014 = header.getOrDefault("If-Match")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "If-Match", valid_594014
  var valid_594015 = header.getOrDefault("client-request-id")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "client-request-id", valid_594015
  var valid_594016 = header.getOrDefault("If-None-Match")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "If-None-Match", valid_594016
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_594030 = header.getOrDefault("Prefer")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_594030 != nil:
    section.add "Prefer", valid_594030
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

proc call*(call_594032: Call_DataSourcesCreateOrUpdate_594009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search datasource or updates a datasource if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Data-Source
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_DataSourcesCreateOrUpdate_594009; apiVersion: string;
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
  var path_594034 = newJObject()
  var query_594035 = newJObject()
  var body_594036 = newJObject()
  add(query_594035, "api-version", newJString(apiVersion))
  add(path_594034, "dataSourceName", newJString(dataSourceName))
  if dataSource != nil:
    body_594036 = dataSource
  result = call_594033.call(path_594034, query_594035, nil, nil, body_594036)

var dataSourcesCreateOrUpdate* = Call_DataSourcesCreateOrUpdate_594009(
    name: "dataSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesCreateOrUpdate_594010, base: "",
    url: url_DataSourcesCreateOrUpdate_594011, schemes: {Scheme.Https})
type
  Call_DataSourcesGet_593985 = ref object of OpenApiRestCall_593439
proc url_DataSourcesGet_593987(protocol: Scheme; host: string; base: string;
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

proc validate_DataSourcesGet_593986(path: JsonNode; query: JsonNode;
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
  var valid_594002 = path.getOrDefault("dataSourceName")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "dataSourceName", valid_594002
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594003 = query.getOrDefault("api-version")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "api-version", valid_594003
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594004 = header.getOrDefault("client-request-id")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "client-request-id", valid_594004
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594005: Call_DataSourcesGet_593985; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a datasource definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Data-Source
  let valid = call_594005.validator(path, query, header, formData, body)
  let scheme = call_594005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594005.url(scheme.get, call_594005.host, call_594005.base,
                         call_594005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594005, url, valid)

proc call*(call_594006: Call_DataSourcesGet_593985; apiVersion: string;
          dataSourceName: string): Recallable =
  ## dataSourcesGet
  ## Retrieves a datasource definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Data-Source
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to retrieve.
  var path_594007 = newJObject()
  var query_594008 = newJObject()
  add(query_594008, "api-version", newJString(apiVersion))
  add(path_594007, "dataSourceName", newJString(dataSourceName))
  result = call_594006.call(path_594007, query_594008, nil, nil, nil)

var dataSourcesGet* = Call_DataSourcesGet_593985(name: "dataSourcesGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesGet_593986, base: "", url: url_DataSourcesGet_593987,
    schemes: {Scheme.Https})
type
  Call_DataSourcesDelete_594037 = ref object of OpenApiRestCall_593439
proc url_DataSourcesDelete_594039(protocol: Scheme; host: string; base: string;
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

proc validate_DataSourcesDelete_594038(path: JsonNode; query: JsonNode;
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
  var valid_594040 = path.getOrDefault("dataSourceName")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "dataSourceName", valid_594040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594041 = query.getOrDefault("api-version")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "api-version", valid_594041
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  section = newJObject()
  var valid_594042 = header.getOrDefault("If-Match")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "If-Match", valid_594042
  var valid_594043 = header.getOrDefault("client-request-id")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "client-request-id", valid_594043
  var valid_594044 = header.getOrDefault("If-None-Match")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "If-None-Match", valid_594044
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594045: Call_DataSourcesDelete_594037; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search datasource.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Data-Source
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_DataSourcesDelete_594037; apiVersion: string;
          dataSourceName: string): Recallable =
  ## dataSourcesDelete
  ## Deletes an Azure Search datasource.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Data-Source
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to delete.
  var path_594047 = newJObject()
  var query_594048 = newJObject()
  add(query_594048, "api-version", newJString(apiVersion))
  add(path_594047, "dataSourceName", newJString(dataSourceName))
  result = call_594046.call(path_594047, query_594048, nil, nil, nil)

var dataSourcesDelete* = Call_DataSourcesDelete_594037(name: "dataSourcesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesDelete_594038, base: "",
    url: url_DataSourcesDelete_594039, schemes: {Scheme.Https})
type
  Call_IndexersCreate_594057 = ref object of OpenApiRestCall_593439
proc url_IndexersCreate_594059(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexersCreate_594058(path: JsonNode; query: JsonNode;
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
  var valid_594060 = query.getOrDefault("api-version")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "api-version", valid_594060
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594061 = header.getOrDefault("client-request-id")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "client-request-id", valid_594061
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

proc call*(call_594063: Call_IndexersCreate_594057; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  let valid = call_594063.validator(path, query, header, formData, body)
  let scheme = call_594063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594063.url(scheme.get, call_594063.host, call_594063.base,
                         call_594063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594063, url, valid)

proc call*(call_594064: Call_IndexersCreate_594057; apiVersion: string;
          indexer: JsonNode): Recallable =
  ## indexersCreate
  ## Creates a new Azure Search indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexer: JObject (required)
  ##          : The definition of the indexer to create.
  var query_594065 = newJObject()
  var body_594066 = newJObject()
  add(query_594065, "api-version", newJString(apiVersion))
  if indexer != nil:
    body_594066 = indexer
  result = call_594064.call(nil, query_594065, nil, nil, body_594066)

var indexersCreate* = Call_IndexersCreate_594057(name: "indexersCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/indexers",
    validator: validate_IndexersCreate_594058, base: "", url: url_IndexersCreate_594059,
    schemes: {Scheme.Https})
type
  Call_IndexersList_594049 = ref object of OpenApiRestCall_593439
proc url_IndexersList_594051(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexersList_594050(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594052 = query.getOrDefault("api-version")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "api-version", valid_594052
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594053 = header.getOrDefault("client-request-id")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "client-request-id", valid_594053
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594054: Call_IndexersList_594049; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all indexers available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexers
  let valid = call_594054.validator(path, query, header, formData, body)
  let scheme = call_594054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594054.url(scheme.get, call_594054.host, call_594054.base,
                         call_594054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594054, url, valid)

proc call*(call_594055: Call_IndexersList_594049; apiVersion: string): Recallable =
  ## indexersList
  ## Lists all indexers available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexers
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_594056 = newJObject()
  add(query_594056, "api-version", newJString(apiVersion))
  result = call_594055.call(nil, query_594056, nil, nil, nil)

var indexersList* = Call_IndexersList_594049(name: "indexersList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/indexers",
    validator: validate_IndexersList_594050, base: "", url: url_IndexersList_594051,
    schemes: {Scheme.Https})
type
  Call_IndexersCreateOrUpdate_594077 = ref object of OpenApiRestCall_593439
proc url_IndexersCreateOrUpdate_594079(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersCreateOrUpdate_594078(path: JsonNode; query: JsonNode;
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
  var valid_594080 = path.getOrDefault("indexerName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "indexerName", valid_594080
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594081 = query.getOrDefault("api-version")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "api-version", valid_594081
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
  var valid_594082 = header.getOrDefault("If-Match")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "If-Match", valid_594082
  var valid_594083 = header.getOrDefault("client-request-id")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "client-request-id", valid_594083
  var valid_594084 = header.getOrDefault("If-None-Match")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "If-None-Match", valid_594084
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_594085 = header.getOrDefault("Prefer")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_594085 != nil:
    section.add "Prefer", valid_594085
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

proc call*(call_594087: Call_IndexersCreateOrUpdate_594077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search indexer or updates an indexer if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Indexer
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_IndexersCreateOrUpdate_594077; apiVersion: string;
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
  var path_594089 = newJObject()
  var query_594090 = newJObject()
  var body_594091 = newJObject()
  add(query_594090, "api-version", newJString(apiVersion))
  add(path_594089, "indexerName", newJString(indexerName))
  if indexer != nil:
    body_594091 = indexer
  result = call_594088.call(path_594089, query_594090, nil, nil, body_594091)

var indexersCreateOrUpdate* = Call_IndexersCreateOrUpdate_594077(
    name: "indexersCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/indexers(\'{indexerName}\')",
    validator: validate_IndexersCreateOrUpdate_594078, base: "",
    url: url_IndexersCreateOrUpdate_594079, schemes: {Scheme.Https})
type
  Call_IndexersGet_594067 = ref object of OpenApiRestCall_593439
proc url_IndexersGet_594069(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersGet_594068(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594070 = path.getOrDefault("indexerName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "indexerName", valid_594070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594071 = query.getOrDefault("api-version")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "api-version", valid_594071
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594072 = header.getOrDefault("client-request-id")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "client-request-id", valid_594072
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594073: Call_IndexersGet_594067; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an indexer definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_IndexersGet_594067; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersGet
  ## Retrieves an indexer definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to retrieve.
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  add(query_594076, "api-version", newJString(apiVersion))
  add(path_594075, "indexerName", newJString(indexerName))
  result = call_594074.call(path_594075, query_594076, nil, nil, nil)

var indexersGet* = Call_IndexersGet_594067(name: "indexersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local",
                                        route: "/indexers(\'{indexerName}\')",
                                        validator: validate_IndexersGet_594068,
                                        base: "", url: url_IndexersGet_594069,
                                        schemes: {Scheme.Https})
type
  Call_IndexersDelete_594092 = ref object of OpenApiRestCall_593439
proc url_IndexersDelete_594094(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersDelete_594093(path: JsonNode; query: JsonNode;
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
  var valid_594095 = path.getOrDefault("indexerName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "indexerName", valid_594095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594096 = query.getOrDefault("api-version")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "api-version", valid_594096
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  section = newJObject()
  var valid_594097 = header.getOrDefault("If-Match")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "If-Match", valid_594097
  var valid_594098 = header.getOrDefault("client-request-id")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "client-request-id", valid_594098
  var valid_594099 = header.getOrDefault("If-None-Match")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "If-None-Match", valid_594099
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594100: Call_IndexersDelete_594092; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Indexer
  let valid = call_594100.validator(path, query, header, formData, body)
  let scheme = call_594100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594100.url(scheme.get, call_594100.host, call_594100.base,
                         call_594100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594100, url, valid)

proc call*(call_594101: Call_IndexersDelete_594092; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersDelete
  ## Deletes an Azure Search indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to delete.
  var path_594102 = newJObject()
  var query_594103 = newJObject()
  add(query_594103, "api-version", newJString(apiVersion))
  add(path_594102, "indexerName", newJString(indexerName))
  result = call_594101.call(path_594102, query_594103, nil, nil, nil)

var indexersDelete* = Call_IndexersDelete_594092(name: "indexersDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/indexers(\'{indexerName}\')", validator: validate_IndexersDelete_594093,
    base: "", url: url_IndexersDelete_594094, schemes: {Scheme.Https})
type
  Call_IndexersReset_594104 = ref object of OpenApiRestCall_593439
proc url_IndexersReset_594106(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersReset_594105(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594107 = path.getOrDefault("indexerName")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "indexerName", valid_594107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594108 = query.getOrDefault("api-version")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "api-version", valid_594108
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594109 = header.getOrDefault("client-request-id")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "client-request-id", valid_594109
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594110: Call_IndexersReset_594104; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the change tracking state associated with an Azure Search indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Reset-Indexer
  let valid = call_594110.validator(path, query, header, formData, body)
  let scheme = call_594110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594110.url(scheme.get, call_594110.host, call_594110.base,
                         call_594110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594110, url, valid)

proc call*(call_594111: Call_IndexersReset_594104; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersReset
  ## Resets the change tracking state associated with an Azure Search indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Reset-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to reset.
  var path_594112 = newJObject()
  var query_594113 = newJObject()
  add(query_594113, "api-version", newJString(apiVersion))
  add(path_594112, "indexerName", newJString(indexerName))
  result = call_594111.call(path_594112, query_594113, nil, nil, nil)

var indexersReset* = Call_IndexersReset_594104(name: "indexersReset",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/indexers(\'{indexerName}\')/search.reset",
    validator: validate_IndexersReset_594105, base: "", url: url_IndexersReset_594106,
    schemes: {Scheme.Https})
type
  Call_IndexersRun_594114 = ref object of OpenApiRestCall_593439
proc url_IndexersRun_594116(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersRun_594115(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594117 = path.getOrDefault("indexerName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "indexerName", valid_594117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594118 = query.getOrDefault("api-version")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "api-version", valid_594118
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594119 = header.getOrDefault("client-request-id")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "client-request-id", valid_594119
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594120: Call_IndexersRun_594114; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs an Azure Search indexer on-demand.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Run-Indexer
  let valid = call_594120.validator(path, query, header, formData, body)
  let scheme = call_594120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594120.url(scheme.get, call_594120.host, call_594120.base,
                         call_594120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594120, url, valid)

proc call*(call_594121: Call_IndexersRun_594114; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersRun
  ## Runs an Azure Search indexer on-demand.
  ## https://docs.microsoft.com/rest/api/searchservice/Run-Indexer
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to run.
  var path_594122 = newJObject()
  var query_594123 = newJObject()
  add(query_594123, "api-version", newJString(apiVersion))
  add(path_594122, "indexerName", newJString(indexerName))
  result = call_594121.call(path_594122, query_594123, nil, nil, nil)

var indexersRun* = Call_IndexersRun_594114(name: "indexersRun",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local", route: "/indexers(\'{indexerName}\')/search.run",
                                        validator: validate_IndexersRun_594115,
                                        base: "", url: url_IndexersRun_594116,
                                        schemes: {Scheme.Https})
type
  Call_IndexersGetStatus_594124 = ref object of OpenApiRestCall_593439
proc url_IndexersGetStatus_594126(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersGetStatus_594125(path: JsonNode; query: JsonNode;
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
  var valid_594127 = path.getOrDefault("indexerName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "indexerName", valid_594127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594128 = query.getOrDefault("api-version")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "api-version", valid_594128
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594129 = header.getOrDefault("client-request-id")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "client-request-id", valid_594129
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594130: Call_IndexersGetStatus_594124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the current status and execution history of an indexer.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer-Status
  let valid = call_594130.validator(path, query, header, formData, body)
  let scheme = call_594130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594130.url(scheme.get, call_594130.host, call_594130.base,
                         call_594130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594130, url, valid)

proc call*(call_594131: Call_IndexersGetStatus_594124; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersGetStatus
  ## Returns the current status and execution history of an indexer.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Indexer-Status
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer for which to retrieve status.
  var path_594132 = newJObject()
  var query_594133 = newJObject()
  add(query_594133, "api-version", newJString(apiVersion))
  add(path_594132, "indexerName", newJString(indexerName))
  result = call_594131.call(path_594132, query_594133, nil, nil, nil)

var indexersGetStatus* = Call_IndexersGetStatus_594124(name: "indexersGetStatus",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/indexers(\'{indexerName}\')/search.status",
    validator: validate_IndexersGetStatus_594125, base: "",
    url: url_IndexersGetStatus_594126, schemes: {Scheme.Https})
type
  Call_IndexesCreate_594144 = ref object of OpenApiRestCall_593439
proc url_IndexesCreate_594146(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexesCreate_594145(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594147 = query.getOrDefault("api-version")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "api-version", valid_594147
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594148 = header.getOrDefault("client-request-id")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "client-request-id", valid_594148
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

proc call*(call_594150: Call_IndexesCreate_594144; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search index.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Index
  let valid = call_594150.validator(path, query, header, formData, body)
  let scheme = call_594150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594150.url(scheme.get, call_594150.host, call_594150.base,
                         call_594150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594150, url, valid)

proc call*(call_594151: Call_IndexesCreate_594144; apiVersion: string;
          index: JsonNode): Recallable =
  ## indexesCreate
  ## Creates a new Azure Search index.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Index
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   index: JObject (required)
  ##        : The definition of the index to create.
  var query_594152 = newJObject()
  var body_594153 = newJObject()
  add(query_594152, "api-version", newJString(apiVersion))
  if index != nil:
    body_594153 = index
  result = call_594151.call(nil, query_594152, nil, nil, body_594153)

var indexesCreate* = Call_IndexesCreate_594144(name: "indexesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/indexes",
    validator: validate_IndexesCreate_594145, base: "", url: url_IndexesCreate_594146,
    schemes: {Scheme.Https})
type
  Call_IndexesList_594134 = ref object of OpenApiRestCall_593439
proc url_IndexesList_594136(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexesList_594135(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594138 = query.getOrDefault("api-version")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "api-version", valid_594138
  var valid_594139 = query.getOrDefault("$select")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "$select", valid_594139
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594140 = header.getOrDefault("client-request-id")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "client-request-id", valid_594140
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594141: Call_IndexesList_594134; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all indexes available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexes
  let valid = call_594141.validator(path, query, header, formData, body)
  let scheme = call_594141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594141.url(scheme.get, call_594141.host, call_594141.base,
                         call_594141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594141, url, valid)

proc call*(call_594142: Call_IndexesList_594134; apiVersion: string;
          Select: string = ""): Recallable =
  ## indexesList
  ## Lists all indexes available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Indexes
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : Selects which properties of the index definitions to retrieve. Specified as a comma-separated list of JSON property names, or '*' for all properties. The default is all properties.
  var query_594143 = newJObject()
  add(query_594143, "api-version", newJString(apiVersion))
  add(query_594143, "$select", newJString(Select))
  result = call_594142.call(nil, query_594143, nil, nil, nil)

var indexesList* = Call_IndexesList_594134(name: "indexesList",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/indexes",
                                        validator: validate_IndexesList_594135,
                                        base: "", url: url_IndexesList_594136,
                                        schemes: {Scheme.Https})
type
  Call_IndexesCreateOrUpdate_594164 = ref object of OpenApiRestCall_593439
proc url_IndexesCreateOrUpdate_594166(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesCreateOrUpdate_594165(path: JsonNode; query: JsonNode;
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
  var valid_594167 = path.getOrDefault("indexName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "indexName", valid_594167
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   allowIndexDowntime: JBool
  ##                     : Allows new analyzers, tokenizers, token filters, or char filters to be added to an index by taking the index offline for at least a few seconds. This temporarily causes indexing and query requests to fail. Performance and write availability of the index can be impaired for several minutes after the index is updated, or longer for very large indexes.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594168 = query.getOrDefault("api-version")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "api-version", valid_594168
  var valid_594169 = query.getOrDefault("allowIndexDowntime")
  valid_594169 = validateParameter(valid_594169, JBool, required = false, default = nil)
  if valid_594169 != nil:
    section.add "allowIndexDowntime", valid_594169
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
  var valid_594170 = header.getOrDefault("If-Match")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "If-Match", valid_594170
  var valid_594171 = header.getOrDefault("client-request-id")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "client-request-id", valid_594171
  var valid_594172 = header.getOrDefault("If-None-Match")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "If-None-Match", valid_594172
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_594173 = header.getOrDefault("Prefer")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_594173 != nil:
    section.add "Prefer", valid_594173
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

proc call*(call_594175: Call_IndexesCreateOrUpdate_594164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search index or updates an index if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Index
  let valid = call_594175.validator(path, query, header, formData, body)
  let scheme = call_594175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594175.url(scheme.get, call_594175.host, call_594175.base,
                         call_594175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594175, url, valid)

proc call*(call_594176: Call_IndexesCreateOrUpdate_594164; indexName: string;
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
  var path_594177 = newJObject()
  var query_594178 = newJObject()
  var body_594179 = newJObject()
  add(path_594177, "indexName", newJString(indexName))
  add(query_594178, "api-version", newJString(apiVersion))
  if index != nil:
    body_594179 = index
  add(query_594178, "allowIndexDowntime", newJBool(allowIndexDowntime))
  result = call_594176.call(path_594177, query_594178, nil, nil, body_594179)

var indexesCreateOrUpdate* = Call_IndexesCreateOrUpdate_594164(
    name: "indexesCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/indexes(\'{indexName}\')", validator: validate_IndexesCreateOrUpdate_594165,
    base: "", url: url_IndexesCreateOrUpdate_594166, schemes: {Scheme.Https})
type
  Call_IndexesGet_594154 = ref object of OpenApiRestCall_593439
proc url_IndexesGet_594156(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_IndexesGet_594155(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594157 = path.getOrDefault("indexName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "indexName", valid_594157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594158 = query.getOrDefault("api-version")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "api-version", valid_594158
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594159 = header.getOrDefault("client-request-id")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "client-request-id", valid_594159
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594160: Call_IndexesGet_594154; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an index definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index
  let valid = call_594160.validator(path, query, header, formData, body)
  let scheme = call_594160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594160.url(scheme.get, call_594160.host, call_594160.base,
                         call_594160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594160, url, valid)

proc call*(call_594161: Call_IndexesGet_594154; indexName: string; apiVersion: string): Recallable =
  ## indexesGet
  ## Retrieves an index definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index
  ##   indexName: string (required)
  ##            : The name of the index to retrieve.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_594162 = newJObject()
  var query_594163 = newJObject()
  add(path_594162, "indexName", newJString(indexName))
  add(query_594163, "api-version", newJString(apiVersion))
  result = call_594161.call(path_594162, query_594163, nil, nil, nil)

var indexesGet* = Call_IndexesGet_594154(name: "indexesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local",
                                      route: "/indexes(\'{indexName}\')",
                                      validator: validate_IndexesGet_594155,
                                      base: "", url: url_IndexesGet_594156,
                                      schemes: {Scheme.Https})
type
  Call_IndexesDelete_594180 = ref object of OpenApiRestCall_593439
proc url_IndexesDelete_594182(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesDelete_594181(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594183 = path.getOrDefault("indexName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "indexName", valid_594183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594184 = query.getOrDefault("api-version")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "api-version", valid_594184
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  section = newJObject()
  var valid_594185 = header.getOrDefault("If-Match")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "If-Match", valid_594185
  var valid_594186 = header.getOrDefault("client-request-id")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "client-request-id", valid_594186
  var valid_594187 = header.getOrDefault("If-None-Match")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "If-None-Match", valid_594187
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594188: Call_IndexesDelete_594180; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search index and all the documents it contains.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Index
  let valid = call_594188.validator(path, query, header, formData, body)
  let scheme = call_594188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594188.url(scheme.get, call_594188.host, call_594188.base,
                         call_594188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594188, url, valid)

proc call*(call_594189: Call_IndexesDelete_594180; indexName: string;
          apiVersion: string): Recallable =
  ## indexesDelete
  ## Deletes an Azure Search index and all the documents it contains.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Index
  ##   indexName: string (required)
  ##            : The name of the index to delete.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_594190 = newJObject()
  var query_594191 = newJObject()
  add(path_594190, "indexName", newJString(indexName))
  add(query_594191, "api-version", newJString(apiVersion))
  result = call_594189.call(path_594190, query_594191, nil, nil, nil)

var indexesDelete* = Call_IndexesDelete_594180(name: "indexesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/indexes(\'{indexName}\')", validator: validate_IndexesDelete_594181,
    base: "", url: url_IndexesDelete_594182, schemes: {Scheme.Https})
type
  Call_IndexesAnalyze_594192 = ref object of OpenApiRestCall_593439
proc url_IndexesAnalyze_594194(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesAnalyze_594193(path: JsonNode; query: JsonNode;
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
  var valid_594195 = path.getOrDefault("indexName")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "indexName", valid_594195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594196 = query.getOrDefault("api-version")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "api-version", valid_594196
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594197 = header.getOrDefault("client-request-id")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "client-request-id", valid_594197
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

proc call*(call_594199: Call_IndexesAnalyze_594192; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shows how an analyzer breaks text into tokens.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/test-analyzer
  let valid = call_594199.validator(path, query, header, formData, body)
  let scheme = call_594199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594199.url(scheme.get, call_594199.host, call_594199.base,
                         call_594199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594199, url, valid)

proc call*(call_594200: Call_IndexesAnalyze_594192; indexName: string;
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
  var path_594201 = newJObject()
  var query_594202 = newJObject()
  var body_594203 = newJObject()
  add(path_594201, "indexName", newJString(indexName))
  add(query_594202, "api-version", newJString(apiVersion))
  if request != nil:
    body_594203 = request
  result = call_594200.call(path_594201, query_594202, nil, nil, body_594203)

var indexesAnalyze* = Call_IndexesAnalyze_594192(name: "indexesAnalyze",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/indexes(\'{indexName}\')/search.analyze",
    validator: validate_IndexesAnalyze_594193, base: "", url: url_IndexesAnalyze_594194,
    schemes: {Scheme.Https})
type
  Call_IndexesGetStatistics_594204 = ref object of OpenApiRestCall_593439
proc url_IndexesGetStatistics_594206(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesGetStatistics_594205(path: JsonNode; query: JsonNode;
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
  var valid_594207 = path.getOrDefault("indexName")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "indexName", valid_594207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594208 = query.getOrDefault("api-version")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "api-version", valid_594208
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594209 = header.getOrDefault("client-request-id")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "client-request-id", valid_594209
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594210: Call_IndexesGetStatistics_594204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns statistics for the given index, including a document count and storage usage.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index-Statistics
  let valid = call_594210.validator(path, query, header, formData, body)
  let scheme = call_594210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594210.url(scheme.get, call_594210.host, call_594210.base,
                         call_594210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594210, url, valid)

proc call*(call_594211: Call_IndexesGetStatistics_594204; indexName: string;
          apiVersion: string): Recallable =
  ## indexesGetStatistics
  ## Returns statistics for the given index, including a document count and storage usage.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Index-Statistics
  ##   indexName: string (required)
  ##            : The name of the index for which to retrieve statistics.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_594212 = newJObject()
  var query_594213 = newJObject()
  add(path_594212, "indexName", newJString(indexName))
  add(query_594213, "api-version", newJString(apiVersion))
  result = call_594211.call(path_594212, query_594213, nil, nil, nil)

var indexesGetStatistics* = Call_IndexesGetStatistics_594204(
    name: "indexesGetStatistics", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/indexes(\'{indexName}\')/search.stats",
    validator: validate_IndexesGetStatistics_594205, base: "",
    url: url_IndexesGetStatistics_594206, schemes: {Scheme.Https})
type
  Call_GetServiceStatistics_594214 = ref object of OpenApiRestCall_593439
proc url_GetServiceStatistics_594216(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetServiceStatistics_594215(path: JsonNode; query: JsonNode;
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
  var valid_594217 = query.getOrDefault("api-version")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "api-version", valid_594217
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594218 = header.getOrDefault("client-request-id")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "client-request-id", valid_594218
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594219: Call_GetServiceStatistics_594214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets service level statistics for an Azure Search service.
  ## 
  let valid = call_594219.validator(path, query, header, formData, body)
  let scheme = call_594219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594219.url(scheme.get, call_594219.host, call_594219.base,
                         call_594219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594219, url, valid)

proc call*(call_594220: Call_GetServiceStatistics_594214; apiVersion: string): Recallable =
  ## getServiceStatistics
  ## Gets service level statistics for an Azure Search service.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_594221 = newJObject()
  add(query_594221, "api-version", newJString(apiVersion))
  result = call_594220.call(nil, query_594221, nil, nil, nil)

var getServiceStatistics* = Call_GetServiceStatistics_594214(
    name: "getServiceStatistics", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/servicestats", validator: validate_GetServiceStatistics_594215,
    base: "", url: url_GetServiceStatistics_594216, schemes: {Scheme.Https})
type
  Call_SkillsetsCreate_594230 = ref object of OpenApiRestCall_593439
proc url_SkillsetsCreate_594232(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SkillsetsCreate_594231(path: JsonNode; query: JsonNode;
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
  var valid_594233 = query.getOrDefault("api-version")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "api-version", valid_594233
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594234 = header.getOrDefault("client-request-id")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "client-request-id", valid_594234
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

proc call*(call_594236: Call_SkillsetsCreate_594230; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new cognitive skillset in an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/create-skillset
  let valid = call_594236.validator(path, query, header, formData, body)
  let scheme = call_594236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594236.url(scheme.get, call_594236.host, call_594236.base,
                         call_594236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594236, url, valid)

proc call*(call_594237: Call_SkillsetsCreate_594230; apiVersion: string;
          skillset: JsonNode): Recallable =
  ## skillsetsCreate
  ## Creates a new cognitive skillset in an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/create-skillset
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skillset: JObject (required)
  ##           : The skillset containing one or more cognitive skills to create in an Azure Search service.
  var query_594238 = newJObject()
  var body_594239 = newJObject()
  add(query_594238, "api-version", newJString(apiVersion))
  if skillset != nil:
    body_594239 = skillset
  result = call_594237.call(nil, query_594238, nil, nil, body_594239)

var skillsetsCreate* = Call_SkillsetsCreate_594230(name: "skillsetsCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/skillsets",
    validator: validate_SkillsetsCreate_594231, base: "", url: url_SkillsetsCreate_594232,
    schemes: {Scheme.Https})
type
  Call_SkillsetsList_594222 = ref object of OpenApiRestCall_593439
proc url_SkillsetsList_594224(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SkillsetsList_594223(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594225 = query.getOrDefault("api-version")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "api-version", valid_594225
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594226 = header.getOrDefault("client-request-id")
  valid_594226 = validateParameter(valid_594226, JString, required = false,
                                 default = nil)
  if valid_594226 != nil:
    section.add "client-request-id", valid_594226
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594227: Call_SkillsetsList_594222; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all cognitive skillsets in an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/list-skillset
  let valid = call_594227.validator(path, query, header, formData, body)
  let scheme = call_594227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594227.url(scheme.get, call_594227.host, call_594227.base,
                         call_594227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594227, url, valid)

proc call*(call_594228: Call_SkillsetsList_594222; apiVersion: string): Recallable =
  ## skillsetsList
  ## List all cognitive skillsets in an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/list-skillset
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_594229 = newJObject()
  add(query_594229, "api-version", newJString(apiVersion))
  result = call_594228.call(nil, query_594229, nil, nil, nil)

var skillsetsList* = Call_SkillsetsList_594222(name: "skillsetsList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/skillsets",
    validator: validate_SkillsetsList_594223, base: "", url: url_SkillsetsList_594224,
    schemes: {Scheme.Https})
type
  Call_SkillsetsCreateOrUpdate_594250 = ref object of OpenApiRestCall_593439
proc url_SkillsetsCreateOrUpdate_594252(protocol: Scheme; host: string; base: string;
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

proc validate_SkillsetsCreateOrUpdate_594251(path: JsonNode; query: JsonNode;
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
  var valid_594253 = path.getOrDefault("skillsetName")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "skillsetName", valid_594253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594254 = query.getOrDefault("api-version")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "api-version", valid_594254
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   Prefer: JString (required)
  ##         : For HTTP PUT requests, instructs the service to return the created/updated resource on success.
  section = newJObject()
  var valid_594255 = header.getOrDefault("client-request-id")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "client-request-id", valid_594255
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_594256 = header.getOrDefault("Prefer")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_594256 != nil:
    section.add "Prefer", valid_594256
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

proc call*(call_594258: Call_SkillsetsCreateOrUpdate_594250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new cognitive skillset in an Azure Search service or updates the skillset if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/update-skillset
  let valid = call_594258.validator(path, query, header, formData, body)
  let scheme = call_594258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594258.url(scheme.get, call_594258.host, call_594258.base,
                         call_594258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594258, url, valid)

proc call*(call_594259: Call_SkillsetsCreateOrUpdate_594250; apiVersion: string;
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
  var path_594260 = newJObject()
  var query_594261 = newJObject()
  var body_594262 = newJObject()
  add(query_594261, "api-version", newJString(apiVersion))
  add(path_594260, "skillsetName", newJString(skillsetName))
  if skillset != nil:
    body_594262 = skillset
  result = call_594259.call(path_594260, query_594261, nil, nil, body_594262)

var skillsetsCreateOrUpdate* = Call_SkillsetsCreateOrUpdate_594250(
    name: "skillsetsCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/skillsets(\'{skillsetName}\')",
    validator: validate_SkillsetsCreateOrUpdate_594251, base: "",
    url: url_SkillsetsCreateOrUpdate_594252, schemes: {Scheme.Https})
type
  Call_SkillsetsGet_594240 = ref object of OpenApiRestCall_593439
proc url_SkillsetsGet_594242(protocol: Scheme; host: string; base: string;
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

proc validate_SkillsetsGet_594241(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594243 = path.getOrDefault("skillsetName")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "skillsetName", valid_594243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594244 = query.getOrDefault("api-version")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "api-version", valid_594244
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594245 = header.getOrDefault("client-request-id")
  valid_594245 = validateParameter(valid_594245, JString, required = false,
                                 default = nil)
  if valid_594245 != nil:
    section.add "client-request-id", valid_594245
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594246: Call_SkillsetsGet_594240; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a cognitive skillset in an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/get-skillset
  let valid = call_594246.validator(path, query, header, formData, body)
  let scheme = call_594246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594246.url(scheme.get, call_594246.host, call_594246.base,
                         call_594246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594246, url, valid)

proc call*(call_594247: Call_SkillsetsGet_594240; apiVersion: string;
          skillsetName: string): Recallable =
  ## skillsetsGet
  ## Retrieves a cognitive skillset in an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/get-skillset
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skillsetName: string (required)
  ##               : The name of the skillset to retrieve.
  var path_594248 = newJObject()
  var query_594249 = newJObject()
  add(query_594249, "api-version", newJString(apiVersion))
  add(path_594248, "skillsetName", newJString(skillsetName))
  result = call_594247.call(path_594248, query_594249, nil, nil, nil)

var skillsetsGet* = Call_SkillsetsGet_594240(name: "skillsetsGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/skillsets(\'{skillsetName}\')", validator: validate_SkillsetsGet_594241,
    base: "", url: url_SkillsetsGet_594242, schemes: {Scheme.Https})
type
  Call_SkillsetsDelete_594263 = ref object of OpenApiRestCall_593439
proc url_SkillsetsDelete_594265(protocol: Scheme; host: string; base: string;
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

proc validate_SkillsetsDelete_594264(path: JsonNode; query: JsonNode;
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
  var valid_594266 = path.getOrDefault("skillsetName")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "skillsetName", valid_594266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594267 = query.getOrDefault("api-version")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "api-version", valid_594267
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594268 = header.getOrDefault("client-request-id")
  valid_594268 = validateParameter(valid_594268, JString, required = false,
                                 default = nil)
  if valid_594268 != nil:
    section.add "client-request-id", valid_594268
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594269: Call_SkillsetsDelete_594263; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a cognitive skillset in an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/delete-skillset
  let valid = call_594269.validator(path, query, header, formData, body)
  let scheme = call_594269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594269.url(scheme.get, call_594269.host, call_594269.base,
                         call_594269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594269, url, valid)

proc call*(call_594270: Call_SkillsetsDelete_594263; apiVersion: string;
          skillsetName: string): Recallable =
  ## skillsetsDelete
  ## Deletes a cognitive skillset in an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/delete-skillset
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skillsetName: string (required)
  ##               : The name of the skillset to delete.
  var path_594271 = newJObject()
  var query_594272 = newJObject()
  add(query_594272, "api-version", newJString(apiVersion))
  add(path_594271, "skillsetName", newJString(skillsetName))
  result = call_594270.call(path_594271, query_594272, nil, nil, nil)

var skillsetsDelete* = Call_SkillsetsDelete_594263(name: "skillsetsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/skillsets(\'{skillsetName}\')", validator: validate_SkillsetsDelete_594264,
    base: "", url: url_SkillsetsDelete_594265, schemes: {Scheme.Https})
type
  Call_SynonymMapsCreate_594281 = ref object of OpenApiRestCall_593439
proc url_SynonymMapsCreate_594283(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SynonymMapsCreate_594282(path: JsonNode; query: JsonNode;
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
  var valid_594284 = query.getOrDefault("api-version")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "api-version", valid_594284
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594285 = header.getOrDefault("client-request-id")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = nil)
  if valid_594285 != nil:
    section.add "client-request-id", valid_594285
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

proc call*(call_594287: Call_SynonymMapsCreate_594281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search synonym map.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Synonym-Map
  let valid = call_594287.validator(path, query, header, formData, body)
  let scheme = call_594287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594287.url(scheme.get, call_594287.host, call_594287.base,
                         call_594287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594287, url, valid)

proc call*(call_594288: Call_SynonymMapsCreate_594281; apiVersion: string;
          synonymMap: JsonNode): Recallable =
  ## synonymMapsCreate
  ## Creates a new Azure Search synonym map.
  ## https://docs.microsoft.com/rest/api/searchservice/Create-Synonym-Map
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   synonymMap: JObject (required)
  ##             : The definition of the synonym map to create.
  var query_594289 = newJObject()
  var body_594290 = newJObject()
  add(query_594289, "api-version", newJString(apiVersion))
  if synonymMap != nil:
    body_594290 = synonymMap
  result = call_594288.call(nil, query_594289, nil, nil, body_594290)

var synonymMapsCreate* = Call_SynonymMapsCreate_594281(name: "synonymMapsCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/synonymmaps",
    validator: validate_SynonymMapsCreate_594282, base: "",
    url: url_SynonymMapsCreate_594283, schemes: {Scheme.Https})
type
  Call_SynonymMapsList_594273 = ref object of OpenApiRestCall_593439
proc url_SynonymMapsList_594275(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SynonymMapsList_594274(path: JsonNode; query: JsonNode;
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
  var valid_594276 = query.getOrDefault("api-version")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "api-version", valid_594276
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594277 = header.getOrDefault("client-request-id")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "client-request-id", valid_594277
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594278: Call_SynonymMapsList_594273; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all synonym maps available for an Azure Search service.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/List-Synonym-Maps
  let valid = call_594278.validator(path, query, header, formData, body)
  let scheme = call_594278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594278.url(scheme.get, call_594278.host, call_594278.base,
                         call_594278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594278, url, valid)

proc call*(call_594279: Call_SynonymMapsList_594273; apiVersion: string): Recallable =
  ## synonymMapsList
  ## Lists all synonym maps available for an Azure Search service.
  ## https://docs.microsoft.com/rest/api/searchservice/List-Synonym-Maps
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_594280 = newJObject()
  add(query_594280, "api-version", newJString(apiVersion))
  result = call_594279.call(nil, query_594280, nil, nil, nil)

var synonymMapsList* = Call_SynonymMapsList_594273(name: "synonymMapsList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/synonymmaps",
    validator: validate_SynonymMapsList_594274, base: "", url: url_SynonymMapsList_594275,
    schemes: {Scheme.Https})
type
  Call_SynonymMapsCreateOrUpdate_594301 = ref object of OpenApiRestCall_593439
proc url_SynonymMapsCreateOrUpdate_594303(protocol: Scheme; host: string;
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

proc validate_SynonymMapsCreateOrUpdate_594302(path: JsonNode; query: JsonNode;
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
  var valid_594304 = path.getOrDefault("synonymMapName")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "synonymMapName", valid_594304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594305 = query.getOrDefault("api-version")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "api-version", valid_594305
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
  var valid_594306 = header.getOrDefault("If-Match")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "If-Match", valid_594306
  var valid_594307 = header.getOrDefault("client-request-id")
  valid_594307 = validateParameter(valid_594307, JString, required = false,
                                 default = nil)
  if valid_594307 != nil:
    section.add "client-request-id", valid_594307
  var valid_594308 = header.getOrDefault("If-None-Match")
  valid_594308 = validateParameter(valid_594308, JString, required = false,
                                 default = nil)
  if valid_594308 != nil:
    section.add "If-None-Match", valid_594308
  assert header != nil,
        "header argument is necessary due to required `Prefer` field"
  var valid_594309 = header.getOrDefault("Prefer")
  valid_594309 = validateParameter(valid_594309, JString, required = true,
                                 default = newJString("return=representation"))
  if valid_594309 != nil:
    section.add "Prefer", valid_594309
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

proc call*(call_594311: Call_SynonymMapsCreateOrUpdate_594301; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search synonym map or updates a synonym map if it already exists.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Update-Synonym-Map
  let valid = call_594311.validator(path, query, header, formData, body)
  let scheme = call_594311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594311.url(scheme.get, call_594311.host, call_594311.base,
                         call_594311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594311, url, valid)

proc call*(call_594312: Call_SynonymMapsCreateOrUpdate_594301; apiVersion: string;
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
  var path_594313 = newJObject()
  var query_594314 = newJObject()
  var body_594315 = newJObject()
  add(query_594314, "api-version", newJString(apiVersion))
  if synonymMap != nil:
    body_594315 = synonymMap
  add(path_594313, "synonymMapName", newJString(synonymMapName))
  result = call_594312.call(path_594313, query_594314, nil, nil, body_594315)

var synonymMapsCreateOrUpdate* = Call_SynonymMapsCreateOrUpdate_594301(
    name: "synonymMapsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/synonymmaps(\'{synonymMapName}\')",
    validator: validate_SynonymMapsCreateOrUpdate_594302, base: "",
    url: url_SynonymMapsCreateOrUpdate_594303, schemes: {Scheme.Https})
type
  Call_SynonymMapsGet_594291 = ref object of OpenApiRestCall_593439
proc url_SynonymMapsGet_594293(protocol: Scheme; host: string; base: string;
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

proc validate_SynonymMapsGet_594292(path: JsonNode; query: JsonNode;
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
  var valid_594294 = path.getOrDefault("synonymMapName")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "synonymMapName", valid_594294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594295 = query.getOrDefault("api-version")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "api-version", valid_594295
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594296 = header.getOrDefault("client-request-id")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = nil)
  if valid_594296 != nil:
    section.add "client-request-id", valid_594296
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594297: Call_SynonymMapsGet_594291; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a synonym map definition from Azure Search.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Synonym-Map
  let valid = call_594297.validator(path, query, header, formData, body)
  let scheme = call_594297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594297.url(scheme.get, call_594297.host, call_594297.base,
                         call_594297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594297, url, valid)

proc call*(call_594298: Call_SynonymMapsGet_594291; apiVersion: string;
          synonymMapName: string): Recallable =
  ## synonymMapsGet
  ## Retrieves a synonym map definition from Azure Search.
  ## https://docs.microsoft.com/rest/api/searchservice/Get-Synonym-Map
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   synonymMapName: string (required)
  ##                 : The name of the synonym map to retrieve.
  var path_594299 = newJObject()
  var query_594300 = newJObject()
  add(query_594300, "api-version", newJString(apiVersion))
  add(path_594299, "synonymMapName", newJString(synonymMapName))
  result = call_594298.call(path_594299, query_594300, nil, nil, nil)

var synonymMapsGet* = Call_SynonymMapsGet_594291(name: "synonymMapsGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/synonymmaps(\'{synonymMapName}\')",
    validator: validate_SynonymMapsGet_594292, base: "", url: url_SynonymMapsGet_594293,
    schemes: {Scheme.Https})
type
  Call_SynonymMapsDelete_594316 = ref object of OpenApiRestCall_593439
proc url_SynonymMapsDelete_594318(protocol: Scheme; host: string; base: string;
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

proc validate_SynonymMapsDelete_594317(path: JsonNode; query: JsonNode;
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
  var valid_594319 = path.getOrDefault("synonymMapName")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "synonymMapName", valid_594319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594320 = query.getOrDefault("api-version")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = nil)
  if valid_594320 != nil:
    section.add "api-version", valid_594320
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Defines the If-Match condition. The operation will be performed only if the ETag on the server matches this value.
  ##   client-request-id: JString
  ##                    : The tracking ID sent with the request to help with debugging.
  ##   If-None-Match: JString
  ##                : Defines the If-None-Match condition. The operation will be performed only if the ETag on the server does not match this value.
  section = newJObject()
  var valid_594321 = header.getOrDefault("If-Match")
  valid_594321 = validateParameter(valid_594321, JString, required = false,
                                 default = nil)
  if valid_594321 != nil:
    section.add "If-Match", valid_594321
  var valid_594322 = header.getOrDefault("client-request-id")
  valid_594322 = validateParameter(valid_594322, JString, required = false,
                                 default = nil)
  if valid_594322 != nil:
    section.add "client-request-id", valid_594322
  var valid_594323 = header.getOrDefault("If-None-Match")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "If-None-Match", valid_594323
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594324: Call_SynonymMapsDelete_594316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search synonym map.
  ## 
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Synonym-Map
  let valid = call_594324.validator(path, query, header, formData, body)
  let scheme = call_594324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594324.url(scheme.get, call_594324.host, call_594324.base,
                         call_594324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594324, url, valid)

proc call*(call_594325: Call_SynonymMapsDelete_594316; apiVersion: string;
          synonymMapName: string): Recallable =
  ## synonymMapsDelete
  ## Deletes an Azure Search synonym map.
  ## https://docs.microsoft.com/rest/api/searchservice/Delete-Synonym-Map
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   synonymMapName: string (required)
  ##                 : The name of the synonym map to delete.
  var path_594326 = newJObject()
  var query_594327 = newJObject()
  add(query_594327, "api-version", newJString(apiVersion))
  add(path_594326, "synonymMapName", newJString(synonymMapName))
  result = call_594325.call(path_594326, query_594327, nil, nil, nil)

var synonymMapsDelete* = Call_SynonymMapsDelete_594316(name: "synonymMapsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/synonymmaps(\'{synonymMapName}\')",
    validator: validate_SynonymMapsDelete_594317, base: "",
    url: url_SynonymMapsDelete_594318, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
