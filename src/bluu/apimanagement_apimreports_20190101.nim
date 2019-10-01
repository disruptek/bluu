
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2019-01-01
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
  ##   $orderby: JString
  ##           : OData order by query option.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString (required)
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_596847 = query.getOrDefault("$orderby")
  valid_596847 = validateParameter(valid_596847, JString, required = false,
                                 default = nil)
  if valid_596847 != nil:
    section.add "$orderby", valid_596847
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596848 = query.getOrDefault("api-version")
  valid_596848 = validateParameter(valid_596848, JString, required = true,
                                 default = nil)
  if valid_596848 != nil:
    section.add "api-version", valid_596848
  var valid_596849 = query.getOrDefault("$top")
  valid_596849 = validateParameter(valid_596849, JInt, required = false, default = nil)
  if valid_596849 != nil:
    section.add "$top", valid_596849
  var valid_596850 = query.getOrDefault("$skip")
  valid_596850 = validateParameter(valid_596850, JInt, required = false, default = nil)
  if valid_596850 != nil:
    section.add "$skip", valid_596850
  var valid_596851 = query.getOrDefault("$filter")
  valid_596851 = validateParameter(valid_596851, JString, required = true,
                                 default = nil)
  if valid_596851 != nil:
    section.add "$filter", valid_596851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596878: Call_ReportsListByApi_596681; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by API.
  ## 
  let valid = call_596878.validator(path, query, header, formData, body)
  let scheme = call_596878.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596878.url(scheme.get, call_596878.host, call_596878.base,
                         call_596878.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596878, url, valid)

proc call*(call_596949: Call_ReportsListByApi_596681; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Filter: string; Orderby: string = ""; Top: int = 0; Skip: int = 0): Recallable =
  ## reportsListByApi
  ## Lists report records by API.
  ##   Orderby: string
  ##          : OData order by query option.
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
  var path_596950 = newJObject()
  var query_596952 = newJObject()
  add(query_596952, "$orderby", newJString(Orderby))
  add(path_596950, "resourceGroupName", newJString(resourceGroupName))
  add(query_596952, "api-version", newJString(apiVersion))
  add(path_596950, "subscriptionId", newJString(subscriptionId))
  add(query_596952, "$top", newJInt(Top))
  add(query_596952, "$skip", newJInt(Skip))
  add(path_596950, "serviceName", newJString(serviceName))
  add(query_596952, "$filter", newJString(Filter))
  result = call_596949.call(path_596950, query_596952, nil, nil, nil)

var reportsListByApi* = Call_ReportsListByApi_596681(name: "reportsListByApi",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byApi",
    validator: validate_ReportsListByApi_596682, base: "",
    url: url_ReportsListByApi_596683, schemes: {Scheme.Https})
type
  Call_ReportsListByGeo_596991 = ref object of OpenApiRestCall_596459
