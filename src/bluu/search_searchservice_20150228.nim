
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SearchServiceClient
## version: 2015-02-28
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  Call_DataSourcesCreate_568160 = ref object of OpenApiRestCall_567641
proc url_DataSourcesCreate_568162(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DataSourcesCreate_568161(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a new Azure Search datasource.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946876.aspx
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
  var valid_568180 = query.getOrDefault("api-version")
  valid_568180 = validateParameter(valid_568180, JString, required = true,
                                 default = nil)
  if valid_568180 != nil:
    section.add "api-version", valid_568180
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568181 = header.getOrDefault("client-request-id")
  valid_568181 = validateParameter(valid_568181, JString, required = false,
                                 default = nil)
  if valid_568181 != nil:
    section.add "client-request-id", valid_568181
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

proc call*(call_568183: Call_DataSourcesCreate_568160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search datasource.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946876.aspx
  let valid = call_568183.validator(path, query, header, formData, body)
  let scheme = call_568183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568183.url(scheme.get, call_568183.host, call_568183.base,
                         call_568183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568183, url, valid)

proc call*(call_568184: Call_DataSourcesCreate_568160; apiVersion: string;
          dataSource: JsonNode): Recallable =
  ## dataSourcesCreate
  ## Creates a new Azure Search datasource.
  ## https://msdn.microsoft.com/library/azure/dn946876.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSource: JObject (required)
  ##             : The definition of the datasource to create.
  var query_568185 = newJObject()
  var body_568186 = newJObject()
  add(query_568185, "api-version", newJString(apiVersion))
  if dataSource != nil:
    body_568186 = dataSource
  result = call_568184.call(nil, query_568185, nil, nil, body_568186)

var dataSourcesCreate* = Call_DataSourcesCreate_568160(name: "dataSourcesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/datasources",
    validator: validate_DataSourcesCreate_568161, base: "",
    url: url_DataSourcesCreate_568162, schemes: {Scheme.Https})
type
  Call_DataSourcesList_567863 = ref object of OpenApiRestCall_567641
proc url_DataSourcesList_567865(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DataSourcesList_567864(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists all datasources available for an Azure Search service.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946878.aspx
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
  var valid_568024 = query.getOrDefault("api-version")
  valid_568024 = validateParameter(valid_568024, JString, required = true,
                                 default = nil)
  if valid_568024 != nil:
    section.add "api-version", valid_568024
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568025 = header.getOrDefault("client-request-id")
  valid_568025 = validateParameter(valid_568025, JString, required = false,
                                 default = nil)
  if valid_568025 != nil:
    section.add "client-request-id", valid_568025
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568048: Call_DataSourcesList_567863; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all datasources available for an Azure Search service.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946878.aspx
  let valid = call_568048.validator(path, query, header, formData, body)
  let scheme = call_568048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568048.url(scheme.get, call_568048.host, call_568048.base,
                         call_568048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568048, url, valid)

proc call*(call_568119: Call_DataSourcesList_567863; apiVersion: string): Recallable =
  ## dataSourcesList
  ## Lists all datasources available for an Azure Search service.
  ## https://msdn.microsoft.com/library/azure/dn946878.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568120 = newJObject()
  add(query_568120, "api-version", newJString(apiVersion))
  result = call_568119.call(nil, query_568120, nil, nil, nil)

var dataSourcesList* = Call_DataSourcesList_567863(name: "dataSourcesList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/datasources",
    validator: validate_DataSourcesList_567864, base: "", url: url_DataSourcesList_567865,
    schemes: {Scheme.Https})
type
  Call_DataSourcesCreateOrUpdate_568211 = ref object of OpenApiRestCall_567641
proc url_DataSourcesCreateOrUpdate_568213(protocol: Scheme; host: string;
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

proc validate_DataSourcesCreateOrUpdate_568212(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Azure Search datasource or updates a datasource if it already exists.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946900.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataSourceName: JString (required)
  ##                 : The name of the datasource to create or update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataSourceName` field"
  var valid_568214 = path.getOrDefault("dataSourceName")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "dataSourceName", valid_568214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568215 = query.getOrDefault("api-version")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "api-version", valid_568215
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568216 = header.getOrDefault("client-request-id")
  valid_568216 = validateParameter(valid_568216, JString, required = false,
                                 default = nil)
  if valid_568216 != nil:
    section.add "client-request-id", valid_568216
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

proc call*(call_568218: Call_DataSourcesCreateOrUpdate_568211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search datasource or updates a datasource if it already exists.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946900.aspx
  let valid = call_568218.validator(path, query, header, formData, body)
  let scheme = call_568218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568218.url(scheme.get, call_568218.host, call_568218.base,
                         call_568218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568218, url, valid)

proc call*(call_568219: Call_DataSourcesCreateOrUpdate_568211; apiVersion: string;
          dataSourceName: string; dataSource: JsonNode): Recallable =
  ## dataSourcesCreateOrUpdate
  ## Creates a new Azure Search datasource or updates a datasource if it already exists.
  ## https://msdn.microsoft.com/library/azure/dn946900.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to create or update.
  ##   dataSource: JObject (required)
  ##             : The definition of the datasource to create or update.
  var path_568220 = newJObject()
  var query_568221 = newJObject()
  var body_568222 = newJObject()
  add(query_568221, "api-version", newJString(apiVersion))
  add(path_568220, "dataSourceName", newJString(dataSourceName))
  if dataSource != nil:
    body_568222 = dataSource
  result = call_568219.call(path_568220, query_568221, nil, nil, body_568222)

var dataSourcesCreateOrUpdate* = Call_DataSourcesCreateOrUpdate_568211(
    name: "dataSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesCreateOrUpdate_568212, base: "",
    url: url_DataSourcesCreateOrUpdate_568213, schemes: {Scheme.Https})
type
  Call_DataSourcesGet_568187 = ref object of OpenApiRestCall_567641
proc url_DataSourcesGet_568189(protocol: Scheme; host: string; base: string;
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

proc validate_DataSourcesGet_568188(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves a datasource definition from Azure Search.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946893.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataSourceName: JString (required)
  ##                 : The name of the datasource to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataSourceName` field"
  var valid_568204 = path.getOrDefault("dataSourceName")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "dataSourceName", valid_568204
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
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568206 = header.getOrDefault("client-request-id")
  valid_568206 = validateParameter(valid_568206, JString, required = false,
                                 default = nil)
  if valid_568206 != nil:
    section.add "client-request-id", valid_568206
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568207: Call_DataSourcesGet_568187; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a datasource definition from Azure Search.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946893.aspx
  let valid = call_568207.validator(path, query, header, formData, body)
  let scheme = call_568207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568207.url(scheme.get, call_568207.host, call_568207.base,
                         call_568207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568207, url, valid)

proc call*(call_568208: Call_DataSourcesGet_568187; apiVersion: string;
          dataSourceName: string): Recallable =
  ## dataSourcesGet
  ## Retrieves a datasource definition from Azure Search.
  ## https://msdn.microsoft.com/library/azure/dn946893.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to retrieve.
  var path_568209 = newJObject()
  var query_568210 = newJObject()
  add(query_568210, "api-version", newJString(apiVersion))
  add(path_568209, "dataSourceName", newJString(dataSourceName))
  result = call_568208.call(path_568209, query_568210, nil, nil, nil)

var dataSourcesGet* = Call_DataSourcesGet_568187(name: "dataSourcesGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesGet_568188, base: "", url: url_DataSourcesGet_568189,
    schemes: {Scheme.Https})
type
  Call_DataSourcesDelete_568223 = ref object of OpenApiRestCall_567641
proc url_DataSourcesDelete_568225(protocol: Scheme; host: string; base: string;
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

proc validate_DataSourcesDelete_568224(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an Azure Search datasource.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946881.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataSourceName: JString (required)
  ##                 : The name of the datasource to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataSourceName` field"
  var valid_568226 = path.getOrDefault("dataSourceName")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "dataSourceName", valid_568226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568227 = query.getOrDefault("api-version")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "api-version", valid_568227
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568228 = header.getOrDefault("client-request-id")
  valid_568228 = validateParameter(valid_568228, JString, required = false,
                                 default = nil)
  if valid_568228 != nil:
    section.add "client-request-id", valid_568228
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568229: Call_DataSourcesDelete_568223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search datasource.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946881.aspx
  let valid = call_568229.validator(path, query, header, formData, body)
  let scheme = call_568229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568229.url(scheme.get, call_568229.host, call_568229.base,
                         call_568229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568229, url, valid)

proc call*(call_568230: Call_DataSourcesDelete_568223; apiVersion: string;
          dataSourceName: string): Recallable =
  ## dataSourcesDelete
  ## Deletes an Azure Search datasource.
  ## https://msdn.microsoft.com/library/azure/dn946881.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to delete.
  var path_568231 = newJObject()
  var query_568232 = newJObject()
  add(query_568232, "api-version", newJString(apiVersion))
  add(path_568231, "dataSourceName", newJString(dataSourceName))
  result = call_568230.call(path_568231, query_568232, nil, nil, nil)

var dataSourcesDelete* = Call_DataSourcesDelete_568223(name: "dataSourcesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesDelete_568224, base: "",
    url: url_DataSourcesDelete_568225, schemes: {Scheme.Https})
type
  Call_IndexersCreate_568241 = ref object of OpenApiRestCall_567641
proc url_IndexersCreate_568243(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexersCreate_568242(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates a new Azure Search indexer.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946899.aspx
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
  var valid_568244 = query.getOrDefault("api-version")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "api-version", valid_568244
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568245 = header.getOrDefault("client-request-id")
  valid_568245 = validateParameter(valid_568245, JString, required = false,
                                 default = nil)
  if valid_568245 != nil:
    section.add "client-request-id", valid_568245
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

proc call*(call_568247: Call_IndexersCreate_568241; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search indexer.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946899.aspx
  let valid = call_568247.validator(path, query, header, formData, body)
  let scheme = call_568247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568247.url(scheme.get, call_568247.host, call_568247.base,
                         call_568247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568247, url, valid)

proc call*(call_568248: Call_IndexersCreate_568241; apiVersion: string;
          indexer: JsonNode): Recallable =
  ## indexersCreate
  ## Creates a new Azure Search indexer.
  ## https://msdn.microsoft.com/library/azure/dn946899.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexer: JObject (required)
  ##          : The definition of the indexer to create.
  var query_568249 = newJObject()
  var body_568250 = newJObject()
  add(query_568249, "api-version", newJString(apiVersion))
  if indexer != nil:
    body_568250 = indexer
  result = call_568248.call(nil, query_568249, nil, nil, body_568250)

var indexersCreate* = Call_IndexersCreate_568241(name: "indexersCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/indexers",
    validator: validate_IndexersCreate_568242, base: "", url: url_IndexersCreate_568243,
    schemes: {Scheme.Https})
type
  Call_IndexersList_568233 = ref object of OpenApiRestCall_567641
proc url_IndexersList_568235(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexersList_568234(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all indexers available for an Azure Search service.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946883.aspx
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
  var valid_568236 = query.getOrDefault("api-version")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "api-version", valid_568236
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568237 = header.getOrDefault("client-request-id")
  valid_568237 = validateParameter(valid_568237, JString, required = false,
                                 default = nil)
  if valid_568237 != nil:
    section.add "client-request-id", valid_568237
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568238: Call_IndexersList_568233; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all indexers available for an Azure Search service.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946883.aspx
  let valid = call_568238.validator(path, query, header, formData, body)
  let scheme = call_568238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568238.url(scheme.get, call_568238.host, call_568238.base,
                         call_568238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568238, url, valid)

proc call*(call_568239: Call_IndexersList_568233; apiVersion: string): Recallable =
  ## indexersList
  ## Lists all indexers available for an Azure Search service.
  ## https://msdn.microsoft.com/library/azure/dn946883.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568240 = newJObject()
  add(query_568240, "api-version", newJString(apiVersion))
  result = call_568239.call(nil, query_568240, nil, nil, nil)

var indexersList* = Call_IndexersList_568233(name: "indexersList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/indexers",
    validator: validate_IndexersList_568234, base: "", url: url_IndexersList_568235,
    schemes: {Scheme.Https})
type
  Call_IndexersCreateOrUpdate_568261 = ref object of OpenApiRestCall_567641
proc url_IndexersCreateOrUpdate_568263(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersCreateOrUpdate_568262(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Azure Search indexer or updates an indexer if it already exists.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946899.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexerName: JString (required)
  ##              : The name of the indexer to create or update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `indexerName` field"
  var valid_568264 = path.getOrDefault("indexerName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "indexerName", valid_568264
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
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568266 = header.getOrDefault("client-request-id")
  valid_568266 = validateParameter(valid_568266, JString, required = false,
                                 default = nil)
  if valid_568266 != nil:
    section.add "client-request-id", valid_568266
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

proc call*(call_568268: Call_IndexersCreateOrUpdate_568261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search indexer or updates an indexer if it already exists.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946899.aspx
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_IndexersCreateOrUpdate_568261; apiVersion: string;
          indexerName: string; indexer: JsonNode): Recallable =
  ## indexersCreateOrUpdate
  ## Creates a new Azure Search indexer or updates an indexer if it already exists.
  ## https://msdn.microsoft.com/library/azure/dn946899.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to create or update.
  ##   indexer: JObject (required)
  ##          : The definition of the indexer to create or update.
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  var body_568272 = newJObject()
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "indexerName", newJString(indexerName))
  if indexer != nil:
    body_568272 = indexer
  result = call_568269.call(path_568270, query_568271, nil, nil, body_568272)

var indexersCreateOrUpdate* = Call_IndexersCreateOrUpdate_568261(
    name: "indexersCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/indexers(\'{indexerName}\')",
    validator: validate_IndexersCreateOrUpdate_568262, base: "",
    url: url_IndexersCreateOrUpdate_568263, schemes: {Scheme.Https})
type
  Call_IndexersGet_568251 = ref object of OpenApiRestCall_567641
proc url_IndexersGet_568253(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersGet_568252(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves an indexer definition from Azure Search.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946874.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexerName: JString (required)
  ##              : The name of the indexer to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `indexerName` field"
  var valid_568254 = path.getOrDefault("indexerName")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "indexerName", valid_568254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568255 = query.getOrDefault("api-version")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "api-version", valid_568255
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568256 = header.getOrDefault("client-request-id")
  valid_568256 = validateParameter(valid_568256, JString, required = false,
                                 default = nil)
  if valid_568256 != nil:
    section.add "client-request-id", valid_568256
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568257: Call_IndexersGet_568251; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an indexer definition from Azure Search.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946874.aspx
  let valid = call_568257.validator(path, query, header, formData, body)
  let scheme = call_568257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568257.url(scheme.get, call_568257.host, call_568257.base,
                         call_568257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568257, url, valid)

proc call*(call_568258: Call_IndexersGet_568251; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersGet
  ## Retrieves an indexer definition from Azure Search.
  ## https://msdn.microsoft.com/library/azure/dn946874.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to retrieve.
  var path_568259 = newJObject()
  var query_568260 = newJObject()
  add(query_568260, "api-version", newJString(apiVersion))
  add(path_568259, "indexerName", newJString(indexerName))
  result = call_568258.call(path_568259, query_568260, nil, nil, nil)

var indexersGet* = Call_IndexersGet_568251(name: "indexersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local",
                                        route: "/indexers(\'{indexerName}\')",
                                        validator: validate_IndexersGet_568252,
                                        base: "", url: url_IndexersGet_568253,
                                        schemes: {Scheme.Https})
type
  Call_IndexersDelete_568273 = ref object of OpenApiRestCall_567641
proc url_IndexersDelete_568275(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersDelete_568274(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes an Azure Search indexer.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946898.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexerName: JString (required)
  ##              : The name of the indexer to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `indexerName` field"
  var valid_568276 = path.getOrDefault("indexerName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "indexerName", valid_568276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568277 = query.getOrDefault("api-version")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "api-version", valid_568277
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568278 = header.getOrDefault("client-request-id")
  valid_568278 = validateParameter(valid_568278, JString, required = false,
                                 default = nil)
  if valid_568278 != nil:
    section.add "client-request-id", valid_568278
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568279: Call_IndexersDelete_568273; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search indexer.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946898.aspx
  let valid = call_568279.validator(path, query, header, formData, body)
  let scheme = call_568279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568279.url(scheme.get, call_568279.host, call_568279.base,
                         call_568279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568279, url, valid)

proc call*(call_568280: Call_IndexersDelete_568273; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersDelete
  ## Deletes an Azure Search indexer.
  ## https://msdn.microsoft.com/library/azure/dn946898.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to delete.
  var path_568281 = newJObject()
  var query_568282 = newJObject()
  add(query_568282, "api-version", newJString(apiVersion))
  add(path_568281, "indexerName", newJString(indexerName))
  result = call_568280.call(path_568281, query_568282, nil, nil, nil)

var indexersDelete* = Call_IndexersDelete_568273(name: "indexersDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/indexers(\'{indexerName}\')", validator: validate_IndexersDelete_568274,
    base: "", url: url_IndexersDelete_568275, schemes: {Scheme.Https})
type
  Call_IndexersReset_568283 = ref object of OpenApiRestCall_567641
proc url_IndexersReset_568285(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersReset_568284(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets the change tracking state associated with an Azure Search indexer.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946897.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexerName: JString (required)
  ##              : The name of the indexer to reset.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `indexerName` field"
  var valid_568286 = path.getOrDefault("indexerName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "indexerName", valid_568286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568287 = query.getOrDefault("api-version")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "api-version", valid_568287
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568288 = header.getOrDefault("client-request-id")
  valid_568288 = validateParameter(valid_568288, JString, required = false,
                                 default = nil)
  if valid_568288 != nil:
    section.add "client-request-id", valid_568288
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568289: Call_IndexersReset_568283; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the change tracking state associated with an Azure Search indexer.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946897.aspx
  let valid = call_568289.validator(path, query, header, formData, body)
  let scheme = call_568289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568289.url(scheme.get, call_568289.host, call_568289.base,
                         call_568289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568289, url, valid)

proc call*(call_568290: Call_IndexersReset_568283; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersReset
  ## Resets the change tracking state associated with an Azure Search indexer.
  ## https://msdn.microsoft.com/library/azure/dn946897.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to reset.
  var path_568291 = newJObject()
  var query_568292 = newJObject()
  add(query_568292, "api-version", newJString(apiVersion))
  add(path_568291, "indexerName", newJString(indexerName))
  result = call_568290.call(path_568291, query_568292, nil, nil, nil)

var indexersReset* = Call_IndexersReset_568283(name: "indexersReset",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/indexers(\'{indexerName}\')/search.reset",
    validator: validate_IndexersReset_568284, base: "", url: url_IndexersReset_568285,
    schemes: {Scheme.Https})
type
  Call_IndexersRun_568293 = ref object of OpenApiRestCall_567641
proc url_IndexersRun_568295(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersRun_568294(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Runs an Azure Search indexer on-demand.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946885.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexerName: JString (required)
  ##              : The name of the indexer to run.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `indexerName` field"
  var valid_568296 = path.getOrDefault("indexerName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "indexerName", valid_568296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568297 = query.getOrDefault("api-version")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "api-version", valid_568297
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568298 = header.getOrDefault("client-request-id")
  valid_568298 = validateParameter(valid_568298, JString, required = false,
                                 default = nil)
  if valid_568298 != nil:
    section.add "client-request-id", valid_568298
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568299: Call_IndexersRun_568293; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs an Azure Search indexer on-demand.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946885.aspx
  let valid = call_568299.validator(path, query, header, formData, body)
  let scheme = call_568299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568299.url(scheme.get, call_568299.host, call_568299.base,
                         call_568299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568299, url, valid)

proc call*(call_568300: Call_IndexersRun_568293; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersRun
  ## Runs an Azure Search indexer on-demand.
  ## https://msdn.microsoft.com/library/azure/dn946885.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to run.
  var path_568301 = newJObject()
  var query_568302 = newJObject()
  add(query_568302, "api-version", newJString(apiVersion))
  add(path_568301, "indexerName", newJString(indexerName))
  result = call_568300.call(path_568301, query_568302, nil, nil, nil)

var indexersRun* = Call_IndexersRun_568293(name: "indexersRun",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local", route: "/indexers(\'{indexerName}\')/search.run",
                                        validator: validate_IndexersRun_568294,
                                        base: "", url: url_IndexersRun_568295,
                                        schemes: {Scheme.Https})
type
  Call_IndexersGetStatus_568303 = ref object of OpenApiRestCall_567641
proc url_IndexersGetStatus_568305(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersGetStatus_568304(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns the current status and execution history of an indexer.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946884.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexerName: JString (required)
  ##              : The name of the indexer for which to retrieve status.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `indexerName` field"
  var valid_568306 = path.getOrDefault("indexerName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "indexerName", valid_568306
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568307 = query.getOrDefault("api-version")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "api-version", valid_568307
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568308 = header.getOrDefault("client-request-id")
  valid_568308 = validateParameter(valid_568308, JString, required = false,
                                 default = nil)
  if valid_568308 != nil:
    section.add "client-request-id", valid_568308
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568309: Call_IndexersGetStatus_568303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the current status and execution history of an indexer.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946884.aspx
  let valid = call_568309.validator(path, query, header, formData, body)
  let scheme = call_568309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568309.url(scheme.get, call_568309.host, call_568309.base,
                         call_568309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568309, url, valid)

proc call*(call_568310: Call_IndexersGetStatus_568303; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersGetStatus
  ## Returns the current status and execution history of an indexer.
  ## https://msdn.microsoft.com/library/azure/dn946884.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer for which to retrieve status.
  var path_568311 = newJObject()
  var query_568312 = newJObject()
  add(query_568312, "api-version", newJString(apiVersion))
  add(path_568311, "indexerName", newJString(indexerName))
  result = call_568310.call(path_568311, query_568312, nil, nil, nil)

var indexersGetStatus* = Call_IndexersGetStatus_568303(name: "indexersGetStatus",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/indexers(\'{indexerName}\')/search.status",
    validator: validate_IndexersGetStatus_568304, base: "",
    url: url_IndexersGetStatus_568305, schemes: {Scheme.Https})
type
  Call_IndexesCreate_568323 = ref object of OpenApiRestCall_567641
proc url_IndexesCreate_568325(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexesCreate_568324(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Azure Search index.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn798941.aspx
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
  var valid_568326 = query.getOrDefault("api-version")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "api-version", valid_568326
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568327 = header.getOrDefault("client-request-id")
  valid_568327 = validateParameter(valid_568327, JString, required = false,
                                 default = nil)
  if valid_568327 != nil:
    section.add "client-request-id", valid_568327
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

proc call*(call_568329: Call_IndexesCreate_568323; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search index.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn798941.aspx
  let valid = call_568329.validator(path, query, header, formData, body)
  let scheme = call_568329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568329.url(scheme.get, call_568329.host, call_568329.base,
                         call_568329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568329, url, valid)

proc call*(call_568330: Call_IndexesCreate_568323; apiVersion: string;
          index: JsonNode): Recallable =
  ## indexesCreate
  ## Creates a new Azure Search index.
  ## https://msdn.microsoft.com/library/azure/dn798941.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   index: JObject (required)
  ##        : The definition of the index to create.
  var query_568331 = newJObject()
  var body_568332 = newJObject()
  add(query_568331, "api-version", newJString(apiVersion))
  if index != nil:
    body_568332 = index
  result = call_568330.call(nil, query_568331, nil, nil, body_568332)

var indexesCreate* = Call_IndexesCreate_568323(name: "indexesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/indexes",
    validator: validate_IndexesCreate_568324, base: "", url: url_IndexesCreate_568325,
    schemes: {Scheme.Https})
type
  Call_IndexesList_568313 = ref object of OpenApiRestCall_567641
proc url_IndexesList_568315(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexesList_568314(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all indexes available for an Azure Search service.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn798923.aspx
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
  var valid_568317 = query.getOrDefault("api-version")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "api-version", valid_568317
  var valid_568318 = query.getOrDefault("$select")
  valid_568318 = validateParameter(valid_568318, JString, required = false,
                                 default = nil)
  if valid_568318 != nil:
    section.add "$select", valid_568318
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568319 = header.getOrDefault("client-request-id")
  valid_568319 = validateParameter(valid_568319, JString, required = false,
                                 default = nil)
  if valid_568319 != nil:
    section.add "client-request-id", valid_568319
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568320: Call_IndexesList_568313; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all indexes available for an Azure Search service.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn798923.aspx
  let valid = call_568320.validator(path, query, header, formData, body)
  let scheme = call_568320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568320.url(scheme.get, call_568320.host, call_568320.base,
                         call_568320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568320, url, valid)

proc call*(call_568321: Call_IndexesList_568313; apiVersion: string;
          Select: string = ""): Recallable =
  ## indexesList
  ## Lists all indexes available for an Azure Search service.
  ## https://msdn.microsoft.com/library/azure/dn798923.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : Selects which properties of the index definitions to retrieve. Specified as a comma-separated list of JSON property names, or '*' for all properties. The default is all properties.
  var query_568322 = newJObject()
  add(query_568322, "api-version", newJString(apiVersion))
  add(query_568322, "$select", newJString(Select))
  result = call_568321.call(nil, query_568322, nil, nil, nil)

var indexesList* = Call_IndexesList_568313(name: "indexesList",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/indexes",
                                        validator: validate_IndexesList_568314,
                                        base: "", url: url_IndexesList_568315,
                                        schemes: {Scheme.Https})
type
  Call_IndexesCreateOrUpdate_568343 = ref object of OpenApiRestCall_567641
proc url_IndexesCreateOrUpdate_568345(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesCreateOrUpdate_568344(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Azure Search index or updates an index if it already exists.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn800964.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexName: JString (required)
  ##            : The definition of the index to create or update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `indexName` field"
  var valid_568346 = path.getOrDefault("indexName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "indexName", valid_568346
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
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568348 = header.getOrDefault("client-request-id")
  valid_568348 = validateParameter(valid_568348, JString, required = false,
                                 default = nil)
  if valid_568348 != nil:
    section.add "client-request-id", valid_568348
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

proc call*(call_568350: Call_IndexesCreateOrUpdate_568343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search index or updates an index if it already exists.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn800964.aspx
  let valid = call_568350.validator(path, query, header, formData, body)
  let scheme = call_568350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568350.url(scheme.get, call_568350.host, call_568350.base,
                         call_568350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568350, url, valid)

proc call*(call_568351: Call_IndexesCreateOrUpdate_568343; indexName: string;
          apiVersion: string; index: JsonNode): Recallable =
  ## indexesCreateOrUpdate
  ## Creates a new Azure Search index or updates an index if it already exists.
  ## https://msdn.microsoft.com/library/azure/dn800964.aspx
  ##   indexName: string (required)
  ##            : The definition of the index to create or update.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   index: JObject (required)
  ##        : The definition of the index to create or update.
  var path_568352 = newJObject()
  var query_568353 = newJObject()
  var body_568354 = newJObject()
  add(path_568352, "indexName", newJString(indexName))
  add(query_568353, "api-version", newJString(apiVersion))
  if index != nil:
    body_568354 = index
  result = call_568351.call(path_568352, query_568353, nil, nil, body_568354)

var indexesCreateOrUpdate* = Call_IndexesCreateOrUpdate_568343(
    name: "indexesCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/indexes(\'{indexName}\')", validator: validate_IndexesCreateOrUpdate_568344,
    base: "", url: url_IndexesCreateOrUpdate_568345, schemes: {Scheme.Https})
type
  Call_IndexesGet_568333 = ref object of OpenApiRestCall_567641
proc url_IndexesGet_568335(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_IndexesGet_568334(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves an index definition from Azure Search.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn798939.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexName: JString (required)
  ##            : The name of the index to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `indexName` field"
  var valid_568336 = path.getOrDefault("indexName")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "indexName", valid_568336
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
  ##                    : Tracking ID sent with the request to help with debugging.
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

proc call*(call_568339: Call_IndexesGet_568333; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an index definition from Azure Search.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn798939.aspx
  let valid = call_568339.validator(path, query, header, formData, body)
  let scheme = call_568339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568339.url(scheme.get, call_568339.host, call_568339.base,
                         call_568339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568339, url, valid)

proc call*(call_568340: Call_IndexesGet_568333; indexName: string; apiVersion: string): Recallable =
  ## indexesGet
  ## Retrieves an index definition from Azure Search.
  ## https://msdn.microsoft.com/library/azure/dn798939.aspx
  ##   indexName: string (required)
  ##            : The name of the index to retrieve.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_568341 = newJObject()
  var query_568342 = newJObject()
  add(path_568341, "indexName", newJString(indexName))
  add(query_568342, "api-version", newJString(apiVersion))
  result = call_568340.call(path_568341, query_568342, nil, nil, nil)

var indexesGet* = Call_IndexesGet_568333(name: "indexesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local",
                                      route: "/indexes(\'{indexName}\')",
                                      validator: validate_IndexesGet_568334,
                                      base: "", url: url_IndexesGet_568335,
                                      schemes: {Scheme.Https})
type
  Call_IndexesDelete_568355 = ref object of OpenApiRestCall_567641
proc url_IndexesDelete_568357(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesDelete_568356(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an Azure Search index and all the documents it contains.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn798926.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexName: JString (required)
  ##            : The name of the index to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `indexName` field"
  var valid_568358 = path.getOrDefault("indexName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "indexName", valid_568358
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
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568360 = header.getOrDefault("client-request-id")
  valid_568360 = validateParameter(valid_568360, JString, required = false,
                                 default = nil)
  if valid_568360 != nil:
    section.add "client-request-id", valid_568360
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568361: Call_IndexesDelete_568355; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search index and all the documents it contains.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn798926.aspx
  let valid = call_568361.validator(path, query, header, formData, body)
  let scheme = call_568361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568361.url(scheme.get, call_568361.host, call_568361.base,
                         call_568361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568361, url, valid)

proc call*(call_568362: Call_IndexesDelete_568355; indexName: string;
          apiVersion: string): Recallable =
  ## indexesDelete
  ## Deletes an Azure Search index and all the documents it contains.
  ## https://msdn.microsoft.com/library/azure/dn798926.aspx
  ##   indexName: string (required)
  ##            : The name of the index to delete.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_568363 = newJObject()
  var query_568364 = newJObject()
  add(path_568363, "indexName", newJString(indexName))
  add(query_568364, "api-version", newJString(apiVersion))
  result = call_568362.call(path_568363, query_568364, nil, nil, nil)

var indexesDelete* = Call_IndexesDelete_568355(name: "indexesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/indexes(\'{indexName}\')", validator: validate_IndexesDelete_568356,
    base: "", url: url_IndexesDelete_568357, schemes: {Scheme.Https})
type
  Call_IndexesGetStatistics_568365 = ref object of OpenApiRestCall_567641
proc url_IndexesGetStatistics_568367(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesGetStatistics_568366(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns statistics for the given index, including a document count and storage usage.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn798942.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   indexName: JString (required)
  ##            : The name of the index for which to retrieve statistics.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `indexName` field"
  var valid_568368 = path.getOrDefault("indexName")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "indexName", valid_568368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568369 = query.getOrDefault("api-version")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "api-version", valid_568369
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_568370 = header.getOrDefault("client-request-id")
  valid_568370 = validateParameter(valid_568370, JString, required = false,
                                 default = nil)
  if valid_568370 != nil:
    section.add "client-request-id", valid_568370
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568371: Call_IndexesGetStatistics_568365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns statistics for the given index, including a document count and storage usage.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn798942.aspx
  let valid = call_568371.validator(path, query, header, formData, body)
  let scheme = call_568371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568371.url(scheme.get, call_568371.host, call_568371.base,
                         call_568371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568371, url, valid)

proc call*(call_568372: Call_IndexesGetStatistics_568365; indexName: string;
          apiVersion: string): Recallable =
  ## indexesGetStatistics
  ## Returns statistics for the given index, including a document count and storage usage.
  ## https://msdn.microsoft.com/library/azure/dn798942.aspx
  ##   indexName: string (required)
  ##            : The name of the index for which to retrieve statistics.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_568373 = newJObject()
  var query_568374 = newJObject()
  add(path_568373, "indexName", newJString(indexName))
  add(query_568374, "api-version", newJString(apiVersion))
  result = call_568372.call(path_568373, query_568374, nil, nil, nil)

var indexesGetStatistics* = Call_IndexesGetStatistics_568365(
    name: "indexesGetStatistics", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/indexes(\'{indexName}\')/search.stats",
    validator: validate_IndexesGetStatistics_568366, base: "",
    url: url_IndexesGetStatistics_568367, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
