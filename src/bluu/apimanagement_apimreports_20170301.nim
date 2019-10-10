
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_573659 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573659](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573659): Option[Scheme] {.used.} =
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
  Call_ReportsListByApi_573881 = ref object of OpenApiRestCall_573659
proc url_ReportsListByApi_573883(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsListByApi_573882(path: JsonNode; query: JsonNode;
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
  var valid_574044 = path.getOrDefault("resourceGroupName")
  valid_574044 = validateParameter(valid_574044, JString, required = true,
                                 default = nil)
  if valid_574044 != nil:
    section.add "resourceGroupName", valid_574044
  var valid_574045 = path.getOrDefault("subscriptionId")
  valid_574045 = validateParameter(valid_574045, JString, required = true,
                                 default = nil)
  if valid_574045 != nil:
    section.add "subscriptionId", valid_574045
  var valid_574046 = path.getOrDefault("serviceName")
  valid_574046 = validateParameter(valid_574046, JString, required = true,
                                 default = nil)
  if valid_574046 != nil:
    section.add "serviceName", valid_574046
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
  var valid_574047 = query.getOrDefault("api-version")
  valid_574047 = validateParameter(valid_574047, JString, required = true,
                                 default = nil)
  if valid_574047 != nil:
    section.add "api-version", valid_574047
  var valid_574048 = query.getOrDefault("$top")
  valid_574048 = validateParameter(valid_574048, JInt, required = false, default = nil)
  if valid_574048 != nil:
    section.add "$top", valid_574048
  var valid_574049 = query.getOrDefault("$skip")
  valid_574049 = validateParameter(valid_574049, JInt, required = false, default = nil)
  if valid_574049 != nil:
    section.add "$skip", valid_574049
  var valid_574050 = query.getOrDefault("$filter")
  valid_574050 = validateParameter(valid_574050, JString, required = true,
                                 default = nil)
  if valid_574050 != nil:
    section.add "$filter", valid_574050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574077: Call_ReportsListByApi_573881; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by API.
  ## 
  let valid = call_574077.validator(path, query, header, formData, body)
  let scheme = call_574077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574077.url(scheme.get, call_574077.host, call_574077.base,
                         call_574077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574077, url, valid)

proc call*(call_574148: Call_ReportsListByApi_573881; resourceGroupName: string;
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
  var path_574149 = newJObject()
  var query_574151 = newJObject()
  add(path_574149, "resourceGroupName", newJString(resourceGroupName))
  add(query_574151, "api-version", newJString(apiVersion))
  add(path_574149, "subscriptionId", newJString(subscriptionId))
  add(query_574151, "$top", newJInt(Top))
  add(query_574151, "$skip", newJInt(Skip))
  add(path_574149, "serviceName", newJString(serviceName))
  add(query_574151, "$filter", newJString(Filter))
  result = call_574148.call(path_574149, query_574151, nil, nil, nil)

var reportsListByApi* = Call_ReportsListByApi_573881(name: "reportsListByApi",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byApi",
    validator: validate_ReportsListByApi_573882, base: "",
    url: url_ReportsListByApi_573883, schemes: {Scheme.Https})
type
  Call_ReportsListByGeo_574190 = ref object of OpenApiRestCall_573659
proc url_ReportsListByGeo_574192(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsListByGeo_574191(path: JsonNode; query: JsonNode;
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
  var valid_574193 = path.getOrDefault("resourceGroupName")
  valid_574193 = validateParameter(valid_574193, JString, required = true,
                                 default = nil)
  if valid_574193 != nil:
    section.add "resourceGroupName", valid_574193
  var valid_574194 = path.getOrDefault("subscriptionId")
  valid_574194 = validateParameter(valid_574194, JString, required = true,
                                 default = nil)
  if valid_574194 != nil:
    section.add "subscriptionId", valid_574194
  var valid_574195 = path.getOrDefault("serviceName")
  valid_574195 = validateParameter(valid_574195, JString, required = true,
                                 default = nil)
  if valid_574195 != nil:
    section.add "serviceName", valid_574195
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
  var valid_574196 = query.getOrDefault("api-version")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "api-version", valid_574196
  var valid_574197 = query.getOrDefault("$top")
  valid_574197 = validateParameter(valid_574197, JInt, required = false, default = nil)
  if valid_574197 != nil:
    section.add "$top", valid_574197
  var valid_574198 = query.getOrDefault("$skip")
  valid_574198 = validateParameter(valid_574198, JInt, required = false, default = nil)
  if valid_574198 != nil:
    section.add "$skip", valid_574198
  var valid_574199 = query.getOrDefault("$filter")
  valid_574199 = validateParameter(valid_574199, JString, required = false,
                                 default = nil)
  if valid_574199 != nil:
    section.add "$filter", valid_574199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574200: Call_ReportsListByGeo_574190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by geography.
  ## 
  let valid = call_574200.validator(path, query, header, formData, body)
  let scheme = call_574200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574200.url(scheme.get, call_574200.host, call_574200.base,
                         call_574200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574200, url, valid)

proc call*(call_574201: Call_ReportsListByGeo_574190; resourceGroupName: string;
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
  var path_574202 = newJObject()
  var query_574203 = newJObject()
  add(path_574202, "resourceGroupName", newJString(resourceGroupName))
  add(query_574203, "api-version", newJString(apiVersion))
  add(path_574202, "subscriptionId", newJString(subscriptionId))
  add(query_574203, "$top", newJInt(Top))
  add(query_574203, "$skip", newJInt(Skip))
  add(path_574202, "serviceName", newJString(serviceName))
  add(query_574203, "$filter", newJString(Filter))
  result = call_574201.call(path_574202, query_574203, nil, nil, nil)

var reportsListByGeo* = Call_ReportsListByGeo_574190(name: "reportsListByGeo",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byGeo",
    validator: validate_ReportsListByGeo_574191, base: "",
    url: url_ReportsListByGeo_574192, schemes: {Scheme.Https})
type
  Call_ReportsListByOperation_574204 = ref object of OpenApiRestCall_573659
proc url_ReportsListByOperation_574206(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsListByOperation_574205(path: JsonNode; query: JsonNode;
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
  var valid_574207 = path.getOrDefault("resourceGroupName")
  valid_574207 = validateParameter(valid_574207, JString, required = true,
                                 default = nil)
  if valid_574207 != nil:
    section.add "resourceGroupName", valid_574207
  var valid_574208 = path.getOrDefault("subscriptionId")
  valid_574208 = validateParameter(valid_574208, JString, required = true,
                                 default = nil)
  if valid_574208 != nil:
    section.add "subscriptionId", valid_574208
  var valid_574209 = path.getOrDefault("serviceName")
  valid_574209 = validateParameter(valid_574209, JString, required = true,
                                 default = nil)
  if valid_574209 != nil:
    section.add "serviceName", valid_574209
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
  var valid_574210 = query.getOrDefault("api-version")
  valid_574210 = validateParameter(valid_574210, JString, required = true,
                                 default = nil)
  if valid_574210 != nil:
    section.add "api-version", valid_574210
  var valid_574211 = query.getOrDefault("$top")
  valid_574211 = validateParameter(valid_574211, JInt, required = false, default = nil)
  if valid_574211 != nil:
    section.add "$top", valid_574211
  var valid_574212 = query.getOrDefault("$skip")
  valid_574212 = validateParameter(valid_574212, JInt, required = false, default = nil)
  if valid_574212 != nil:
    section.add "$skip", valid_574212
  var valid_574213 = query.getOrDefault("$filter")
  valid_574213 = validateParameter(valid_574213, JString, required = true,
                                 default = nil)
  if valid_574213 != nil:
    section.add "$filter", valid_574213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574214: Call_ReportsListByOperation_574204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by API Operations.
  ## 
  let valid = call_574214.validator(path, query, header, formData, body)
  let scheme = call_574214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574214.url(scheme.get, call_574214.host, call_574214.base,
                         call_574214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574214, url, valid)

proc call*(call_574215: Call_ReportsListByOperation_574204;
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
  var path_574216 = newJObject()
  var query_574217 = newJObject()
  add(path_574216, "resourceGroupName", newJString(resourceGroupName))
  add(query_574217, "api-version", newJString(apiVersion))
  add(path_574216, "subscriptionId", newJString(subscriptionId))
  add(query_574217, "$top", newJInt(Top))
  add(query_574217, "$skip", newJInt(Skip))
  add(path_574216, "serviceName", newJString(serviceName))
  add(query_574217, "$filter", newJString(Filter))
  result = call_574215.call(path_574216, query_574217, nil, nil, nil)

var reportsListByOperation* = Call_ReportsListByOperation_574204(
    name: "reportsListByOperation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byOperation",
    validator: validate_ReportsListByOperation_574205, base: "",
    url: url_ReportsListByOperation_574206, schemes: {Scheme.Https})
type
  Call_ReportsListByProduct_574218 = ref object of OpenApiRestCall_573659
proc url_ReportsListByProduct_574220(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsListByProduct_574219(path: JsonNode; query: JsonNode;
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
  var valid_574221 = path.getOrDefault("resourceGroupName")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "resourceGroupName", valid_574221
  var valid_574222 = path.getOrDefault("subscriptionId")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = nil)
  if valid_574222 != nil:
    section.add "subscriptionId", valid_574222
  var valid_574223 = path.getOrDefault("serviceName")
  valid_574223 = validateParameter(valid_574223, JString, required = true,
                                 default = nil)
  if valid_574223 != nil:
    section.add "serviceName", valid_574223
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
  var valid_574224 = query.getOrDefault("api-version")
  valid_574224 = validateParameter(valid_574224, JString, required = true,
                                 default = nil)
  if valid_574224 != nil:
    section.add "api-version", valid_574224
  var valid_574225 = query.getOrDefault("$top")
  valid_574225 = validateParameter(valid_574225, JInt, required = false, default = nil)
  if valid_574225 != nil:
    section.add "$top", valid_574225
  var valid_574226 = query.getOrDefault("$skip")
  valid_574226 = validateParameter(valid_574226, JInt, required = false, default = nil)
  if valid_574226 != nil:
    section.add "$skip", valid_574226
  var valid_574227 = query.getOrDefault("$filter")
  valid_574227 = validateParameter(valid_574227, JString, required = true,
                                 default = nil)
  if valid_574227 != nil:
    section.add "$filter", valid_574227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574228: Call_ReportsListByProduct_574218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by Product.
  ## 
  let valid = call_574228.validator(path, query, header, formData, body)
  let scheme = call_574228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574228.url(scheme.get, call_574228.host, call_574228.base,
                         call_574228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574228, url, valid)

proc call*(call_574229: Call_ReportsListByProduct_574218;
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
  var path_574230 = newJObject()
  var query_574231 = newJObject()
  add(path_574230, "resourceGroupName", newJString(resourceGroupName))
  add(query_574231, "api-version", newJString(apiVersion))
  add(path_574230, "subscriptionId", newJString(subscriptionId))
  add(query_574231, "$top", newJInt(Top))
  add(query_574231, "$skip", newJInt(Skip))
  add(path_574230, "serviceName", newJString(serviceName))
  add(query_574231, "$filter", newJString(Filter))
  result = call_574229.call(path_574230, query_574231, nil, nil, nil)

var reportsListByProduct* = Call_ReportsListByProduct_574218(
    name: "reportsListByProduct", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byProduct",
    validator: validate_ReportsListByProduct_574219, base: "",
    url: url_ReportsListByProduct_574220, schemes: {Scheme.Https})
type
  Call_ReportsListByRequest_574232 = ref object of OpenApiRestCall_573659
proc url_ReportsListByRequest_574234(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsListByRequest_574233(path: JsonNode; query: JsonNode;
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
  var valid_574235 = path.getOrDefault("resourceGroupName")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "resourceGroupName", valid_574235
  var valid_574236 = path.getOrDefault("subscriptionId")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "subscriptionId", valid_574236
  var valid_574237 = path.getOrDefault("serviceName")
  valid_574237 = validateParameter(valid_574237, JString, required = true,
                                 default = nil)
  if valid_574237 != nil:
    section.add "serviceName", valid_574237
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
  var valid_574238 = query.getOrDefault("api-version")
  valid_574238 = validateParameter(valid_574238, JString, required = true,
                                 default = nil)
  if valid_574238 != nil:
    section.add "api-version", valid_574238
  var valid_574239 = query.getOrDefault("$top")
  valid_574239 = validateParameter(valid_574239, JInt, required = false, default = nil)
  if valid_574239 != nil:
    section.add "$top", valid_574239
  var valid_574240 = query.getOrDefault("$skip")
  valid_574240 = validateParameter(valid_574240, JInt, required = false, default = nil)
  if valid_574240 != nil:
    section.add "$skip", valid_574240
  var valid_574241 = query.getOrDefault("$filter")
  valid_574241 = validateParameter(valid_574241, JString, required = true,
                                 default = nil)
  if valid_574241 != nil:
    section.add "$filter", valid_574241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574242: Call_ReportsListByRequest_574232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by Request.
  ## 
  let valid = call_574242.validator(path, query, header, formData, body)
  let scheme = call_574242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574242.url(scheme.get, call_574242.host, call_574242.base,
                         call_574242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574242, url, valid)

proc call*(call_574243: Call_ReportsListByRequest_574232;
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
  var path_574244 = newJObject()
  var query_574245 = newJObject()
  add(path_574244, "resourceGroupName", newJString(resourceGroupName))
  add(query_574245, "api-version", newJString(apiVersion))
  add(path_574244, "subscriptionId", newJString(subscriptionId))
  add(query_574245, "$top", newJInt(Top))
  add(query_574245, "$skip", newJInt(Skip))
  add(path_574244, "serviceName", newJString(serviceName))
  add(query_574245, "$filter", newJString(Filter))
  result = call_574243.call(path_574244, query_574245, nil, nil, nil)

var reportsListByRequest* = Call_ReportsListByRequest_574232(
    name: "reportsListByRequest", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byRequest",
    validator: validate_ReportsListByRequest_574233, base: "",
    url: url_ReportsListByRequest_574234, schemes: {Scheme.Https})
type
  Call_ReportsListBySubscription_574246 = ref object of OpenApiRestCall_573659
proc url_ReportsListBySubscription_574248(protocol: Scheme; host: string;
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

proc validate_ReportsListBySubscription_574247(path: JsonNode; query: JsonNode;
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
  var valid_574249 = path.getOrDefault("resourceGroupName")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = nil)
  if valid_574249 != nil:
    section.add "resourceGroupName", valid_574249
  var valid_574250 = path.getOrDefault("subscriptionId")
  valid_574250 = validateParameter(valid_574250, JString, required = true,
                                 default = nil)
  if valid_574250 != nil:
    section.add "subscriptionId", valid_574250
  var valid_574251 = path.getOrDefault("serviceName")
  valid_574251 = validateParameter(valid_574251, JString, required = true,
                                 default = nil)
  if valid_574251 != nil:
    section.add "serviceName", valid_574251
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
  var valid_574252 = query.getOrDefault("api-version")
  valid_574252 = validateParameter(valid_574252, JString, required = true,
                                 default = nil)
  if valid_574252 != nil:
    section.add "api-version", valid_574252
  var valid_574253 = query.getOrDefault("$top")
  valid_574253 = validateParameter(valid_574253, JInt, required = false, default = nil)
  if valid_574253 != nil:
    section.add "$top", valid_574253
  var valid_574254 = query.getOrDefault("$skip")
  valid_574254 = validateParameter(valid_574254, JInt, required = false, default = nil)
  if valid_574254 != nil:
    section.add "$skip", valid_574254
  var valid_574255 = query.getOrDefault("$filter")
  valid_574255 = validateParameter(valid_574255, JString, required = false,
                                 default = nil)
  if valid_574255 != nil:
    section.add "$filter", valid_574255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574256: Call_ReportsListBySubscription_574246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by subscription.
  ## 
  let valid = call_574256.validator(path, query, header, formData, body)
  let scheme = call_574256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574256.url(scheme.get, call_574256.host, call_574256.base,
                         call_574256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574256, url, valid)

proc call*(call_574257: Call_ReportsListBySubscription_574246;
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
  var path_574258 = newJObject()
  var query_574259 = newJObject()
  add(path_574258, "resourceGroupName", newJString(resourceGroupName))
  add(query_574259, "api-version", newJString(apiVersion))
  add(path_574258, "subscriptionId", newJString(subscriptionId))
  add(query_574259, "$top", newJInt(Top))
  add(query_574259, "$skip", newJInt(Skip))
  add(path_574258, "serviceName", newJString(serviceName))
  add(query_574259, "$filter", newJString(Filter))
  result = call_574257.call(path_574258, query_574259, nil, nil, nil)

var reportsListBySubscription* = Call_ReportsListBySubscription_574246(
    name: "reportsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/bySubscription",
    validator: validate_ReportsListBySubscription_574247, base: "",
    url: url_ReportsListBySubscription_574248, schemes: {Scheme.Https})
type
  Call_ReportsListByTime_574260 = ref object of OpenApiRestCall_573659
proc url_ReportsListByTime_574262(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsListByTime_574261(path: JsonNode; query: JsonNode;
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
  var valid_574263 = path.getOrDefault("resourceGroupName")
  valid_574263 = validateParameter(valid_574263, JString, required = true,
                                 default = nil)
  if valid_574263 != nil:
    section.add "resourceGroupName", valid_574263
  var valid_574264 = path.getOrDefault("subscriptionId")
  valid_574264 = validateParameter(valid_574264, JString, required = true,
                                 default = nil)
  if valid_574264 != nil:
    section.add "subscriptionId", valid_574264
  var valid_574265 = path.getOrDefault("serviceName")
  valid_574265 = validateParameter(valid_574265, JString, required = true,
                                 default = nil)
  if valid_574265 != nil:
    section.add "serviceName", valid_574265
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
  var valid_574266 = query.getOrDefault("api-version")
  valid_574266 = validateParameter(valid_574266, JString, required = true,
                                 default = nil)
  if valid_574266 != nil:
    section.add "api-version", valid_574266
  var valid_574267 = query.getOrDefault("$top")
  valid_574267 = validateParameter(valid_574267, JInt, required = false, default = nil)
  if valid_574267 != nil:
    section.add "$top", valid_574267
  var valid_574268 = query.getOrDefault("$skip")
  valid_574268 = validateParameter(valid_574268, JInt, required = false, default = nil)
  if valid_574268 != nil:
    section.add "$skip", valid_574268
  var valid_574269 = query.getOrDefault("interval")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "interval", valid_574269
  var valid_574270 = query.getOrDefault("$filter")
  valid_574270 = validateParameter(valid_574270, JString, required = false,
                                 default = nil)
  if valid_574270 != nil:
    section.add "$filter", valid_574270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574271: Call_ReportsListByTime_574260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by Time.
  ## 
  let valid = call_574271.validator(path, query, header, formData, body)
  let scheme = call_574271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574271.url(scheme.get, call_574271.host, call_574271.base,
                         call_574271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574271, url, valid)

proc call*(call_574272: Call_ReportsListByTime_574260; resourceGroupName: string;
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
  var path_574273 = newJObject()
  var query_574274 = newJObject()
  add(path_574273, "resourceGroupName", newJString(resourceGroupName))
  add(query_574274, "api-version", newJString(apiVersion))
  add(path_574273, "subscriptionId", newJString(subscriptionId))
  add(query_574274, "$top", newJInt(Top))
  add(query_574274, "$skip", newJInt(Skip))
  add(query_574274, "interval", newJString(interval))
  add(path_574273, "serviceName", newJString(serviceName))
  add(query_574274, "$filter", newJString(Filter))
  result = call_574272.call(path_574273, query_574274, nil, nil, nil)

var reportsListByTime* = Call_ReportsListByTime_574260(name: "reportsListByTime",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byTime",
    validator: validate_ReportsListByTime_574261, base: "",
    url: url_ReportsListByTime_574262, schemes: {Scheme.Https})
type
  Call_ReportsListByUser_574275 = ref object of OpenApiRestCall_573659
proc url_ReportsListByUser_574277(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsListByUser_574276(path: JsonNode; query: JsonNode;
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
  var valid_574278 = path.getOrDefault("resourceGroupName")
  valid_574278 = validateParameter(valid_574278, JString, required = true,
                                 default = nil)
  if valid_574278 != nil:
    section.add "resourceGroupName", valid_574278
  var valid_574279 = path.getOrDefault("subscriptionId")
  valid_574279 = validateParameter(valid_574279, JString, required = true,
                                 default = nil)
  if valid_574279 != nil:
    section.add "subscriptionId", valid_574279
  var valid_574280 = path.getOrDefault("serviceName")
  valid_574280 = validateParameter(valid_574280, JString, required = true,
                                 default = nil)
  if valid_574280 != nil:
    section.add "serviceName", valid_574280
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
  var valid_574281 = query.getOrDefault("api-version")
  valid_574281 = validateParameter(valid_574281, JString, required = true,
                                 default = nil)
  if valid_574281 != nil:
    section.add "api-version", valid_574281
  var valid_574282 = query.getOrDefault("$top")
  valid_574282 = validateParameter(valid_574282, JInt, required = false, default = nil)
  if valid_574282 != nil:
    section.add "$top", valid_574282
  var valid_574283 = query.getOrDefault("$skip")
  valid_574283 = validateParameter(valid_574283, JInt, required = false, default = nil)
  if valid_574283 != nil:
    section.add "$skip", valid_574283
  var valid_574284 = query.getOrDefault("$filter")
  valid_574284 = validateParameter(valid_574284, JString, required = true,
                                 default = nil)
  if valid_574284 != nil:
    section.add "$filter", valid_574284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574285: Call_ReportsListByUser_574275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records by User.
  ## 
  let valid = call_574285.validator(path, query, header, formData, body)
  let scheme = call_574285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574285.url(scheme.get, call_574285.host, call_574285.base,
                         call_574285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574285, url, valid)

proc call*(call_574286: Call_ReportsListByUser_574275; resourceGroupName: string;
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
  var path_574287 = newJObject()
  var query_574288 = newJObject()
  add(path_574287, "resourceGroupName", newJString(resourceGroupName))
  add(query_574288, "api-version", newJString(apiVersion))
  add(path_574287, "subscriptionId", newJString(subscriptionId))
  add(query_574288, "$top", newJInt(Top))
  add(query_574288, "$skip", newJInt(Skip))
  add(path_574287, "serviceName", newJString(serviceName))
  add(query_574288, "$filter", newJString(Filter))
  result = call_574286.call(path_574287, query_574288, nil, nil, nil)

var reportsListByUser* = Call_ReportsListByUser_574275(name: "reportsListByUser",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byUser",
    validator: validate_ReportsListByUser_574276, base: "",
    url: url_ReportsListByUser_574277, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