proc url_ReportsListByGeo_596993(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsListByGeo_596992(path: JsonNode; query: JsonNode;
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
  var valid_596994 = path.getOrDefault("resourceGroupName")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "resourceGroupName", valid_596994
  var valid_596995 = path.getOrDefault("subscriptionId")
  valid_596995 = validateParameter(valid_596995, JString, required = true,
                                 default = nil)
  if valid_596995 != nil:
    section.add "subscriptionId", valid_596995
  var valid_596996 = path.getOrDefault("serviceName")
  valid_596996 = validateParameter(valid_596996, JString, required = true,
                                 default = nil)
  if valid_596996 != nil:
    section.add "serviceName", valid_596996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString (required)
  ##          : |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| country | select |     |     | </br>| region | select |     |     | </br>| zip | select |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | filter | eq |     | </br>| productId | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| apiId | filter | eq |     | </br>| operationId | filter | eq |     | </br>| callCountSuccess | select |     |     | </br>| callCountBlocked | select |     |     | </br>| callCountFailed | select |     |     | </br>| callCountOther | select |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596997 = query.getOrDefault("api-version")
  valid_596997 = validateParameter(valid_596997, JString, required = true,
                                 default = nil)
  if valid_596997 != nil:
    section.add "api-version", valid_596997
  var valid_596998 = query.getOrDefault("$top")
  valid_596998 = validateParameter(valid_596998, JInt, required = false, default = nil)
  if valid_596998 != nil:
    section.add "$top", valid_596998
  var valid_596999 = query.getOrDefault("$skip")
  valid_596999 = validateParameter(valid_596999, JInt, required = false, default = nil)
  if valid_596999 != nil:
    section.add "$skip", valid_596999
  var valid_597000 = query.getOrDefault("$filter")
  valid_597000 = validateParameter(valid_597000, JString, required = true,
                                 default = nil)
  if valid_597000 != nil:
    section.add "$filter", valid_597000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597001: Call_ReportsListByGeo_596991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by geography.
  ## 
  let valid = call_597001.validator(path, query, header, formData, body)
  let scheme = call_597001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597001.url(scheme.get, call_597001.host, call_597001.base,
                         call_597001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597001, url, valid)

proc call*(call_597002: Call_ReportsListByGeo_596991; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Filter: string; Top: int = 0; Skip: int = 0): Recallable =
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
  ##   Filter: string (required)
  ##         : |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| country | select |     |     | </br>| region | select |     |     | </br>| zip | select |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | filter | eq |     | </br>| productId | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| apiId | filter | eq |     | </br>| operationId | filter | eq |     | </br>| callCountSuccess | select |     |     | </br>| callCountBlocked | select |     |     | </br>| callCountFailed | select |     |     | </br>| callCountOther | select |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>
  var path_597003 = newJObject()
  var query_597004 = newJObject()
  add(path_597003, "resourceGroupName", newJString(resourceGroupName))
  add(query_597004, "api-version", newJString(apiVersion))
  add(path_597003, "subscriptionId", newJString(subscriptionId))
  add(query_597004, "$top", newJInt(Top))
  add(query_597004, "$skip", newJInt(Skip))
  add(path_597003, "serviceName", newJString(serviceName))
  add(query_597004, "$filter", newJString(Filter))
  result = call_597002.call(path_597003, query_597004, nil, nil, nil)

var reportsListByGeo* = Call_ReportsListByGeo_596991(name: "reportsListByGeo",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byGeo",
    validator: validate_ReportsListByGeo_596992, base: "",
    url: url_ReportsListByGeo_596993, schemes: {Scheme.Https})
type
  Call_ReportsListByOperation_597005 = ref object of OpenApiRestCall_596459
proc url_ReportsListByOperation_597007(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsListByOperation_597006(path: JsonNode; query: JsonNode;
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
  var valid_597008 = path.getOrDefault("resourceGroupName")
  valid_597008 = validateParameter(valid_597008, JString, required = true,
                                 default = nil)
  if valid_597008 != nil:
    section.add "resourceGroupName", valid_597008
  var valid_597009 = path.getOrDefault("subscriptionId")
  valid_597009 = validateParameter(valid_597009, JString, required = true,
                                 default = nil)
  if valid_597009 != nil:
    section.add "subscriptionId", valid_597009
  var valid_597010 = path.getOrDefault("serviceName")
  valid_597010 = validateParameter(valid_597010, JString, required = true,
                                 default = nil)
  if valid_597010 != nil:
    section.add "serviceName", valid_597010
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OData order by query option.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString (required)
  ##          : |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| displayName | select, orderBy |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | filter | eq |     | </br>| productId | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| apiId | filter | eq |     | </br>| operationId | select, filter | eq |     | </br>| callCountSuccess | select, orderBy |     |     | </br>| callCountBlocked | select, orderBy |     |     | </br>| callCountFailed | select, orderBy |     |     | </br>| callCountOther | select, orderBy |     |     | </br>| callCountTotal | select, orderBy |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select, orderBy |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>
  section = newJObject()
  var valid_597011 = query.getOrDefault("$orderby")
  valid_597011 = validateParameter(valid_597011, JString, required = false,
                                 default = nil)
  if valid_597011 != nil:
    section.add "$orderby", valid_597011
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597012 = query.getOrDefault("api-version")
  valid_597012 = validateParameter(valid_597012, JString, required = true,
                                 default = nil)
  if valid_597012 != nil:
    section.add "api-version", valid_597012
  var valid_597013 = query.getOrDefault("$top")
  valid_597013 = validateParameter(valid_597013, JInt, required = false, default = nil)
  if valid_597013 != nil:
    section.add "$top", valid_597013
  var valid_597014 = query.getOrDefault("$skip")
  valid_597014 = validateParameter(valid_597014, JInt, required = false, default = nil)
  if valid_597014 != nil:
    section.add "$skip", valid_597014
  var valid_597015 = query.getOrDefault("$filter")
  valid_597015 = validateParameter(valid_597015, JString, required = true,
                                 default = nil)
  if valid_597015 != nil:
    section.add "$filter", valid_597015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597016: Call_ReportsListByOperation_597005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by API Operations.
  ## 
  let valid = call_597016.validator(path, query, header, formData, body)
  let scheme = call_597016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597016.url(scheme.get, call_597016.host, call_597016.base,
                         call_597016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597016, url, valid)

proc call*(call_597017: Call_ReportsListByOperation_597005;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Filter: string; Orderby: string = ""; Top: int = 0;
          Skip: int = 0): Recallable =
  ## reportsListByOperation
  ## Lists report records by API Operations.
  ##   Orderby: string
  ##          : OData order by query option.
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
  ##         : |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| displayName | select, orderBy |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | filter | eq |     | </br>| productId | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| apiId | filter | eq |     | </br>| operationId | select, filter | eq |     | </br>| callCountSuccess | select, orderBy |     |     | </br>| callCountBlocked | select, orderBy |     |     | </br>| callCountFailed | select, orderBy |     |     | </br>| callCountOther | select, orderBy |     |     | </br>| callCountTotal | select, orderBy |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select, orderBy |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>
  var path_597018 = newJObject()
  var query_597019 = newJObject()
  add(query_597019, "$orderby", newJString(Orderby))
  add(path_597018, "resourceGroupName", newJString(resourceGroupName))
  add(query_597019, "api-version", newJString(apiVersion))
  add(path_597018, "subscriptionId", newJString(subscriptionId))
  add(query_597019, "$top", newJInt(Top))
  add(query_597019, "$skip", newJInt(Skip))
  add(path_597018, "serviceName", newJString(serviceName))
  add(query_597019, "$filter", newJString(Filter))
  result = call_597017.call(path_597018, query_597019, nil, nil, nil)

var reportsListByOperation* = Call_ReportsListByOperation_597005(
    name: "reportsListByOperation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byOperation",
    validator: validate_ReportsListByOperation_597006, base: "",
    url: url_ReportsListByOperation_597007, schemes: {Scheme.Https})
type
  Call_ReportsListByProduct_597020 = ref object of OpenApiRestCall_596459
proc url_ReportsListByProduct_597022(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsListByProduct_597021(path: JsonNode; query: JsonNode;
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
  var valid_597023 = path.getOrDefault("resourceGroupName")
  valid_597023 = validateParameter(valid_597023, JString, required = true,
                                 default = nil)
  if valid_597023 != nil:
    section.add "resourceGroupName", valid_597023
  var valid_597024 = path.getOrDefault("subscriptionId")
  valid_597024 = validateParameter(valid_597024, JString, required = true,
                                 default = nil)
  if valid_597024 != nil:
    section.add "subscriptionId", valid_597024
  var valid_597025 = path.getOrDefault("serviceName")
  valid_597025 = validateParameter(valid_597025, JString, required = true,
                                 default = nil)
  if valid_597025 != nil:
    section.add "serviceName", valid_597025
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OData order by query option.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString (required)
  ##          : |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| displayName | select, orderBy |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | filter | eq |     | </br>| productId | select, filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| callCountSuccess | select, orderBy |     |     | </br>| callCountBlocked | select, orderBy |     |     | </br>| callCountFailed | select, orderBy |     |     | </br>| callCountOther | select, orderBy |     |     | </br>| callCountTotal | select, orderBy |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select, orderBy |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>
  section = newJObject()
  var valid_597026 = query.getOrDefault("$orderby")
  valid_597026 = validateParameter(valid_597026, JString, required = false,
                                 default = nil)
  if valid_597026 != nil:
    section.add "$orderby", valid_597026
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597027 = query.getOrDefault("api-version")
  valid_597027 = validateParameter(valid_597027, JString, required = true,
                                 default = nil)
  if valid_597027 != nil:
    section.add "api-version", valid_597027
  var valid_597028 = query.getOrDefault("$top")
  valid_597028 = validateParameter(valid_597028, JInt, required = false, default = nil)
  if valid_597028 != nil:
    section.add "$top", valid_597028
  var valid_597029 = query.getOrDefault("$skip")
  valid_597029 = validateParameter(valid_597029, JInt, required = false, default = nil)
  if valid_597029 != nil:
    section.add "$skip", valid_597029
  var valid_597030 = query.getOrDefault("$filter")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "$filter", valid_597030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597031: Call_ReportsListByProduct_597020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by Product.
  ## 
  let valid = call_597031.validator(path, query, header, formData, body)
  let scheme = call_597031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597031.url(scheme.get, call_597031.host, call_597031.base,
                         call_597031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597031, url, valid)

proc call*(call_597032: Call_ReportsListByProduct_597020;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Filter: string; Orderby: string = ""; Top: int = 0;
          Skip: int = 0): Recallable =
  ## reportsListByProduct
  ## Lists report records by Product.
  ##   Orderby: string
  ##          : OData order by query option.
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
  ##         : |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| displayName | select, orderBy |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | filter | eq |     | </br>| productId | select, filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| callCountSuccess | select, orderBy |     |     | </br>| callCountBlocked | select, orderBy |     |     | </br>| callCountFailed | select, orderBy |     |     | </br>| callCountOther | select, orderBy |     |     | </br>| callCountTotal | select, orderBy |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select, orderBy |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>
  var path_597033 = newJObject()
  var query_597034 = newJObject()
  add(query_597034, "$orderby", newJString(Orderby))
  add(path_597033, "resourceGroupName", newJString(resourceGroupName))
  add(query_597034, "api-version", newJString(apiVersion))
  add(path_597033, "subscriptionId", newJString(subscriptionId))
  add(query_597034, "$top", newJInt(Top))
  add(query_597034, "$skip", newJInt(Skip))
  add(path_597033, "serviceName", newJString(serviceName))
  add(query_597034, "$filter", newJString(Filter))
  result = call_597032.call(path_597033, query_597034, nil, nil, nil)

var reportsListByProduct* = Call_ReportsListByProduct_597020(
    name: "reportsListByProduct", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byProduct",
    validator: validate_ReportsListByProduct_597021, base: "",
    url: url_ReportsListByProduct_597022, schemes: {Scheme.Https})
type
  Call_ReportsListByRequest_597035 = ref object of OpenApiRestCall_596459
proc url_ReportsListByRequest_597037(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsListByRequest_597036(path: JsonNode; query: JsonNode;
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
  var valid_597038 = path.getOrDefault("resourceGroupName")
  valid_597038 = validateParameter(valid_597038, JString, required = true,
                                 default = nil)
  if valid_597038 != nil:
    section.add "resourceGroupName", valid_597038
  var valid_597039 = path.getOrDefault("subscriptionId")
  valid_597039 = validateParameter(valid_597039, JString, required = true,
                                 default = nil)
  if valid_597039 != nil:
    section.add "subscriptionId", valid_597039
  var valid_597040 = path.getOrDefault("serviceName")
  valid_597040 = validateParameter(valid_597040, JString, required = true,
                                 default = nil)
  if valid_597040 != nil:
    section.add "serviceName", valid_597040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString (required)
  ##          : |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| apiId | filter | eq |     | </br>| operationId | filter | eq |     | </br>| productId | filter | eq |     | </br>| userId | filter | eq |     | </br>| apiRegion | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597041 = query.getOrDefault("api-version")
  valid_597041 = validateParameter(valid_597041, JString, required = true,
                                 default = nil)
  if valid_597041 != nil:
    section.add "api-version", valid_597041
  var valid_597042 = query.getOrDefault("$top")
  valid_597042 = validateParameter(valid_597042, JInt, required = false, default = nil)
  if valid_597042 != nil:
    section.add "$top", valid_597042
  var valid_597043 = query.getOrDefault("$skip")
  valid_597043 = validateParameter(valid_597043, JInt, required = false, default = nil)
  if valid_597043 != nil:
    section.add "$skip", valid_597043
  var valid_597044 = query.getOrDefault("$filter")
  valid_597044 = validateParameter(valid_597044, JString, required = true,
                                 default = nil)
  if valid_597044 != nil:
    section.add "$filter", valid_597044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597045: Call_ReportsListByRequest_597035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by Request.
  ## 
  let valid = call_597045.validator(path, query, header, formData, body)
  let scheme = call_597045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597045.url(scheme.get, call_597045.host, call_597045.base,
                         call_597045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597045, url, valid)

proc call*(call_597046: Call_ReportsListByRequest_597035;
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
  ##         : |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| apiId | filter | eq |     | </br>| operationId | filter | eq |     | </br>| productId | filter | eq |     | </br>| userId | filter | eq |     | </br>| apiRegion | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>
  var path_597047 = newJObject()
  var query_597048 = newJObject()
  add(path_597047, "resourceGroupName", newJString(resourceGroupName))
  add(query_597048, "api-version", newJString(apiVersion))
  add(path_597047, "subscriptionId", newJString(subscriptionId))
  add(query_597048, "$top", newJInt(Top))
  add(query_597048, "$skip", newJInt(Skip))
  add(path_597047, "serviceName", newJString(serviceName))
  add(query_597048, "$filter", newJString(Filter))
  result = call_597046.call(path_597047, query_597048, nil, nil, nil)

var reportsListByRequest* = Call_ReportsListByRequest_597035(
    name: "reportsListByRequest", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byRequest",
    validator: validate_ReportsListByRequest_597036, base: "",
    url: url_ReportsListByRequest_597037, schemes: {Scheme.Https})
type
  Call_ReportsListBySubscription_597049 = ref object of OpenApiRestCall_596459
proc url_ReportsListBySubscription_597051(protocol: Scheme; host: string;
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

proc validate_ReportsListBySubscription_597050(path: JsonNode; query: JsonNode;
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
  var valid_597052 = path.getOrDefault("resourceGroupName")
  valid_597052 = validateParameter(valid_597052, JString, required = true,
                                 default = nil)
  if valid_597052 != nil:
    section.add "resourceGroupName", valid_597052
  var valid_597053 = path.getOrDefault("subscriptionId")
  valid_597053 = validateParameter(valid_597053, JString, required = true,
                                 default = nil)
  if valid_597053 != nil:
    section.add "subscriptionId", valid_597053
  var valid_597054 = path.getOrDefault("serviceName")
  valid_597054 = validateParameter(valid_597054, JString, required = true,
                                 default = nil)
  if valid_597054 != nil:
    section.add "serviceName", valid_597054
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OData order by query option.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString (required)
  ##          : |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| displayName | select, orderBy |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | select, filter | eq |     | </br>| productId | select, filter | eq |     | </br>| subscriptionId | select, filter | eq |     | </br>| callCountSuccess | select, orderBy |     |     | </br>| callCountBlocked | select, orderBy |     |     | </br>| callCountFailed | select, orderBy |     |     | </br>| callCountOther | select, orderBy |     |     | </br>| callCountTotal | select, orderBy |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select, orderBy |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>
  section = newJObject()
  var valid_597055 = query.getOrDefault("$orderby")
  valid_597055 = validateParameter(valid_597055, JString, required = false,
                                 default = nil)
  if valid_597055 != nil:
    section.add "$orderby", valid_597055
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597056 = query.getOrDefault("api-version")
  valid_597056 = validateParameter(valid_597056, JString, required = true,
                                 default = nil)
  if valid_597056 != nil:
    section.add "api-version", valid_597056
  var valid_597057 = query.getOrDefault("$top")
  valid_597057 = validateParameter(valid_597057, JInt, required = false, default = nil)
  if valid_597057 != nil:
    section.add "$top", valid_597057
  var valid_597058 = query.getOrDefault("$skip")
  valid_597058 = validateParameter(valid_597058, JInt, required = false, default = nil)
  if valid_597058 != nil:
    section.add "$skip", valid_597058
  var valid_597059 = query.getOrDefault("$filter")
  valid_597059 = validateParameter(valid_597059, JString, required = true,
                                 default = nil)
  if valid_597059 != nil:
    section.add "$filter", valid_597059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597060: Call_ReportsListBySubscription_597049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by subscription.
  ## 
  let valid = call_597060.validator(path, query, header, formData, body)
  let scheme = call_597060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597060.url(scheme.get, call_597060.host, call_597060.base,
                         call_597060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597060, url, valid)

proc call*(call_597061: Call_ReportsListBySubscription_597049;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Filter: string; Orderby: string = ""; Top: int = 0;
          Skip: int = 0): Recallable =
  ## reportsListBySubscription
  ## Lists report records by subscription.
  ##   Orderby: string
  ##          : OData order by query option.
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
  ##         : |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| displayName | select, orderBy |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | select, filter | eq |     | </br>| productId | select, filter | eq |     | </br>| subscriptionId | select, filter | eq |     | </br>| callCountSuccess | select, orderBy |     |     | </br>| callCountBlocked | select, orderBy |     |     | </br>| callCountFailed | select, orderBy |     |     | </br>| callCountOther | select, orderBy |     |     | </br>| callCountTotal | select, orderBy |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select, orderBy |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>
  var path_597062 = newJObject()
  var query_597063 = newJObject()
  add(query_597063, "$orderby", newJString(Orderby))
  add(path_597062, "resourceGroupName", newJString(resourceGroupName))
  add(query_597063, "api-version", newJString(apiVersion))
  add(path_597062, "subscriptionId", newJString(subscriptionId))
  add(query_597063, "$top", newJInt(Top))
  add(query_597063, "$skip", newJInt(Skip))
  add(path_597062, "serviceName", newJString(serviceName))
  add(query_597063, "$filter", newJString(Filter))
  result = call_597061.call(path_597062, query_597063, nil, nil, nil)

var reportsListBySubscription* = Call_ReportsListBySubscription_597049(
    name: "reportsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/bySubscription",
    validator: validate_ReportsListBySubscription_597050, base: "",
    url: url_ReportsListBySubscription_597051, schemes: {Scheme.Https})
type
  Call_ReportsListByTime_597064 = ref object of OpenApiRestCall_596459
proc url_ReportsListByTime_597066(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsListByTime_597065(path: JsonNode; query: JsonNode;
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
  var valid_597067 = path.getOrDefault("resourceGroupName")
  valid_597067 = validateParameter(valid_597067, JString, required = true,
                                 default = nil)
  if valid_597067 != nil:
    section.add "resourceGroupName", valid_597067
  var valid_597068 = path.getOrDefault("subscriptionId")
  valid_597068 = validateParameter(valid_597068, JString, required = true,
                                 default = nil)
  if valid_597068 != nil:
    section.add "subscriptionId", valid_597068
  var valid_597069 = path.getOrDefault("serviceName")
  valid_597069 = validateParameter(valid_597069, JString, required = true,
                                 default = nil)
  if valid_597069 != nil:
    section.add "serviceName", valid_597069
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OData order by query option.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   interval: JString (required)
  ##           : By time interval. Interval must be multiple of 15 minutes and may not be zero. The value should be in ISO  8601 format (http://en.wikipedia.org/wiki/ISO_8601#Durations).This code can be used to convert TimeSpan to a valid interval string: XmlConvert.ToString(new TimeSpan(hours, minutes, seconds)).
  ##   $filter: JString (required)
  ##          : |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter, select | ge, le |     | </br>| interval | select |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | filter | eq |     | </br>| productId | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| apiId | filter | eq |     | </br>| operationId | filter | eq |     | </br>| callCountSuccess | select |     |     | </br>| callCountBlocked | select |     |     | </br>| callCountFailed | select |     |     | </br>| callCountOther | select |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>
  section = newJObject()
  var valid_597070 = query.getOrDefault("$orderby")
  valid_597070 = validateParameter(valid_597070, JString, required = false,
                                 default = nil)
  if valid_597070 != nil:
    section.add "$orderby", valid_597070
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597071 = query.getOrDefault("api-version")
  valid_597071 = validateParameter(valid_597071, JString, required = true,
                                 default = nil)
  if valid_597071 != nil:
    section.add "api-version", valid_597071
  var valid_597072 = query.getOrDefault("$top")
  valid_597072 = validateParameter(valid_597072, JInt, required = false, default = nil)
  if valid_597072 != nil:
    section.add "$top", valid_597072
  var valid_597073 = query.getOrDefault("$skip")
  valid_597073 = validateParameter(valid_597073, JInt, required = false, default = nil)
  if valid_597073 != nil:
    section.add "$skip", valid_597073
  var valid_597074 = query.getOrDefault("interval")
  valid_597074 = validateParameter(valid_597074, JString, required = true,
                                 default = nil)
  if valid_597074 != nil:
    section.add "interval", valid_597074
  var valid_597075 = query.getOrDefault("$filter")
  valid_597075 = validateParameter(valid_597075, JString, required = true,
                                 default = nil)
  if valid_597075 != nil:
    section.add "$filter", valid_597075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597076: Call_ReportsListByTime_597064; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by Time.
  ## 
  let valid = call_597076.validator(path, query, header, formData, body)
  let scheme = call_597076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597076.url(scheme.get, call_597076.host, call_597076.base,
                         call_597076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597076, url, valid)

proc call*(call_597077: Call_ReportsListByTime_597064; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; interval: string;
          serviceName: string; Filter: string; Orderby: string = ""; Top: int = 0;
          Skip: int = 0): Recallable =
  ## reportsListByTime
  ## Lists report records by Time.
  ##   Orderby: string
  ##          : OData order by query option.
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
  ##           : By time interval. Interval must be multiple of 15 minutes and may not be zero. The value should be in ISO  8601 format (http://en.wikipedia.org/wiki/ISO_8601#Durations).This code can be used to convert TimeSpan to a valid interval string: XmlConvert.ToString(new TimeSpan(hours, minutes, seconds)).
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string (required)
  ##         : |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter, select | ge, le |     | </br>| interval | select |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | filter | eq |     | </br>| productId | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| apiId | filter | eq |     | </br>| operationId | filter | eq |     | </br>| callCountSuccess | select |     |     | </br>| callCountBlocked | select |     |     | </br>| callCountFailed | select |     |     | </br>| callCountOther | select |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>
  var path_597078 = newJObject()
  var query_597079 = newJObject()
  add(query_597079, "$orderby", newJString(Orderby))
  add(path_597078, "resourceGroupName", newJString(resourceGroupName))
  add(query_597079, "api-version", newJString(apiVersion))
  add(path_597078, "subscriptionId", newJString(subscriptionId))
  add(query_597079, "$top", newJInt(Top))
  add(query_597079, "$skip", newJInt(Skip))
  add(query_597079, "interval", newJString(interval))
  add(path_597078, "serviceName", newJString(serviceName))
  add(query_597079, "$filter", newJString(Filter))
  result = call_597077.call(path_597078, query_597079, nil, nil, nil)

var reportsListByTime* = Call_ReportsListByTime_597064(name: "reportsListByTime",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byTime",
    validator: validate_ReportsListByTime_597065, base: "",
    url: url_ReportsListByTime_597066, schemes: {Scheme.Https})
type
  Call_ReportsListByUser_597080 = ref object of OpenApiRestCall_596459
proc url_ReportsListByUser_597082(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsListByUser_597081(path: JsonNode; query: JsonNode;
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
  var valid_597083 = path.getOrDefault("resourceGroupName")
  valid_597083 = validateParameter(valid_597083, JString, required = true,
                                 default = nil)
  if valid_597083 != nil:
    section.add "resourceGroupName", valid_597083
  var valid_597084 = path.getOrDefault("subscriptionId")
  valid_597084 = validateParameter(valid_597084, JString, required = true,
                                 default = nil)
  if valid_597084 != nil:
    section.add "subscriptionId", valid_597084
  var valid_597085 = path.getOrDefault("serviceName")
  valid_597085 = validateParameter(valid_597085, JString, required = true,
                                 default = nil)
  if valid_597085 != nil:
    section.add "serviceName", valid_597085
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : OData order by query option.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString (required)
  ##          : |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| displayName | select, orderBy |     |     | </br>| userId | select, filter | eq |     | </br>| apiRegion | filter | eq |     | </br>| productId | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| apiId | filter | eq |     | </br>| operationId | filter | eq |     | </br>| callCountSuccess | select, orderBy |     |     | </br>| callCountBlocked | select, orderBy |     |     | </br>| callCountFailed | select, orderBy |     |     | </br>| callCountOther | select, orderBy |     |     | </br>| callCountTotal | select, orderBy |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select, orderBy |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>
  section = newJObject()
  var valid_597086 = query.getOrDefault("$orderby")
  valid_597086 = validateParameter(valid_597086, JString, required = false,
                                 default = nil)
  if valid_597086 != nil:
    section.add "$orderby", valid_597086
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597087 = query.getOrDefault("api-version")
  valid_597087 = validateParameter(valid_597087, JString, required = true,
                                 default = nil)
  if valid_597087 != nil:
    section.add "api-version", valid_597087
  var valid_597088 = query.getOrDefault("$top")
  valid_597088 = validateParameter(valid_597088, JInt, required = false, default = nil)
  if valid_597088 != nil:
    section.add "$top", valid_597088
  var valid_597089 = query.getOrDefault("$skip")
  valid_597089 = validateParameter(valid_597089, JInt, required = false, default = nil)
  if valid_597089 != nil:
    section.add "$skip", valid_597089
  var valid_597090 = query.getOrDefault("$filter")
  valid_597090 = validateParameter(valid_597090, JString, required = true,
                                 default = nil)
  if valid_597090 != nil:
    section.add "$filter", valid_597090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597091: Call_ReportsListByUser_597080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by User.
  ## 
  let valid = call_597091.validator(path, query, header, formData, body)
  let scheme = call_597091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597091.url(scheme.get, call_597091.host, call_597091.base,
                         call_597091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597091, url, valid)

proc call*(call_597092: Call_ReportsListByUser_597080; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Filter: string; Orderby: string = ""; Top: int = 0; Skip: int = 0): Recallable =
  ## reportsListByUser
  ## Lists report records by User.
  ##   Orderby: string
  ##          : OData order by query option.
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
  ##         : |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| displayName | select, orderBy |     |     | </br>| userId | select, filter | eq |     | </br>| apiRegion | filter | eq |     | </br>| productId | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| apiId | filter | eq |     | </br>| operationId | filter | eq |     | </br>| callCountSuccess | select, orderBy |     |     | </br>| callCountBlocked | select, orderBy |     |     | </br>| callCountFailed | select, orderBy |     |     | </br>| callCountOther | select, orderBy |     |     | </br>| callCountTotal | select, orderBy |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select, orderBy |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>
  var path_597093 = newJObject()
  var query_597094 = newJObject()
  add(query_597094, "$orderby", newJString(Orderby))
  add(path_597093, "resourceGroupName", newJString(resourceGroupName))
  add(query_597094, "api-version", newJString(apiVersion))
  add(path_597093, "subscriptionId", newJString(subscriptionId))
  add(query_597094, "$top", newJInt(Top))
  add(query_597094, "$skip", newJInt(Skip))
  add(path_597093, "serviceName", newJString(serviceName))
  add(query_597094, "$filter", newJString(Filter))
  result = call_597092.call(path_597093, query_597094, nil, nil, nil)

var reportsListByUser* = Call_ReportsListByUser_597080(name: "reportsListByUser",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byUser",
    validator: validate_ReportsListByUser_597081, base: "",
    url: url_ReportsListByUser_597082, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
