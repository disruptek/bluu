
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-01-01
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
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/reports/byApi")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsListByApi_596682(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists report records by API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_596844 = path.getOrDefault("resourceGroupName")
  valid_596844 = validateParameter(valid_596844, JString, required = true,
                                 default = nil)
  if valid_596844 != nil:
    section.add "resourceGroupName", valid_596844
  var valid_596845 = path.getOrDefault("subscriptionId")
  valid_596845 = validateParameter(valid_596845, JString, required = true,
                                 default = nil)
  if valid_596845 != nil:
    section.add "subscriptionId", valid_596845
  var valid_596846 = path.getOrDefault("serviceName")
  valid_596846 = validateParameter(valid_596846, JString, required = true,
                                 default = nil)
  if valid_596846 != nil:
    section.add "serviceName", valid_596846
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
  var valid_596847 = query.getOrDefault("api-version")
  valid_596847 = validateParameter(valid_596847, JString, required = true,
                                 default = nil)
  if valid_596847 != nil:
    section.add "api-version", valid_596847
  var valid_596848 = query.getOrDefault("$top")
  valid_596848 = validateParameter(valid_596848, JInt, required = false, default = nil)
  if valid_596848 != nil:
    section.add "$top", valid_596848
  var valid_596849 = query.getOrDefault("$skip")
  valid_596849 = validateParameter(valid_596849, JInt, required = false, default = nil)
  if valid_596849 != nil:
    section.add "$skip", valid_596849
  var valid_596850 = query.getOrDefault("$filter")
  valid_596850 = validateParameter(valid_596850, JString, required = true,
                                 default = nil)
  if valid_596850 != nil:
    section.add "$filter", valid_596850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596877: Call_ReportsListByApi_596681; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by API.
  ## 
  let valid = call_596877.validator(path, query, header, formData, body)
  let scheme = call_596877.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596877.url(scheme.get, call_596877.host, call_596877.base,
                         call_596877.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596877, url, valid)

proc call*(call_596948: Call_ReportsListByApi_596681; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Filter: string; Top: int = 0; Skip: int = 0): Recallable =
  ## reportsListByApi
  ## Lists report records by API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string (required)
  ##         : The filter to apply on the operation.
  var path_596949 = newJObject()
  var query_596951 = newJObject()
  add(path_596949, "resourceGroupName", newJString(resourceGroupName))
  add(query_596951, "api-version", newJString(apiVersion))
  add(path_596949, "subscriptionId", newJString(subscriptionId))
  add(query_596951, "$top", newJInt(Top))
  add(query_596951, "$skip", newJInt(Skip))
  add(path_596949, "serviceName", newJString(serviceName))
  add(query_596951, "$filter", newJString(Filter))
  result = call_596948.call(path_596949, query_596951, nil, nil, nil)

var reportsListByApi* = Call_ReportsListByApi_596681(name: "reportsListByApi",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byApi",
    validator: validate_ReportsListByApi_596682, base: "",
    url: url_ReportsListByApi_596683, schemes: {Scheme.Https})
type
  Call_ReportsListByGeo_596990 = ref object of OpenApiRestCall_596459
