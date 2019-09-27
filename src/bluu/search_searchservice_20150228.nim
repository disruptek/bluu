
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  Call_DataSourcesCreate_593927 = ref object of OpenApiRestCall_593408
proc url_DataSourcesCreate_593929(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DataSourcesCreate_593928(path: JsonNode; query: JsonNode;
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
  var valid_593947 = query.getOrDefault("api-version")
  valid_593947 = validateParameter(valid_593947, JString, required = true,
                                 default = nil)
  if valid_593947 != nil:
    section.add "api-version", valid_593947
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_593948 = header.getOrDefault("client-request-id")
  valid_593948 = validateParameter(valid_593948, JString, required = false,
                                 default = nil)
  if valid_593948 != nil:
    section.add "client-request-id", valid_593948
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

proc call*(call_593950: Call_DataSourcesCreate_593927; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search datasource.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946876.aspx
  let valid = call_593950.validator(path, query, header, formData, body)
  let scheme = call_593950.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593950.url(scheme.get, call_593950.host, call_593950.base,
                         call_593950.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593950, url, valid)

proc call*(call_593951: Call_DataSourcesCreate_593927; apiVersion: string;
          dataSource: JsonNode): Recallable =
  ## dataSourcesCreate
  ## Creates a new Azure Search datasource.
  ## https://msdn.microsoft.com/library/azure/dn946876.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSource: JObject (required)
  ##             : The definition of the datasource to create.
  var query_593952 = newJObject()
  var body_593953 = newJObject()
  add(query_593952, "api-version", newJString(apiVersion))
  if dataSource != nil:
    body_593953 = dataSource
  result = call_593951.call(nil, query_593952, nil, nil, body_593953)

var dataSourcesCreate* = Call_DataSourcesCreate_593927(name: "dataSourcesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/datasources",
    validator: validate_DataSourcesCreate_593928, base: "",
    url: url_DataSourcesCreate_593929, schemes: {Scheme.Https})
type
  Call_DataSourcesList_593630 = ref object of OpenApiRestCall_593408
proc url_DataSourcesList_593632(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DataSourcesList_593631(path: JsonNode; query: JsonNode;
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
  var valid_593791 = query.getOrDefault("api-version")
  valid_593791 = validateParameter(valid_593791, JString, required = true,
                                 default = nil)
  if valid_593791 != nil:
    section.add "api-version", valid_593791
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_593792 = header.getOrDefault("client-request-id")
  valid_593792 = validateParameter(valid_593792, JString, required = false,
                                 default = nil)
  if valid_593792 != nil:
    section.add "client-request-id", valid_593792
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593815: Call_DataSourcesList_593630; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all datasources available for an Azure Search service.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946878.aspx
  let valid = call_593815.validator(path, query, header, formData, body)
  let scheme = call_593815.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593815.url(scheme.get, call_593815.host, call_593815.base,
                         call_593815.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593815, url, valid)

proc call*(call_593886: Call_DataSourcesList_593630; apiVersion: string): Recallable =
  ## dataSourcesList
  ## Lists all datasources available for an Azure Search service.
  ## https://msdn.microsoft.com/library/azure/dn946878.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_593887 = newJObject()
  add(query_593887, "api-version", newJString(apiVersion))
  result = call_593886.call(nil, query_593887, nil, nil, nil)

var dataSourcesList* = Call_DataSourcesList_593630(name: "dataSourcesList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/datasources",
    validator: validate_DataSourcesList_593631, base: "", url: url_DataSourcesList_593632,
    schemes: {Scheme.Https})
type
  Call_DataSourcesCreateOrUpdate_593978 = ref object of OpenApiRestCall_593408
proc url_DataSourcesCreateOrUpdate_593980(protocol: Scheme; host: string;
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

proc validate_DataSourcesCreateOrUpdate_593979(path: JsonNode; query: JsonNode;
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
  var valid_593981 = path.getOrDefault("dataSourceName")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "dataSourceName", valid_593981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593982 = query.getOrDefault("api-version")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "api-version", valid_593982
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_593983 = header.getOrDefault("client-request-id")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "client-request-id", valid_593983
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

proc call*(call_593985: Call_DataSourcesCreateOrUpdate_593978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search datasource or updates a datasource if it already exists.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946900.aspx
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_DataSourcesCreateOrUpdate_593978; apiVersion: string;
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
  var path_593987 = newJObject()
  var query_593988 = newJObject()
  var body_593989 = newJObject()
  add(query_593988, "api-version", newJString(apiVersion))
  add(path_593987, "dataSourceName", newJString(dataSourceName))
  if dataSource != nil:
    body_593989 = dataSource
  result = call_593986.call(path_593987, query_593988, nil, nil, body_593989)

var dataSourcesCreateOrUpdate* = Call_DataSourcesCreateOrUpdate_593978(
    name: "dataSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesCreateOrUpdate_593979, base: "",
    url: url_DataSourcesCreateOrUpdate_593980, schemes: {Scheme.Https})
type
  Call_DataSourcesGet_593954 = ref object of OpenApiRestCall_593408
proc url_DataSourcesGet_593956(protocol: Scheme; host: string; base: string;
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

proc validate_DataSourcesGet_593955(path: JsonNode; query: JsonNode;
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
  var valid_593971 = path.getOrDefault("dataSourceName")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "dataSourceName", valid_593971
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593972 = query.getOrDefault("api-version")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "api-version", valid_593972
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_593973 = header.getOrDefault("client-request-id")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "client-request-id", valid_593973
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593974: Call_DataSourcesGet_593954; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a datasource definition from Azure Search.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946893.aspx
  let valid = call_593974.validator(path, query, header, formData, body)
  let scheme = call_593974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593974.url(scheme.get, call_593974.host, call_593974.base,
                         call_593974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593974, url, valid)

proc call*(call_593975: Call_DataSourcesGet_593954; apiVersion: string;
          dataSourceName: string): Recallable =
  ## dataSourcesGet
  ## Retrieves a datasource definition from Azure Search.
  ## https://msdn.microsoft.com/library/azure/dn946893.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to retrieve.
  var path_593976 = newJObject()
  var query_593977 = newJObject()
  add(query_593977, "api-version", newJString(apiVersion))
  add(path_593976, "dataSourceName", newJString(dataSourceName))
  result = call_593975.call(path_593976, query_593977, nil, nil, nil)

var dataSourcesGet* = Call_DataSourcesGet_593954(name: "dataSourcesGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesGet_593955, base: "", url: url_DataSourcesGet_593956,
    schemes: {Scheme.Https})
type
  Call_DataSourcesDelete_593990 = ref object of OpenApiRestCall_593408
proc url_DataSourcesDelete_593992(protocol: Scheme; host: string; base: string;
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

proc validate_DataSourcesDelete_593991(path: JsonNode; query: JsonNode;
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
  var valid_593993 = path.getOrDefault("dataSourceName")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "dataSourceName", valid_593993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593994 = query.getOrDefault("api-version")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "api-version", valid_593994
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_593995 = header.getOrDefault("client-request-id")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "client-request-id", valid_593995
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593996: Call_DataSourcesDelete_593990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search datasource.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946881.aspx
  let valid = call_593996.validator(path, query, header, formData, body)
  let scheme = call_593996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593996.url(scheme.get, call_593996.host, call_593996.base,
                         call_593996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593996, url, valid)

proc call*(call_593997: Call_DataSourcesDelete_593990; apiVersion: string;
          dataSourceName: string): Recallable =
  ## dataSourcesDelete
  ## Deletes an Azure Search datasource.
  ## https://msdn.microsoft.com/library/azure/dn946881.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   dataSourceName: string (required)
  ##                 : The name of the datasource to delete.
  var path_593998 = newJObject()
  var query_593999 = newJObject()
  add(query_593999, "api-version", newJString(apiVersion))
  add(path_593998, "dataSourceName", newJString(dataSourceName))
  result = call_593997.call(path_593998, query_593999, nil, nil, nil)

var dataSourcesDelete* = Call_DataSourcesDelete_593990(name: "dataSourcesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/datasources(\'{dataSourceName}\')",
    validator: validate_DataSourcesDelete_593991, base: "",
    url: url_DataSourcesDelete_593992, schemes: {Scheme.Https})
type
  Call_IndexersCreate_594008 = ref object of OpenApiRestCall_593408
proc url_IndexersCreate_594010(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexersCreate_594009(path: JsonNode; query: JsonNode;
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
  var valid_594011 = query.getOrDefault("api-version")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "api-version", valid_594011
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594012 = header.getOrDefault("client-request-id")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "client-request-id", valid_594012
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

proc call*(call_594014: Call_IndexersCreate_594008; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search indexer.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946899.aspx
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_IndexersCreate_594008; apiVersion: string;
          indexer: JsonNode): Recallable =
  ## indexersCreate
  ## Creates a new Azure Search indexer.
  ## https://msdn.microsoft.com/library/azure/dn946899.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexer: JObject (required)
  ##          : The definition of the indexer to create.
  var query_594016 = newJObject()
  var body_594017 = newJObject()
  add(query_594016, "api-version", newJString(apiVersion))
  if indexer != nil:
    body_594017 = indexer
  result = call_594015.call(nil, query_594016, nil, nil, body_594017)

var indexersCreate* = Call_IndexersCreate_594008(name: "indexersCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/indexers",
    validator: validate_IndexersCreate_594009, base: "", url: url_IndexersCreate_594010,
    schemes: {Scheme.Https})
type
  Call_IndexersList_594000 = ref object of OpenApiRestCall_593408
proc url_IndexersList_594002(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexersList_594001(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594003 = query.getOrDefault("api-version")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "api-version", valid_594003
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
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

proc call*(call_594005: Call_IndexersList_594000; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all indexers available for an Azure Search service.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946883.aspx
  let valid = call_594005.validator(path, query, header, formData, body)
  let scheme = call_594005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594005.url(scheme.get, call_594005.host, call_594005.base,
                         call_594005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594005, url, valid)

proc call*(call_594006: Call_IndexersList_594000; apiVersion: string): Recallable =
  ## indexersList
  ## Lists all indexers available for an Azure Search service.
  ## https://msdn.microsoft.com/library/azure/dn946883.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_594007 = newJObject()
  add(query_594007, "api-version", newJString(apiVersion))
  result = call_594006.call(nil, query_594007, nil, nil, nil)

var indexersList* = Call_IndexersList_594000(name: "indexersList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/indexers",
    validator: validate_IndexersList_594001, base: "", url: url_IndexersList_594002,
    schemes: {Scheme.Https})
type
  Call_IndexersCreateOrUpdate_594028 = ref object of OpenApiRestCall_593408
proc url_IndexersCreateOrUpdate_594030(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersCreateOrUpdate_594029(path: JsonNode; query: JsonNode;
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
  var valid_594031 = path.getOrDefault("indexerName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "indexerName", valid_594031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594032 = query.getOrDefault("api-version")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "api-version", valid_594032
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594033 = header.getOrDefault("client-request-id")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "client-request-id", valid_594033
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

proc call*(call_594035: Call_IndexersCreateOrUpdate_594028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search indexer or updates an indexer if it already exists.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946899.aspx
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_IndexersCreateOrUpdate_594028; apiVersion: string;
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
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  var body_594039 = newJObject()
  add(query_594038, "api-version", newJString(apiVersion))
  add(path_594037, "indexerName", newJString(indexerName))
  if indexer != nil:
    body_594039 = indexer
  result = call_594036.call(path_594037, query_594038, nil, nil, body_594039)

var indexersCreateOrUpdate* = Call_IndexersCreateOrUpdate_594028(
    name: "indexersCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/indexers(\'{indexerName}\')",
    validator: validate_IndexersCreateOrUpdate_594029, base: "",
    url: url_IndexersCreateOrUpdate_594030, schemes: {Scheme.Https})
type
  Call_IndexersGet_594018 = ref object of OpenApiRestCall_593408
proc url_IndexersGet_594020(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersGet_594019(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594021 = path.getOrDefault("indexerName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "indexerName", valid_594021
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594022 = query.getOrDefault("api-version")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "api-version", valid_594022
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594023 = header.getOrDefault("client-request-id")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "client-request-id", valid_594023
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594024: Call_IndexersGet_594018; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an indexer definition from Azure Search.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946874.aspx
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_IndexersGet_594018; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersGet
  ## Retrieves an indexer definition from Azure Search.
  ## https://msdn.microsoft.com/library/azure/dn946874.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to retrieve.
  var path_594026 = newJObject()
  var query_594027 = newJObject()
  add(query_594027, "api-version", newJString(apiVersion))
  add(path_594026, "indexerName", newJString(indexerName))
  result = call_594025.call(path_594026, query_594027, nil, nil, nil)

var indexersGet* = Call_IndexersGet_594018(name: "indexersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local",
                                        route: "/indexers(\'{indexerName}\')",
                                        validator: validate_IndexersGet_594019,
                                        base: "", url: url_IndexersGet_594020,
                                        schemes: {Scheme.Https})
type
  Call_IndexersDelete_594040 = ref object of OpenApiRestCall_593408
proc url_IndexersDelete_594042(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersDelete_594041(path: JsonNode; query: JsonNode;
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
  var valid_594043 = path.getOrDefault("indexerName")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "indexerName", valid_594043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594044 = query.getOrDefault("api-version")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "api-version", valid_594044
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594045 = header.getOrDefault("client-request-id")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "client-request-id", valid_594045
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594046: Call_IndexersDelete_594040; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search indexer.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946898.aspx
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_IndexersDelete_594040; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersDelete
  ## Deletes an Azure Search indexer.
  ## https://msdn.microsoft.com/library/azure/dn946898.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to delete.
  var path_594048 = newJObject()
  var query_594049 = newJObject()
  add(query_594049, "api-version", newJString(apiVersion))
  add(path_594048, "indexerName", newJString(indexerName))
  result = call_594047.call(path_594048, query_594049, nil, nil, nil)

var indexersDelete* = Call_IndexersDelete_594040(name: "indexersDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/indexers(\'{indexerName}\')", validator: validate_IndexersDelete_594041,
    base: "", url: url_IndexersDelete_594042, schemes: {Scheme.Https})
type
  Call_IndexersReset_594050 = ref object of OpenApiRestCall_593408
proc url_IndexersReset_594052(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersReset_594051(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594053 = path.getOrDefault("indexerName")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "indexerName", valid_594053
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594054 = query.getOrDefault("api-version")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "api-version", valid_594054
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594055 = header.getOrDefault("client-request-id")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "client-request-id", valid_594055
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594056: Call_IndexersReset_594050; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the change tracking state associated with an Azure Search indexer.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946897.aspx
  let valid = call_594056.validator(path, query, header, formData, body)
  let scheme = call_594056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594056.url(scheme.get, call_594056.host, call_594056.base,
                         call_594056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594056, url, valid)

proc call*(call_594057: Call_IndexersReset_594050; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersReset
  ## Resets the change tracking state associated with an Azure Search indexer.
  ## https://msdn.microsoft.com/library/azure/dn946897.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to reset.
  var path_594058 = newJObject()
  var query_594059 = newJObject()
  add(query_594059, "api-version", newJString(apiVersion))
  add(path_594058, "indexerName", newJString(indexerName))
  result = call_594057.call(path_594058, query_594059, nil, nil, nil)

var indexersReset* = Call_IndexersReset_594050(name: "indexersReset",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/indexers(\'{indexerName}\')/search.reset",
    validator: validate_IndexersReset_594051, base: "", url: url_IndexersReset_594052,
    schemes: {Scheme.Https})
type
  Call_IndexersRun_594060 = ref object of OpenApiRestCall_593408
proc url_IndexersRun_594062(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersRun_594061(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594063 = path.getOrDefault("indexerName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "indexerName", valid_594063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594064 = query.getOrDefault("api-version")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "api-version", valid_594064
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594065 = header.getOrDefault("client-request-id")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "client-request-id", valid_594065
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594066: Call_IndexersRun_594060; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs an Azure Search indexer on-demand.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946885.aspx
  let valid = call_594066.validator(path, query, header, formData, body)
  let scheme = call_594066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594066.url(scheme.get, call_594066.host, call_594066.base,
                         call_594066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594066, url, valid)

proc call*(call_594067: Call_IndexersRun_594060; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersRun
  ## Runs an Azure Search indexer on-demand.
  ## https://msdn.microsoft.com/library/azure/dn946885.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer to run.
  var path_594068 = newJObject()
  var query_594069 = newJObject()
  add(query_594069, "api-version", newJString(apiVersion))
  add(path_594068, "indexerName", newJString(indexerName))
  result = call_594067.call(path_594068, query_594069, nil, nil, nil)

var indexersRun* = Call_IndexersRun_594060(name: "indexersRun",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local", route: "/indexers(\'{indexerName}\')/search.run",
                                        validator: validate_IndexersRun_594061,
                                        base: "", url: url_IndexersRun_594062,
                                        schemes: {Scheme.Https})
type
  Call_IndexersGetStatus_594070 = ref object of OpenApiRestCall_593408
proc url_IndexersGetStatus_594072(protocol: Scheme; host: string; base: string;
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

proc validate_IndexersGetStatus_594071(path: JsonNode; query: JsonNode;
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
  var valid_594073 = path.getOrDefault("indexerName")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "indexerName", valid_594073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594074 = query.getOrDefault("api-version")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "api-version", valid_594074
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594075 = header.getOrDefault("client-request-id")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "client-request-id", valid_594075
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594076: Call_IndexersGetStatus_594070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the current status and execution history of an indexer.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn946884.aspx
  let valid = call_594076.validator(path, query, header, formData, body)
  let scheme = call_594076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594076.url(scheme.get, call_594076.host, call_594076.base,
                         call_594076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594076, url, valid)

proc call*(call_594077: Call_IndexersGetStatus_594070; apiVersion: string;
          indexerName: string): Recallable =
  ## indexersGetStatus
  ## Returns the current status and execution history of an indexer.
  ## https://msdn.microsoft.com/library/azure/dn946884.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   indexerName: string (required)
  ##              : The name of the indexer for which to retrieve status.
  var path_594078 = newJObject()
  var query_594079 = newJObject()
  add(query_594079, "api-version", newJString(apiVersion))
  add(path_594078, "indexerName", newJString(indexerName))
  result = call_594077.call(path_594078, query_594079, nil, nil, nil)

var indexersGetStatus* = Call_IndexersGetStatus_594070(name: "indexersGetStatus",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/indexers(\'{indexerName}\')/search.status",
    validator: validate_IndexersGetStatus_594071, base: "",
    url: url_IndexersGetStatus_594072, schemes: {Scheme.Https})
type
  Call_IndexesCreate_594090 = ref object of OpenApiRestCall_593408
proc url_IndexesCreate_594092(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexesCreate_594091(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594093 = query.getOrDefault("api-version")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "api-version", valid_594093
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594094 = header.getOrDefault("client-request-id")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "client-request-id", valid_594094
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

proc call*(call_594096: Call_IndexesCreate_594090; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search index.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn798941.aspx
  let valid = call_594096.validator(path, query, header, formData, body)
  let scheme = call_594096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594096.url(scheme.get, call_594096.host, call_594096.base,
                         call_594096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594096, url, valid)

proc call*(call_594097: Call_IndexesCreate_594090; apiVersion: string;
          index: JsonNode): Recallable =
  ## indexesCreate
  ## Creates a new Azure Search index.
  ## https://msdn.microsoft.com/library/azure/dn798941.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   index: JObject (required)
  ##        : The definition of the index to create.
  var query_594098 = newJObject()
  var body_594099 = newJObject()
  add(query_594098, "api-version", newJString(apiVersion))
  if index != nil:
    body_594099 = index
  result = call_594097.call(nil, query_594098, nil, nil, body_594099)

var indexesCreate* = Call_IndexesCreate_594090(name: "indexesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/indexes",
    validator: validate_IndexesCreate_594091, base: "", url: url_IndexesCreate_594092,
    schemes: {Scheme.Https})
type
  Call_IndexesList_594080 = ref object of OpenApiRestCall_593408
proc url_IndexesList_594082(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IndexesList_594081(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594084 = query.getOrDefault("api-version")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "api-version", valid_594084
  var valid_594085 = query.getOrDefault("$select")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "$select", valid_594085
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594086 = header.getOrDefault("client-request-id")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "client-request-id", valid_594086
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594087: Call_IndexesList_594080; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all indexes available for an Azure Search service.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn798923.aspx
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_IndexesList_594080; apiVersion: string;
          Select: string = ""): Recallable =
  ## indexesList
  ## Lists all indexes available for an Azure Search service.
  ## https://msdn.microsoft.com/library/azure/dn798923.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : Selects which properties of the index definitions to retrieve. Specified as a comma-separated list of JSON property names, or '*' for all properties. The default is all properties.
  var query_594089 = newJObject()
  add(query_594089, "api-version", newJString(apiVersion))
  add(query_594089, "$select", newJString(Select))
  result = call_594088.call(nil, query_594089, nil, nil, nil)

var indexesList* = Call_IndexesList_594080(name: "indexesList",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/indexes",
                                        validator: validate_IndexesList_594081,
                                        base: "", url: url_IndexesList_594082,
                                        schemes: {Scheme.Https})
type
  Call_IndexesCreateOrUpdate_594110 = ref object of OpenApiRestCall_593408
proc url_IndexesCreateOrUpdate_594112(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesCreateOrUpdate_594111(path: JsonNode; query: JsonNode;
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
  var valid_594113 = path.getOrDefault("indexName")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "indexName", valid_594113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594114 = query.getOrDefault("api-version")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "api-version", valid_594114
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594115 = header.getOrDefault("client-request-id")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "client-request-id", valid_594115
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

proc call*(call_594117: Call_IndexesCreateOrUpdate_594110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Azure Search index or updates an index if it already exists.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn800964.aspx
  let valid = call_594117.validator(path, query, header, formData, body)
  let scheme = call_594117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594117.url(scheme.get, call_594117.host, call_594117.base,
                         call_594117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594117, url, valid)

proc call*(call_594118: Call_IndexesCreateOrUpdate_594110; indexName: string;
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
  var path_594119 = newJObject()
  var query_594120 = newJObject()
  var body_594121 = newJObject()
  add(path_594119, "indexName", newJString(indexName))
  add(query_594120, "api-version", newJString(apiVersion))
  if index != nil:
    body_594121 = index
  result = call_594118.call(path_594119, query_594120, nil, nil, body_594121)

var indexesCreateOrUpdate* = Call_IndexesCreateOrUpdate_594110(
    name: "indexesCreateOrUpdate", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/indexes(\'{indexName}\')", validator: validate_IndexesCreateOrUpdate_594111,
    base: "", url: url_IndexesCreateOrUpdate_594112, schemes: {Scheme.Https})
type
  Call_IndexesGet_594100 = ref object of OpenApiRestCall_593408
proc url_IndexesGet_594102(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_IndexesGet_594101(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594103 = path.getOrDefault("indexName")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "indexName", valid_594103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594104 = query.getOrDefault("api-version")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "api-version", valid_594104
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594105 = header.getOrDefault("client-request-id")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "client-request-id", valid_594105
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594106: Call_IndexesGet_594100; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an index definition from Azure Search.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn798939.aspx
  let valid = call_594106.validator(path, query, header, formData, body)
  let scheme = call_594106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594106.url(scheme.get, call_594106.host, call_594106.base,
                         call_594106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594106, url, valid)

proc call*(call_594107: Call_IndexesGet_594100; indexName: string; apiVersion: string): Recallable =
  ## indexesGet
  ## Retrieves an index definition from Azure Search.
  ## https://msdn.microsoft.com/library/azure/dn798939.aspx
  ##   indexName: string (required)
  ##            : The name of the index to retrieve.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_594108 = newJObject()
  var query_594109 = newJObject()
  add(path_594108, "indexName", newJString(indexName))
  add(query_594109, "api-version", newJString(apiVersion))
  result = call_594107.call(path_594108, query_594109, nil, nil, nil)

var indexesGet* = Call_IndexesGet_594100(name: "indexesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local",
                                      route: "/indexes(\'{indexName}\')",
                                      validator: validate_IndexesGet_594101,
                                      base: "", url: url_IndexesGet_594102,
                                      schemes: {Scheme.Https})
type
  Call_IndexesDelete_594122 = ref object of OpenApiRestCall_593408
proc url_IndexesDelete_594124(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesDelete_594123(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594125 = path.getOrDefault("indexName")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "indexName", valid_594125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594126 = query.getOrDefault("api-version")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "api-version", valid_594126
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594127 = header.getOrDefault("client-request-id")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "client-request-id", valid_594127
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594128: Call_IndexesDelete_594122; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Azure Search index and all the documents it contains.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn798926.aspx
  let valid = call_594128.validator(path, query, header, formData, body)
  let scheme = call_594128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594128.url(scheme.get, call_594128.host, call_594128.base,
                         call_594128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594128, url, valid)

proc call*(call_594129: Call_IndexesDelete_594122; indexName: string;
          apiVersion: string): Recallable =
  ## indexesDelete
  ## Deletes an Azure Search index and all the documents it contains.
  ## https://msdn.microsoft.com/library/azure/dn798926.aspx
  ##   indexName: string (required)
  ##            : The name of the index to delete.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_594130 = newJObject()
  var query_594131 = newJObject()
  add(path_594130, "indexName", newJString(indexName))
  add(query_594131, "api-version", newJString(apiVersion))
  result = call_594129.call(path_594130, query_594131, nil, nil, nil)

var indexesDelete* = Call_IndexesDelete_594122(name: "indexesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/indexes(\'{indexName}\')", validator: validate_IndexesDelete_594123,
    base: "", url: url_IndexesDelete_594124, schemes: {Scheme.Https})
type
  Call_IndexesGetStatistics_594132 = ref object of OpenApiRestCall_593408
proc url_IndexesGetStatistics_594134(protocol: Scheme; host: string; base: string;
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

proc validate_IndexesGetStatistics_594133(path: JsonNode; query: JsonNode;
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
  var valid_594135 = path.getOrDefault("indexName")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "indexName", valid_594135
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594136 = query.getOrDefault("api-version")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "api-version", valid_594136
  result.add "query", section
  ## parameters in `header` object:
  ##   client-request-id: JString
  ##                    : Tracking ID sent with the request to help with debugging.
  section = newJObject()
  var valid_594137 = header.getOrDefault("client-request-id")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "client-request-id", valid_594137
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594138: Call_IndexesGetStatistics_594132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns statistics for the given index, including a document count and storage usage.
  ## 
  ## https://msdn.microsoft.com/library/azure/dn798942.aspx
  let valid = call_594138.validator(path, query, header, formData, body)
  let scheme = call_594138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594138.url(scheme.get, call_594138.host, call_594138.base,
                         call_594138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594138, url, valid)

proc call*(call_594139: Call_IndexesGetStatistics_594132; indexName: string;
          apiVersion: string): Recallable =
  ## indexesGetStatistics
  ## Returns statistics for the given index, including a document count and storage usage.
  ## https://msdn.microsoft.com/library/azure/dn798942.aspx
  ##   indexName: string (required)
  ##            : The name of the index for which to retrieve statistics.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_594140 = newJObject()
  var query_594141 = newJObject()
  add(path_594140, "indexName", newJString(indexName))
  add(query_594141, "api-version", newJString(apiVersion))
  result = call_594139.call(path_594140, query_594141, nil, nil, nil)

var indexesGetStatistics* = Call_IndexesGetStatistics_594132(
    name: "indexesGetStatistics", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/indexes(\'{indexName}\')/search.stats",
    validator: validate_IndexesGetStatistics_594133, base: "",
    url: url_IndexesGetStatistics_594134, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
