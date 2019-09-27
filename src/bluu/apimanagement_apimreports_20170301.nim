
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs to get the analytics reports associated with your Azure API Management deployment.
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

  OpenApiRestCall_593426 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593426](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593426): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimreports"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ReportsListByApi_593648 = ref object of OpenApiRestCall_593426
proc url_ReportsListByApi_593650(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportsListByApi_593649(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists report records by API.
  ## 
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
  ##   $filter: JString (required)
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593797 = query.getOrDefault("api-version")
  valid_593797 = validateParameter(valid_593797, JString, required = true,
                                 default = nil)
  if valid_593797 != nil:
    section.add "api-version", valid_593797
  var valid_593798 = query.getOrDefault("$top")
  valid_593798 = validateParameter(valid_593798, JInt, required = false, default = nil)
  if valid_593798 != nil:
    section.add "$top", valid_593798
  var valid_593799 = query.getOrDefault("$skip")
  valid_593799 = validateParameter(valid_593799, JInt, required = false, default = nil)
  if valid_593799 != nil:
    section.add "$skip", valid_593799
  var valid_593800 = query.getOrDefault("$filter")
  valid_593800 = validateParameter(valid_593800, JString, required = true,
                                 default = nil)
  if valid_593800 != nil:
    section.add "$filter", valid_593800
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593827: Call_ReportsListByApi_593648; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by API.
  ## 
  let valid = call_593827.validator(path, query, header, formData, body)
  let scheme = call_593827.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593827.url(scheme.get, call_593827.host, call_593827.base,
                         call_593827.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593827, url, valid)

proc call*(call_593898: Call_ReportsListByApi_593648; apiVersion: string;
          Filter: string; Top: int = 0; Skip: int = 0): Recallable =
  ## reportsListByApi
  ## Lists report records by API.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string (required)
  ##         : The filter to apply on the operation.
  var query_593899 = newJObject()
  add(query_593899, "api-version", newJString(apiVersion))
  add(query_593899, "$top", newJInt(Top))
  add(query_593899, "$skip", newJInt(Skip))
  add(query_593899, "$filter", newJString(Filter))
  result = call_593898.call(nil, query_593899, nil, nil, nil)

var reportsListByApi* = Call_ReportsListByApi_593648(name: "reportsListByApi",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/reports/byApi",
    validator: validate_ReportsListByApi_593649, base: "",
    url: url_ReportsListByApi_593650, schemes: {Scheme.Https})
type
  Call_ReportsListByGeo_593939 = ref object of OpenApiRestCall_593426
proc url_ReportsListByGeo_593941(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportsListByGeo_593940(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists report records by geography.
  ## 
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
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593942 = query.getOrDefault("api-version")
  valid_593942 = validateParameter(valid_593942, JString, required = true,
                                 default = nil)
  if valid_593942 != nil:
    section.add "api-version", valid_593942
  var valid_593943 = query.getOrDefault("$top")
  valid_593943 = validateParameter(valid_593943, JInt, required = false, default = nil)
  if valid_593943 != nil:
    section.add "$top", valid_593943
  var valid_593944 = query.getOrDefault("$skip")
  valid_593944 = validateParameter(valid_593944, JInt, required = false, default = nil)
  if valid_593944 != nil:
    section.add "$skip", valid_593944
  var valid_593945 = query.getOrDefault("$filter")
  valid_593945 = validateParameter(valid_593945, JString, required = false,
                                 default = nil)
  if valid_593945 != nil:
    section.add "$filter", valid_593945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593946: Call_ReportsListByGeo_593939; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by geography.
  ## 
  let valid = call_593946.validator(path, query, header, formData, body)
  let scheme = call_593946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593946.url(scheme.get, call_593946.host, call_593946.base,
                         call_593946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593946, url, valid)

proc call*(call_593947: Call_ReportsListByGeo_593939; apiVersion: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## reportsListByGeo
  ## Lists report records by geography.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var query_593948 = newJObject()
  add(query_593948, "api-version", newJString(apiVersion))
  add(query_593948, "$top", newJInt(Top))
  add(query_593948, "$skip", newJInt(Skip))
  add(query_593948, "$filter", newJString(Filter))
  result = call_593947.call(nil, query_593948, nil, nil, nil)

var reportsListByGeo* = Call_ReportsListByGeo_593939(name: "reportsListByGeo",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/reports/byGeo",
    validator: validate_ReportsListByGeo_593940, base: "",
    url: url_ReportsListByGeo_593941, schemes: {Scheme.Https})
type
  Call_ReportsListByOperation_593949 = ref object of OpenApiRestCall_593426
proc url_ReportsListByOperation_593951(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportsListByOperation_593950(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists report records by API Operations.
  ## 
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
  ##   $filter: JString (required)
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593952 = query.getOrDefault("api-version")
  valid_593952 = validateParameter(valid_593952, JString, required = true,
                                 default = nil)
  if valid_593952 != nil:
    section.add "api-version", valid_593952
  var valid_593953 = query.getOrDefault("$top")
  valid_593953 = validateParameter(valid_593953, JInt, required = false, default = nil)
  if valid_593953 != nil:
    section.add "$top", valid_593953
  var valid_593954 = query.getOrDefault("$skip")
  valid_593954 = validateParameter(valid_593954, JInt, required = false, default = nil)
  if valid_593954 != nil:
    section.add "$skip", valid_593954
  var valid_593955 = query.getOrDefault("$filter")
  valid_593955 = validateParameter(valid_593955, JString, required = true,
                                 default = nil)
  if valid_593955 != nil:
    section.add "$filter", valid_593955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593956: Call_ReportsListByOperation_593949; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by API Operations.
  ## 
  let valid = call_593956.validator(path, query, header, formData, body)
  let scheme = call_593956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593956.url(scheme.get, call_593956.host, call_593956.base,
                         call_593956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593956, url, valid)

proc call*(call_593957: Call_ReportsListByOperation_593949; apiVersion: string;
          Filter: string; Top: int = 0; Skip: int = 0): Recallable =
  ## reportsListByOperation
  ## Lists report records by API Operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string (required)
  ##         : The filter to apply on the operation.
  var query_593958 = newJObject()
  add(query_593958, "api-version", newJString(apiVersion))
  add(query_593958, "$top", newJInt(Top))
  add(query_593958, "$skip", newJInt(Skip))
  add(query_593958, "$filter", newJString(Filter))
  result = call_593957.call(nil, query_593958, nil, nil, nil)

var reportsListByOperation* = Call_ReportsListByOperation_593949(
    name: "reportsListByOperation", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/reports/byOperation", validator: validate_ReportsListByOperation_593950,
    base: "", url: url_ReportsListByOperation_593951, schemes: {Scheme.Https})
type
  Call_ReportsListByProduct_593959 = ref object of OpenApiRestCall_593426
proc url_ReportsListByProduct_593961(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportsListByProduct_593960(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists report records by Product.
  ## 
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
  ##   $filter: JString (required)
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593962 = query.getOrDefault("api-version")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "api-version", valid_593962
  var valid_593963 = query.getOrDefault("$top")
  valid_593963 = validateParameter(valid_593963, JInt, required = false, default = nil)
  if valid_593963 != nil:
    section.add "$top", valid_593963
  var valid_593964 = query.getOrDefault("$skip")
  valid_593964 = validateParameter(valid_593964, JInt, required = false, default = nil)
  if valid_593964 != nil:
    section.add "$skip", valid_593964
  var valid_593965 = query.getOrDefault("$filter")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "$filter", valid_593965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_ReportsListByProduct_593959; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by Product.
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_ReportsListByProduct_593959; apiVersion: string;
          Filter: string; Top: int = 0; Skip: int = 0): Recallable =
  ## reportsListByProduct
  ## Lists report records by Product.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string (required)
  ##         : The filter to apply on the operation.
  var query_593968 = newJObject()
  add(query_593968, "api-version", newJString(apiVersion))
  add(query_593968, "$top", newJInt(Top))
  add(query_593968, "$skip", newJInt(Skip))
  add(query_593968, "$filter", newJString(Filter))
  result = call_593967.call(nil, query_593968, nil, nil, nil)

var reportsListByProduct* = Call_ReportsListByProduct_593959(
    name: "reportsListByProduct", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/reports/byProduct", validator: validate_ReportsListByProduct_593960,
    base: "", url: url_ReportsListByProduct_593961, schemes: {Scheme.Https})
type
  Call_ReportsListByRequest_593969 = ref object of OpenApiRestCall_593426
proc url_ReportsListByRequest_593971(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportsListByRequest_593970(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists report records by Request.
  ## 
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
  ##   $filter: JString (required)
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593972 = query.getOrDefault("api-version")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "api-version", valid_593972
  var valid_593973 = query.getOrDefault("$top")
  valid_593973 = validateParameter(valid_593973, JInt, required = false, default = nil)
  if valid_593973 != nil:
    section.add "$top", valid_593973
  var valid_593974 = query.getOrDefault("$skip")
  valid_593974 = validateParameter(valid_593974, JInt, required = false, default = nil)
  if valid_593974 != nil:
    section.add "$skip", valid_593974
  var valid_593975 = query.getOrDefault("$filter")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "$filter", valid_593975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593976: Call_ReportsListByRequest_593969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by Request.
  ## 
  let valid = call_593976.validator(path, query, header, formData, body)
  let scheme = call_593976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593976.url(scheme.get, call_593976.host, call_593976.base,
                         call_593976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593976, url, valid)

proc call*(call_593977: Call_ReportsListByRequest_593969; apiVersion: string;
          Filter: string; Top: int = 0; Skip: int = 0): Recallable =
  ## reportsListByRequest
  ## Lists report records by Request.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string (required)
  ##         : The filter to apply on the operation.
  var query_593978 = newJObject()
  add(query_593978, "api-version", newJString(apiVersion))
  add(query_593978, "$top", newJInt(Top))
  add(query_593978, "$skip", newJInt(Skip))
  add(query_593978, "$filter", newJString(Filter))
  result = call_593977.call(nil, query_593978, nil, nil, nil)

var reportsListByRequest* = Call_ReportsListByRequest_593969(
    name: "reportsListByRequest", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/reports/byRequest", validator: validate_ReportsListByRequest_593970,
    base: "", url: url_ReportsListByRequest_593971, schemes: {Scheme.Https})
type
  Call_ReportsListBySubscription_593979 = ref object of OpenApiRestCall_593426
proc url_ReportsListBySubscription_593981(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportsListBySubscription_593980(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists report records by subscription.
  ## 
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
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593982 = query.getOrDefault("api-version")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "api-version", valid_593982
  var valid_593983 = query.getOrDefault("$top")
  valid_593983 = validateParameter(valid_593983, JInt, required = false, default = nil)
  if valid_593983 != nil:
    section.add "$top", valid_593983
  var valid_593984 = query.getOrDefault("$skip")
  valid_593984 = validateParameter(valid_593984, JInt, required = false, default = nil)
  if valid_593984 != nil:
    section.add "$skip", valid_593984
  var valid_593985 = query.getOrDefault("$filter")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "$filter", valid_593985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593986: Call_ReportsListBySubscription_593979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by subscription.
  ## 
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_ReportsListBySubscription_593979; apiVersion: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## reportsListBySubscription
  ## Lists report records by subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var query_593988 = newJObject()
  add(query_593988, "api-version", newJString(apiVersion))
  add(query_593988, "$top", newJInt(Top))
  add(query_593988, "$skip", newJInt(Skip))
  add(query_593988, "$filter", newJString(Filter))
  result = call_593987.call(nil, query_593988, nil, nil, nil)

var reportsListBySubscription* = Call_ReportsListBySubscription_593979(
    name: "reportsListBySubscription", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/reports/bySubscription",
    validator: validate_ReportsListBySubscription_593980, base: "",
    url: url_ReportsListBySubscription_593981, schemes: {Scheme.Https})
type
  Call_ReportsListByTime_593989 = ref object of OpenApiRestCall_593426
proc url_ReportsListByTime_593991(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportsListByTime_593990(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists report records by Time.
  ## 
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
  ##   interval: JString (required)
  ##           : By time interval. Interval must be multiple of 15 minutes and may not be zero. The value should be in ISO  8601 format (http://en.wikipedia.org/wiki/ISO_8601#Durations).This code can be used to convert TimeSpan to a valid interval string: XmlConvert.ToString(new TimeSpan(hours, minutes, seconds))
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593992 = query.getOrDefault("api-version")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "api-version", valid_593992
  var valid_593993 = query.getOrDefault("$top")
  valid_593993 = validateParameter(valid_593993, JInt, required = false, default = nil)
  if valid_593993 != nil:
    section.add "$top", valid_593993
  var valid_593994 = query.getOrDefault("$skip")
  valid_593994 = validateParameter(valid_593994, JInt, required = false, default = nil)
  if valid_593994 != nil:
    section.add "$skip", valid_593994
  var valid_593995 = query.getOrDefault("interval")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "interval", valid_593995
  var valid_593996 = query.getOrDefault("$filter")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "$filter", valid_593996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593997: Call_ReportsListByTime_593989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by Time.
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_ReportsListByTime_593989; apiVersion: string;
          interval: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## reportsListByTime
  ## Lists report records by Time.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   interval: string (required)
  ##           : By time interval. Interval must be multiple of 15 minutes and may not be zero. The value should be in ISO  8601 format (http://en.wikipedia.org/wiki/ISO_8601#Durations).This code can be used to convert TimeSpan to a valid interval string: XmlConvert.ToString(new TimeSpan(hours, minutes, seconds))
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var query_593999 = newJObject()
  add(query_593999, "api-version", newJString(apiVersion))
  add(query_593999, "$top", newJInt(Top))
  add(query_593999, "$skip", newJInt(Skip))
  add(query_593999, "interval", newJString(interval))
  add(query_593999, "$filter", newJString(Filter))
  result = call_593998.call(nil, query_593999, nil, nil, nil)

var reportsListByTime* = Call_ReportsListByTime_593989(name: "reportsListByTime",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/reports/byTime",
    validator: validate_ReportsListByTime_593990, base: "",
    url: url_ReportsListByTime_593991, schemes: {Scheme.Https})
type
  Call_ReportsListByUser_594000 = ref object of OpenApiRestCall_593426
proc url_ReportsListByUser_594002(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportsListByUser_594001(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists report records by User.
  ## 
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
  ##   $filter: JString (required)
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594003 = query.getOrDefault("api-version")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "api-version", valid_594003
  var valid_594004 = query.getOrDefault("$top")
  valid_594004 = validateParameter(valid_594004, JInt, required = false, default = nil)
  if valid_594004 != nil:
    section.add "$top", valid_594004
  var valid_594005 = query.getOrDefault("$skip")
  valid_594005 = validateParameter(valid_594005, JInt, required = false, default = nil)
  if valid_594005 != nil:
    section.add "$skip", valid_594005
  var valid_594006 = query.getOrDefault("$filter")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "$filter", valid_594006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594007: Call_ReportsListByUser_594000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by User.
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_ReportsListByUser_594000; apiVersion: string;
          Filter: string; Top: int = 0; Skip: int = 0): Recallable =
  ## reportsListByUser
  ## Lists report records by User.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string (required)
  ##         : The filter to apply on the operation.
  var query_594009 = newJObject()
  add(query_594009, "api-version", newJString(apiVersion))
  add(query_594009, "$top", newJInt(Top))
  add(query_594009, "$skip", newJInt(Skip))
  add(query_594009, "$filter", newJString(Filter))
  result = call_594008.call(nil, query_594009, nil, nil, nil)

var reportsListByUser* = Call_ReportsListByUser_594000(name: "reportsListByUser",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/reports/byUser",
    validator: validate_ReportsListByUser_594001, base: "",
    url: url_ReportsListByUser_594002, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