proc url_ReportsListByGeo_596992(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/reports/byGeo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsListByGeo_596991(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists report records by geography.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_596993 = path.getOrDefault("resourceGroupName")
  valid_596993 = validateParameter(valid_596993, JString, required = true,
                                 default = nil)
  if valid_596993 != nil:
    section.add "resourceGroupName", valid_596993
  var valid_596994 = path.getOrDefault("subscriptionId")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "subscriptionId", valid_596994
  var valid_596995 = path.getOrDefault("serviceName")
  valid_596995 = validateParameter(valid_596995, JString, required = true,
                                 default = nil)
  if valid_596995 != nil:
    section.add "serviceName", valid_596995
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
  var valid_596996 = query.getOrDefault("api-version")
  valid_596996 = validateParameter(valid_596996, JString, required = true,
                                 default = nil)
  if valid_596996 != nil:
    section.add "api-version", valid_596996
  var valid_596997 = query.getOrDefault("$top")
  valid_596997 = validateParameter(valid_596997, JInt, required = false, default = nil)
  if valid_596997 != nil:
    section.add "$top", valid_596997
  var valid_596998 = query.getOrDefault("$skip")
  valid_596998 = validateParameter(valid_596998, JInt, required = false, default = nil)
  if valid_596998 != nil:
    section.add "$skip", valid_596998
  var valid_596999 = query.getOrDefault("$filter")
  valid_596999 = validateParameter(valid_596999, JString, required = false,
                                 default = nil)
  if valid_596999 != nil:
    section.add "$filter", valid_596999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597000: Call_ReportsListByGeo_596990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by geography.
  ## 
  let valid = call_597000.validator(path, query, header, formData, body)
  let scheme = call_597000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597000.url(scheme.get, call_597000.host, call_597000.base,
                         call_597000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597000, url, valid)

proc call*(call_597001: Call_ReportsListByGeo_596990; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## reportsListByGeo
  ## Lists report records by geography.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_597002 = newJObject()
  var query_597003 = newJObject()
  add(path_597002, "resourceGroupName", newJString(resourceGroupName))
  add(query_597003, "api-version", newJString(apiVersion))
  add(path_597002, "subscriptionId", newJString(subscriptionId))
  add(query_597003, "$top", newJInt(Top))
  add(query_597003, "$skip", newJInt(Skip))
  add(path_597002, "serviceName", newJString(serviceName))
  add(query_597003, "$filter", newJString(Filter))
  result = call_597001.call(path_597002, query_597003, nil, nil, nil)

var reportsListByGeo* = Call_ReportsListByGeo_596990(name: "reportsListByGeo",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byGeo",
    validator: validate_ReportsListByGeo_596991, base: "",
    url: url_ReportsListByGeo_596992, schemes: {Scheme.Https})
type
  Call_ReportsListByOperation_597004 = ref object of OpenApiRestCall_596459
proc url_ReportsListByOperation_597006(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/reports/byOperation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsListByOperation_597005(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists report records by API Operations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597007 = path.getOrDefault("resourceGroupName")
  valid_597007 = validateParameter(valid_597007, JString, required = true,
                                 default = nil)
  if valid_597007 != nil:
    section.add "resourceGroupName", valid_597007
  var valid_597008 = path.getOrDefault("subscriptionId")
  valid_597008 = validateParameter(valid_597008, JString, required = true,
                                 default = nil)
  if valid_597008 != nil:
    section.add "subscriptionId", valid_597008
  var valid_597009 = path.getOrDefault("serviceName")
  valid_597009 = validateParameter(valid_597009, JString, required = true,
                                 default = nil)
  if valid_597009 != nil:
    section.add "serviceName", valid_597009
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
  var valid_597010 = query.getOrDefault("api-version")
  valid_597010 = validateParameter(valid_597010, JString, required = true,
                                 default = nil)
  if valid_597010 != nil:
    section.add "api-version", valid_597010
  var valid_597011 = query.getOrDefault("$top")
  valid_597011 = validateParameter(valid_597011, JInt, required = false, default = nil)
  if valid_597011 != nil:
    section.add "$top", valid_597011
  var valid_597012 = query.getOrDefault("$skip")
  valid_597012 = validateParameter(valid_597012, JInt, required = false, default = nil)
  if valid_597012 != nil:
    section.add "$skip", valid_597012
  var valid_597013 = query.getOrDefault("$filter")
  valid_597013 = validateParameter(valid_597013, JString, required = true,
                                 default = nil)
  if valid_597013 != nil:
    section.add "$filter", valid_597013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597014: Call_ReportsListByOperation_597004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by API Operations.
  ## 
  let valid = call_597014.validator(path, query, header, formData, body)
  let scheme = call_597014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597014.url(scheme.get, call_597014.host, call_597014.base,
                         call_597014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597014, url, valid)

proc call*(call_597015: Call_ReportsListByOperation_597004;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Filter: string; Top: int = 0; Skip: int = 0): Recallable =
  ## reportsListByOperation
  ## Lists report records by API Operations.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string (required)
  ##         : The filter to apply on the operation.
  var path_597016 = newJObject()
  var query_597017 = newJObject()
  add(path_597016, "resourceGroupName", newJString(resourceGroupName))
  add(query_597017, "api-version", newJString(apiVersion))
  add(path_597016, "subscriptionId", newJString(subscriptionId))
  add(query_597017, "$top", newJInt(Top))
  add(query_597017, "$skip", newJInt(Skip))
  add(path_597016, "serviceName", newJString(serviceName))
  add(query_597017, "$filter", newJString(Filter))
  result = call_597015.call(path_597016, query_597017, nil, nil, nil)

var reportsListByOperation* = Call_ReportsListByOperation_597004(
    name: "reportsListByOperation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byOperation",
    validator: validate_ReportsListByOperation_597005, base: "",
    url: url_ReportsListByOperation_597006, schemes: {Scheme.Https})
type
  Call_ReportsListByProduct_597018 = ref object of OpenApiRestCall_596459
proc url_ReportsListByProduct_597020(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/reports/byProduct")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsListByProduct_597019(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists report records by Product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597021 = path.getOrDefault("resourceGroupName")
  valid_597021 = validateParameter(valid_597021, JString, required = true,
                                 default = nil)
  if valid_597021 != nil:
    section.add "resourceGroupName", valid_597021
  var valid_597022 = path.getOrDefault("subscriptionId")
  valid_597022 = validateParameter(valid_597022, JString, required = true,
                                 default = nil)
  if valid_597022 != nil:
    section.add "subscriptionId", valid_597022
  var valid_597023 = path.getOrDefault("serviceName")
  valid_597023 = validateParameter(valid_597023, JString, required = true,
                                 default = nil)
  if valid_597023 != nil:
    section.add "serviceName", valid_597023
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
  var valid_597024 = query.getOrDefault("api-version")
  valid_597024 = validateParameter(valid_597024, JString, required = true,
                                 default = nil)
  if valid_597024 != nil:
    section.add "api-version", valid_597024
  var valid_597025 = query.getOrDefault("$top")
  valid_597025 = validateParameter(valid_597025, JInt, required = false, default = nil)
  if valid_597025 != nil:
    section.add "$top", valid_597025
  var valid_597026 = query.getOrDefault("$skip")
  valid_597026 = validateParameter(valid_597026, JInt, required = false, default = nil)
  if valid_597026 != nil:
    section.add "$skip", valid_597026
  var valid_597027 = query.getOrDefault("$filter")
  valid_597027 = validateParameter(valid_597027, JString, required = true,
                                 default = nil)
  if valid_597027 != nil:
    section.add "$filter", valid_597027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597028: Call_ReportsListByProduct_597018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by Product.
  ## 
  let valid = call_597028.validator(path, query, header, formData, body)
  let scheme = call_597028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597028.url(scheme.get, call_597028.host, call_597028.base,
                         call_597028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597028, url, valid)

proc call*(call_597029: Call_ReportsListByProduct_597018;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Filter: string; Top: int = 0; Skip: int = 0): Recallable =
  ## reportsListByProduct
  ## Lists report records by Product.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string (required)
  ##         : The filter to apply on the operation.
  var path_597030 = newJObject()
  var query_597031 = newJObject()
  add(path_597030, "resourceGroupName", newJString(resourceGroupName))
  add(query_597031, "api-version", newJString(apiVersion))
  add(path_597030, "subscriptionId", newJString(subscriptionId))
  add(query_597031, "$top", newJInt(Top))
  add(query_597031, "$skip", newJInt(Skip))
  add(path_597030, "serviceName", newJString(serviceName))
  add(query_597031, "$filter", newJString(Filter))
  result = call_597029.call(path_597030, query_597031, nil, nil, nil)

var reportsListByProduct* = Call_ReportsListByProduct_597018(
    name: "reportsListByProduct", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byProduct",
    validator: validate_ReportsListByProduct_597019, base: "",
    url: url_ReportsListByProduct_597020, schemes: {Scheme.Https})
type
  Call_ReportsListByRequest_597032 = ref object of OpenApiRestCall_596459
proc url_ReportsListByRequest_597034(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/reports/byRequest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsListByRequest_597033(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists report records by Request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597035 = path.getOrDefault("resourceGroupName")
  valid_597035 = validateParameter(valid_597035, JString, required = true,
                                 default = nil)
  if valid_597035 != nil:
    section.add "resourceGroupName", valid_597035
  var valid_597036 = path.getOrDefault("subscriptionId")
  valid_597036 = validateParameter(valid_597036, JString, required = true,
                                 default = nil)
  if valid_597036 != nil:
    section.add "subscriptionId", valid_597036
  var valid_597037 = path.getOrDefault("serviceName")
  valid_597037 = validateParameter(valid_597037, JString, required = true,
                                 default = nil)
  if valid_597037 != nil:
    section.add "serviceName", valid_597037
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
  var valid_597038 = query.getOrDefault("api-version")
  valid_597038 = validateParameter(valid_597038, JString, required = true,
                                 default = nil)
  if valid_597038 != nil:
    section.add "api-version", valid_597038
  var valid_597039 = query.getOrDefault("$top")
  valid_597039 = validateParameter(valid_597039, JInt, required = false, default = nil)
  if valid_597039 != nil:
    section.add "$top", valid_597039
  var valid_597040 = query.getOrDefault("$skip")
  valid_597040 = validateParameter(valid_597040, JInt, required = false, default = nil)
  if valid_597040 != nil:
    section.add "$skip", valid_597040
  var valid_597041 = query.getOrDefault("$filter")
  valid_597041 = validateParameter(valid_597041, JString, required = true,
                                 default = nil)
  if valid_597041 != nil:
    section.add "$filter", valid_597041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597042: Call_ReportsListByRequest_597032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by Request.
  ## 
  let valid = call_597042.validator(path, query, header, formData, body)
  let scheme = call_597042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597042.url(scheme.get, call_597042.host, call_597042.base,
                         call_597042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597042, url, valid)

proc call*(call_597043: Call_ReportsListByRequest_597032;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Filter: string; Top: int = 0; Skip: int = 0): Recallable =
  ## reportsListByRequest
  ## Lists report records by Request.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string (required)
  ##         : The filter to apply on the operation.
  var path_597044 = newJObject()
  var query_597045 = newJObject()
  add(path_597044, "resourceGroupName", newJString(resourceGroupName))
  add(query_597045, "api-version", newJString(apiVersion))
  add(path_597044, "subscriptionId", newJString(subscriptionId))
  add(query_597045, "$top", newJInt(Top))
  add(query_597045, "$skip", newJInt(Skip))
  add(path_597044, "serviceName", newJString(serviceName))
  add(query_597045, "$filter", newJString(Filter))
  result = call_597043.call(path_597044, query_597045, nil, nil, nil)

var reportsListByRequest* = Call_ReportsListByRequest_597032(
    name: "reportsListByRequest", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byRequest",
    validator: validate_ReportsListByRequest_597033, base: "",
    url: url_ReportsListByRequest_597034, schemes: {Scheme.Https})
type
  Call_ReportsListBySubscription_597046 = ref object of OpenApiRestCall_596459
proc url_ReportsListBySubscription_597048(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/reports/bySubscription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsListBySubscription_597047(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists report records by subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597049 = path.getOrDefault("resourceGroupName")
  valid_597049 = validateParameter(valid_597049, JString, required = true,
                                 default = nil)
  if valid_597049 != nil:
    section.add "resourceGroupName", valid_597049
  var valid_597050 = path.getOrDefault("subscriptionId")
  valid_597050 = validateParameter(valid_597050, JString, required = true,
                                 default = nil)
  if valid_597050 != nil:
    section.add "subscriptionId", valid_597050
  var valid_597051 = path.getOrDefault("serviceName")
  valid_597051 = validateParameter(valid_597051, JString, required = true,
                                 default = nil)
  if valid_597051 != nil:
    section.add "serviceName", valid_597051
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
  var valid_597052 = query.getOrDefault("api-version")
  valid_597052 = validateParameter(valid_597052, JString, required = true,
                                 default = nil)
  if valid_597052 != nil:
    section.add "api-version", valid_597052
  var valid_597053 = query.getOrDefault("$top")
  valid_597053 = validateParameter(valid_597053, JInt, required = false, default = nil)
  if valid_597053 != nil:
    section.add "$top", valid_597053
  var valid_597054 = query.getOrDefault("$skip")
  valid_597054 = validateParameter(valid_597054, JInt, required = false, default = nil)
  if valid_597054 != nil:
    section.add "$skip", valid_597054
  var valid_597055 = query.getOrDefault("$filter")
  valid_597055 = validateParameter(valid_597055, JString, required = false,
                                 default = nil)
  if valid_597055 != nil:
    section.add "$filter", valid_597055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597056: Call_ReportsListBySubscription_597046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by subscription.
  ## 
  let valid = call_597056.validator(path, query, header, formData, body)
  let scheme = call_597056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597056.url(scheme.get, call_597056.host, call_597056.base,
                         call_597056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597056, url, valid)

proc call*(call_597057: Call_ReportsListBySubscription_597046;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## reportsListBySubscription
  ## Lists report records by subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_597058 = newJObject()
  var query_597059 = newJObject()
  add(path_597058, "resourceGroupName", newJString(resourceGroupName))
  add(query_597059, "api-version", newJString(apiVersion))
  add(path_597058, "subscriptionId", newJString(subscriptionId))
  add(query_597059, "$top", newJInt(Top))
  add(query_597059, "$skip", newJInt(Skip))
  add(path_597058, "serviceName", newJString(serviceName))
  add(query_597059, "$filter", newJString(Filter))
  result = call_597057.call(path_597058, query_597059, nil, nil, nil)

var reportsListBySubscription* = Call_ReportsListBySubscription_597046(
    name: "reportsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/bySubscription",
    validator: validate_ReportsListBySubscription_597047, base: "",
    url: url_ReportsListBySubscription_597048, schemes: {Scheme.Https})
type
  Call_ReportsListByTime_597060 = ref object of OpenApiRestCall_596459
proc url_ReportsListByTime_597062(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/reports/byTime")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsListByTime_597061(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists report records by Time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597063 = path.getOrDefault("resourceGroupName")
  valid_597063 = validateParameter(valid_597063, JString, required = true,
                                 default = nil)
  if valid_597063 != nil:
    section.add "resourceGroupName", valid_597063
  var valid_597064 = path.getOrDefault("subscriptionId")
  valid_597064 = validateParameter(valid_597064, JString, required = true,
                                 default = nil)
  if valid_597064 != nil:
    section.add "subscriptionId", valid_597064
  var valid_597065 = path.getOrDefault("serviceName")
  valid_597065 = validateParameter(valid_597065, JString, required = true,
                                 default = nil)
  if valid_597065 != nil:
    section.add "serviceName", valid_597065
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
  var valid_597066 = query.getOrDefault("api-version")
  valid_597066 = validateParameter(valid_597066, JString, required = true,
                                 default = nil)
  if valid_597066 != nil:
    section.add "api-version", valid_597066
  var valid_597067 = query.getOrDefault("$top")
  valid_597067 = validateParameter(valid_597067, JInt, required = false, default = nil)
  if valid_597067 != nil:
    section.add "$top", valid_597067
  var valid_597068 = query.getOrDefault("$skip")
  valid_597068 = validateParameter(valid_597068, JInt, required = false, default = nil)
  if valid_597068 != nil:
    section.add "$skip", valid_597068
  var valid_597069 = query.getOrDefault("interval")
  valid_597069 = validateParameter(valid_597069, JString, required = true,
                                 default = nil)
  if valid_597069 != nil:
    section.add "interval", valid_597069
  var valid_597070 = query.getOrDefault("$filter")
  valid_597070 = validateParameter(valid_597070, JString, required = false,
                                 default = nil)
  if valid_597070 != nil:
    section.add "$filter", valid_597070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597071: Call_ReportsListByTime_597060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by Time.
  ## 
  let valid = call_597071.validator(path, query, header, formData, body)
  let scheme = call_597071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597071.url(scheme.get, call_597071.host, call_597071.base,
                         call_597071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597071, url, valid)

proc call*(call_597072: Call_ReportsListByTime_597060; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; interval: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## reportsListByTime
  ## Lists report records by Time.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   interval: string (required)
  ##           : By time interval. Interval must be multiple of 15 minutes and may not be zero. The value should be in ISO  8601 format (http://en.wikipedia.org/wiki/ISO_8601#Durations).This code can be used to convert TimeSpan to a valid interval string: XmlConvert.ToString(new TimeSpan(hours, minutes, seconds))
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_597073 = newJObject()
  var query_597074 = newJObject()
  add(path_597073, "resourceGroupName", newJString(resourceGroupName))
  add(query_597074, "api-version", newJString(apiVersion))
  add(path_597073, "subscriptionId", newJString(subscriptionId))
  add(query_597074, "$top", newJInt(Top))
  add(query_597074, "$skip", newJInt(Skip))
  add(query_597074, "interval", newJString(interval))
  add(path_597073, "serviceName", newJString(serviceName))
  add(query_597074, "$filter", newJString(Filter))
  result = call_597072.call(path_597073, query_597074, nil, nil, nil)

var reportsListByTime* = Call_ReportsListByTime_597060(name: "reportsListByTime",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byTime",
    validator: validate_ReportsListByTime_597061, base: "",
    url: url_ReportsListByTime_597062, schemes: {Scheme.Https})
type
  Call_ReportsListByUser_597075 = ref object of OpenApiRestCall_596459
proc url_ReportsListByUser_597077(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/reports/byUser")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsListByUser_597076(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists report records by User.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597078 = path.getOrDefault("resourceGroupName")
  valid_597078 = validateParameter(valid_597078, JString, required = true,
                                 default = nil)
  if valid_597078 != nil:
    section.add "resourceGroupName", valid_597078
  var valid_597079 = path.getOrDefault("subscriptionId")
  valid_597079 = validateParameter(valid_597079, JString, required = true,
                                 default = nil)
  if valid_597079 != nil:
    section.add "subscriptionId", valid_597079
  var valid_597080 = path.getOrDefault("serviceName")
  valid_597080 = validateParameter(valid_597080, JString, required = true,
                                 default = nil)
  if valid_597080 != nil:
    section.add "serviceName", valid_597080
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
  var valid_597081 = query.getOrDefault("api-version")
  valid_597081 = validateParameter(valid_597081, JString, required = true,
                                 default = nil)
  if valid_597081 != nil:
    section.add "api-version", valid_597081
  var valid_597082 = query.getOrDefault("$top")
  valid_597082 = validateParameter(valid_597082, JInt, required = false, default = nil)
  if valid_597082 != nil:
    section.add "$top", valid_597082
  var valid_597083 = query.getOrDefault("$skip")
  valid_597083 = validateParameter(valid_597083, JInt, required = false, default = nil)
  if valid_597083 != nil:
    section.add "$skip", valid_597083
  var valid_597084 = query.getOrDefault("$filter")
  valid_597084 = validateParameter(valid_597084, JString, required = true,
                                 default = nil)
  if valid_597084 != nil:
    section.add "$filter", valid_597084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597085: Call_ReportsListByUser_597075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by User.
  ## 
  let valid = call_597085.validator(path, query, header, formData, body)
  let scheme = call_597085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597085.url(scheme.get, call_597085.host, call_597085.base,
                         call_597085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597085, url, valid)

proc call*(call_597086: Call_ReportsListByUser_597075; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Filter: string; Top: int = 0; Skip: int = 0): Recallable =
  ## reportsListByUser
  ## Lists report records by User.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string (required)
  ##         : The filter to apply on the operation.
  var path_597087 = newJObject()
  var query_597088 = newJObject()
  add(path_597087, "resourceGroupName", newJString(resourceGroupName))
  add(query_597088, "api-version", newJString(apiVersion))
  add(path_597087, "subscriptionId", newJString(subscriptionId))
  add(query_597088, "$top", newJInt(Top))
  add(query_597088, "$skip", newJInt(Skip))
  add(path_597087, "serviceName", newJString(serviceName))
  add(query_597088, "$filter", newJString(Filter))
  result = call_597086.call(path_597087, query_597088, nil, nil, nil)

var reportsListByUser* = Call_ReportsListByUser_597075(name: "reportsListByUser",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byUser",
    validator: validate_ReportsListByUser_597076, base: "",
    url: url_ReportsListByUser_597077, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
