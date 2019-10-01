
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_596459 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596459](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596459): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimreports"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ReportsListByApi_596681 = ref object of OpenApiRestCall_596459
proc url_ReportsListByApi_596683(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportsListByApi_596682(path: JsonNode; query: JsonNode;
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
  var valid_596830 = query.getOrDefault("api-version")
  valid_596830 = validateParameter(valid_596830, JString, required = true,
                                 default = nil)
  if valid_596830 != nil:
    section.add "api-version", valid_596830
  var valid_596831 = query.getOrDefault("$top")
  valid_596831 = validateParameter(valid_596831, JInt, required = false, default = nil)
  if valid_596831 != nil:
    section.add "$top", valid_596831
  var valid_596832 = query.getOrDefault("$skip")
  valid_596832 = validateParameter(valid_596832, JInt, required = false, default = nil)
  if valid_596832 != nil:
    section.add "$skip", valid_596832
  var valid_596833 = query.getOrDefault("$filter")
  valid_596833 = validateParameter(valid_596833, JString, required = true,
                                 default = nil)
  if valid_596833 != nil:
    section.add "$filter", valid_596833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596860: Call_ReportsListByApi_596681; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by API.
  ## 
  let valid = call_596860.validator(path, query, header, formData, body)
  let scheme = call_596860.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596860.url(scheme.get, call_596860.host, call_596860.base,
                         call_596860.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596860, url, valid)

proc call*(call_596931: Call_ReportsListByApi_596681; apiVersion: string;
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
  var query_596932 = newJObject()
  add(query_596932, "api-version", newJString(apiVersion))
  add(query_596932, "$top", newJInt(Top))
  add(query_596932, "$skip", newJInt(Skip))
  add(query_596932, "$filter", newJString(Filter))
  result = call_596931.call(nil, query_596932, nil, nil, nil)

var reportsListByApi* = Call_ReportsListByApi_596681(name: "reportsListByApi",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/reports/byApi",
    validator: validate_ReportsListByApi_596682, base: "",
    url: url_ReportsListByApi_596683, schemes: {Scheme.Https})
type
  Call_ReportsListByGeo_596972 = ref object of OpenApiRestCall_596459
proc url_ReportsListByGeo_596974(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportsListByGeo_596973(path: JsonNode; query: JsonNode;
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
  var valid_596975 = query.getOrDefault("api-version")
  valid_596975 = validateParameter(valid_596975, JString, required = true,
                                 default = nil)
  if valid_596975 != nil:
    section.add "api-version", valid_596975
  var valid_596976 = query.getOrDefault("$top")
  valid_596976 = validateParameter(valid_596976, JInt, required = false, default = nil)
  if valid_596976 != nil:
    section.add "$top", valid_596976
  var valid_596977 = query.getOrDefault("$skip")
  valid_596977 = validateParameter(valid_596977, JInt, required = false, default = nil)
  if valid_596977 != nil:
    section.add "$skip", valid_596977
  var valid_596978 = query.getOrDefault("$filter")
  valid_596978 = validateParameter(valid_596978, JString, required = false,
                                 default = nil)
  if valid_596978 != nil:
    section.add "$filter", valid_596978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596979: Call_ReportsListByGeo_596972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by geography.
  ## 
  let valid = call_596979.validator(path, query, header, formData, body)
  let scheme = call_596979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596979.url(scheme.get, call_596979.host, call_596979.base,
                         call_596979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596979, url, valid)

proc call*(call_596980: Call_ReportsListByGeo_596972; apiVersion: string;
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
  var query_596981 = newJObject()
  add(query_596981, "api-version", newJString(apiVersion))
  add(query_596981, "$top", newJInt(Top))
  add(query_596981, "$skip", newJInt(Skip))
  add(query_596981, "$filter", newJString(Filter))
  result = call_596980.call(nil, query_596981, nil, nil, nil)

var reportsListByGeo* = Call_ReportsListByGeo_596972(name: "reportsListByGeo",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/reports/byGeo",
    validator: validate_ReportsListByGeo_596973, base: "",
    url: url_ReportsListByGeo_596974, schemes: {Scheme.Https})
type
  Call_ReportsListByOperation_596982 = ref object of OpenApiRestCall_596459
proc url_ReportsListByOperation_596984(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportsListByOperation_596983(path: JsonNode; query: JsonNode;
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
  var valid_596985 = query.getOrDefault("api-version")
  valid_596985 = validateParameter(valid_596985, JString, required = true,
                                 default = nil)
  if valid_596985 != nil:
    section.add "api-version", valid_596985
  var valid_596986 = query.getOrDefault("$top")
  valid_596986 = validateParameter(valid_596986, JInt, required = false, default = nil)
  if valid_596986 != nil:
    section.add "$top", valid_596986
  var valid_596987 = query.getOrDefault("$skip")
  valid_596987 = validateParameter(valid_596987, JInt, required = false, default = nil)
  if valid_596987 != nil:
    section.add "$skip", valid_596987
  var valid_596988 = query.getOrDefault("$filter")
  valid_596988 = validateParameter(valid_596988, JString, required = true,
                                 default = nil)
  if valid_596988 != nil:
    section.add "$filter", valid_596988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596989: Call_ReportsListByOperation_596982; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by API Operations.
  ## 
  let valid = call_596989.validator(path, query, header, formData, body)
  let scheme = call_596989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596989.url(scheme.get, call_596989.host, call_596989.base,
                         call_596989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596989, url, valid)

proc call*(call_596990: Call_ReportsListByOperation_596982; apiVersion: string;
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
  var query_596991 = newJObject()
  add(query_596991, "api-version", newJString(apiVersion))
  add(query_596991, "$top", newJInt(Top))
  add(query_596991, "$skip", newJInt(Skip))
  add(query_596991, "$filter", newJString(Filter))
  result = call_596990.call(nil, query_596991, nil, nil, nil)

var reportsListByOperation* = Call_ReportsListByOperation_596982(
    name: "reportsListByOperation", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/reports/byOperation", validator: validate_ReportsListByOperation_596983,
    base: "", url: url_ReportsListByOperation_596984, schemes: {Scheme.Https})
type
  Call_ReportsListByProduct_596992 = ref object of OpenApiRestCall_596459
proc url_ReportsListByProduct_596994(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportsListByProduct_596993(path: JsonNode; query: JsonNode;
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
  var valid_596995 = query.getOrDefault("api-version")
  valid_596995 = validateParameter(valid_596995, JString, required = true,
                                 default = nil)
  if valid_596995 != nil:
    section.add "api-version", valid_596995
  var valid_596996 = query.getOrDefault("$top")
  valid_596996 = validateParameter(valid_596996, JInt, required = false, default = nil)
  if valid_596996 != nil:
    section.add "$top", valid_596996
  var valid_596997 = query.getOrDefault("$skip")
  valid_596997 = validateParameter(valid_596997, JInt, required = false, default = nil)
  if valid_596997 != nil:
    section.add "$skip", valid_596997
  var valid_596998 = query.getOrDefault("$filter")
  valid_596998 = validateParameter(valid_596998, JString, required = true,
                                 default = nil)
  if valid_596998 != nil:
    section.add "$filter", valid_596998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596999: Call_ReportsListByProduct_596992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by Product.
  ## 
  let valid = call_596999.validator(path, query, header, formData, body)
  let scheme = call_596999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596999.url(scheme.get, call_596999.host, call_596999.base,
                         call_596999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596999, url, valid)

proc call*(call_597000: Call_ReportsListByProduct_596992; apiVersion: string;
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
  var query_597001 = newJObject()
  add(query_597001, "api-version", newJString(apiVersion))
  add(query_597001, "$top", newJInt(Top))
  add(query_597001, "$skip", newJInt(Skip))
  add(query_597001, "$filter", newJString(Filter))
  result = call_597000.call(nil, query_597001, nil, nil, nil)

var reportsListByProduct* = Call_ReportsListByProduct_596992(
    name: "reportsListByProduct", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/reports/byProduct", validator: validate_ReportsListByProduct_596993,
    base: "", url: url_ReportsListByProduct_596994, schemes: {Scheme.Https})
type
  Call_ReportsListByRequest_597002 = ref object of OpenApiRestCall_596459
proc url_ReportsListByRequest_597004(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportsListByRequest_597003(path: JsonNode; query: JsonNode;
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
  var valid_597005 = query.getOrDefault("api-version")
  valid_597005 = validateParameter(valid_597005, JString, required = true,
                                 default = nil)
  if valid_597005 != nil:
    section.add "api-version", valid_597005
  var valid_597006 = query.getOrDefault("$top")
  valid_597006 = validateParameter(valid_597006, JInt, required = false, default = nil)
  if valid_597006 != nil:
    section.add "$top", valid_597006
  var valid_597007 = query.getOrDefault("$skip")
  valid_597007 = validateParameter(valid_597007, JInt, required = false, default = nil)
  if valid_597007 != nil:
    section.add "$skip", valid_597007
  var valid_597008 = query.getOrDefault("$filter")
  valid_597008 = validateParameter(valid_597008, JString, required = true,
                                 default = nil)
  if valid_597008 != nil:
    section.add "$filter", valid_597008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597009: Call_ReportsListByRequest_597002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by Request.
  ## 
  let valid = call_597009.validator(path, query, header, formData, body)
  let scheme = call_597009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597009.url(scheme.get, call_597009.host, call_597009.base,
                         call_597009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597009, url, valid)

proc call*(call_597010: Call_ReportsListByRequest_597002; apiVersion: string;
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
  var query_597011 = newJObject()
  add(query_597011, "api-version", newJString(apiVersion))
  add(query_597011, "$top", newJInt(Top))
  add(query_597011, "$skip", newJInt(Skip))
  add(query_597011, "$filter", newJString(Filter))
  result = call_597010.call(nil, query_597011, nil, nil, nil)

var reportsListByRequest* = Call_ReportsListByRequest_597002(
    name: "reportsListByRequest", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/reports/byRequest", validator: validate_ReportsListByRequest_597003,
    base: "", url: url_ReportsListByRequest_597004, schemes: {Scheme.Https})
type
  Call_ReportsListBySubscription_597012 = ref object of OpenApiRestCall_596459
proc url_ReportsListBySubscription_597014(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportsListBySubscription_597013(path: JsonNode; query: JsonNode;
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
  var valid_597015 = query.getOrDefault("api-version")
  valid_597015 = validateParameter(valid_597015, JString, required = true,
                                 default = nil)
  if valid_597015 != nil:
    section.add "api-version", valid_597015
  var valid_597016 = query.getOrDefault("$top")
  valid_597016 = validateParameter(valid_597016, JInt, required = false, default = nil)
  if valid_597016 != nil:
    section.add "$top", valid_597016
  var valid_597017 = query.getOrDefault("$skip")
  valid_597017 = validateParameter(valid_597017, JInt, required = false, default = nil)
  if valid_597017 != nil:
    section.add "$skip", valid_597017
  var valid_597018 = query.getOrDefault("$filter")
  valid_597018 = validateParameter(valid_597018, JString, required = false,
                                 default = nil)
  if valid_597018 != nil:
    section.add "$filter", valid_597018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597019: Call_ReportsListBySubscription_597012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by subscription.
  ## 
  let valid = call_597019.validator(path, query, header, formData, body)
  let scheme = call_597019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597019.url(scheme.get, call_597019.host, call_597019.base,
                         call_597019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597019, url, valid)

proc call*(call_597020: Call_ReportsListBySubscription_597012; apiVersion: string;
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
  var query_597021 = newJObject()
  add(query_597021, "api-version", newJString(apiVersion))
  add(query_597021, "$top", newJInt(Top))
  add(query_597021, "$skip", newJInt(Skip))
  add(query_597021, "$filter", newJString(Filter))
  result = call_597020.call(nil, query_597021, nil, nil, nil)

var reportsListBySubscription* = Call_ReportsListBySubscription_597012(
    name: "reportsListBySubscription", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/reports/bySubscription",
    validator: validate_ReportsListBySubscription_597013, base: "",
    url: url_ReportsListBySubscription_597014, schemes: {Scheme.Https})
type
  Call_ReportsListByTime_597022 = ref object of OpenApiRestCall_596459
proc url_ReportsListByTime_597024(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportsListByTime_597023(path: JsonNode; query: JsonNode;
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
  var valid_597025 = query.getOrDefault("api-version")
  valid_597025 = validateParameter(valid_597025, JString, required = true,
                                 default = nil)
  if valid_597025 != nil:
    section.add "api-version", valid_597025
  var valid_597026 = query.getOrDefault("$top")
  valid_597026 = validateParameter(valid_597026, JInt, required = false, default = nil)
  if valid_597026 != nil:
    section.add "$top", valid_597026
  var valid_597027 = query.getOrDefault("$skip")
  valid_597027 = validateParameter(valid_597027, JInt, required = false, default = nil)
  if valid_597027 != nil:
    section.add "$skip", valid_597027
  var valid_597028 = query.getOrDefault("interval")
  valid_597028 = validateParameter(valid_597028, JString, required = true,
                                 default = nil)
  if valid_597028 != nil:
    section.add "interval", valid_597028
  var valid_597029 = query.getOrDefault("$filter")
  valid_597029 = validateParameter(valid_597029, JString, required = false,
                                 default = nil)
  if valid_597029 != nil:
    section.add "$filter", valid_597029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597030: Call_ReportsListByTime_597022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by Time.
  ## 
  let valid = call_597030.validator(path, query, header, formData, body)
  let scheme = call_597030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597030.url(scheme.get, call_597030.host, call_597030.base,
                         call_597030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597030, url, valid)

proc call*(call_597031: Call_ReportsListByTime_597022; apiVersion: string;
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
  var query_597032 = newJObject()
  add(query_597032, "api-version", newJString(apiVersion))
  add(query_597032, "$top", newJInt(Top))
  add(query_597032, "$skip", newJInt(Skip))
  add(query_597032, "interval", newJString(interval))
  add(query_597032, "$filter", newJString(Filter))
  result = call_597031.call(nil, query_597032, nil, nil, nil)

var reportsListByTime* = Call_ReportsListByTime_597022(name: "reportsListByTime",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/reports/byTime",
    validator: validate_ReportsListByTime_597023, base: "",
    url: url_ReportsListByTime_597024, schemes: {Scheme.Https})
type
  Call_ReportsListByUser_597033 = ref object of OpenApiRestCall_596459
proc url_ReportsListByUser_597035(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportsListByUser_597034(path: JsonNode; query: JsonNode;
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
  var valid_597036 = query.getOrDefault("api-version")
  valid_597036 = validateParameter(valid_597036, JString, required = true,
                                 default = nil)
  if valid_597036 != nil:
    section.add "api-version", valid_597036
  var valid_597037 = query.getOrDefault("$top")
  valid_597037 = validateParameter(valid_597037, JInt, required = false, default = nil)
  if valid_597037 != nil:
    section.add "$top", valid_597037
  var valid_597038 = query.getOrDefault("$skip")
  valid_597038 = validateParameter(valid_597038, JInt, required = false, default = nil)
  if valid_597038 != nil:
    section.add "$skip", valid_597038
  var valid_597039 = query.getOrDefault("$filter")
  valid_597039 = validateParameter(valid_597039, JString, required = true,
                                 default = nil)
  if valid_597039 != nil:
    section.add "$filter", valid_597039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597040: Call_ReportsListByUser_597033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by User.
  ## 
  let valid = call_597040.validator(path, query, header, formData, body)
  let scheme = call_597040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597040.url(scheme.get, call_597040.host, call_597040.base,
                         call_597040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597040, url, valid)

proc call*(call_597041: Call_ReportsListByUser_597033; apiVersion: string;
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
  var query_597042 = newJObject()
  add(query_597042, "api-version", newJString(apiVersion))
  add(query_597042, "$top", newJInt(Top))
  add(query_597042, "$skip", newJInt(Skip))
  add(query_597042, "$filter", newJString(Filter))
  result = call_597041.call(nil, query_597042, nil, nil, nil)

var reportsListByUser* = Call_ReportsListByUser_597033(name: "reportsListByUser",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/reports/byUser",
    validator: validate_ReportsListByUser_597034, base: "",
    url: url_ReportsListByUser_597035, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
