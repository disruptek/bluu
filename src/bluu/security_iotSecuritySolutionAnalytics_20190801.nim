
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2019-08-01
## termsOfService: (not provided)
## license: (not provided)
## 
## API spec for Microsoft.Security (Azure Security Center) resource provider
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "security-iotSecuritySolutionAnalytics"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_IotSecuritySolutionAnalyticsList_573879 = ref object of OpenApiRestCall_573657
proc url_IotSecuritySolutionAnalyticsList_573881(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions/"),
               (kind: VariableSegment, value: "solutionName"),
               (kind: ConstantSegment, value: "/analyticsModels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotSecuritySolutionAnalyticsList_573880(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Use this method to get IoT security Analytics metrics in an array.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_574054 = path.getOrDefault("solutionName")
  valid_574054 = validateParameter(valid_574054, JString, required = true,
                                 default = nil)
  if valid_574054 != nil:
    section.add "solutionName", valid_574054
  var valid_574055 = path.getOrDefault("resourceGroupName")
  valid_574055 = validateParameter(valid_574055, JString, required = true,
                                 default = nil)
  if valid_574055 != nil:
    section.add "resourceGroupName", valid_574055
  var valid_574056 = path.getOrDefault("subscriptionId")
  valid_574056 = validateParameter(valid_574056, JString, required = true,
                                 default = nil)
  if valid_574056 != nil:
    section.add "subscriptionId", valid_574056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574057 = query.getOrDefault("api-version")
  valid_574057 = validateParameter(valid_574057, JString, required = true,
                                 default = nil)
  if valid_574057 != nil:
    section.add "api-version", valid_574057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574080: Call_IotSecuritySolutionAnalyticsList_573879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Use this method to get IoT security Analytics metrics in an array.
  ## 
  let valid = call_574080.validator(path, query, header, formData, body)
  let scheme = call_574080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574080.url(scheme.get, call_574080.host, call_574080.base,
                         call_574080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574080, url, valid)

proc call*(call_574151: Call_IotSecuritySolutionAnalyticsList_573879;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## iotSecuritySolutionAnalyticsList
  ## Use this method to get IoT security Analytics metrics in an array.
  ##   solutionName: string (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_574152 = newJObject()
  var query_574154 = newJObject()
  add(path_574152, "solutionName", newJString(solutionName))
  add(path_574152, "resourceGroupName", newJString(resourceGroupName))
  add(query_574154, "api-version", newJString(apiVersion))
  add(path_574152, "subscriptionId", newJString(subscriptionId))
  result = call_574151.call(path_574152, query_574154, nil, nil, nil)

var iotSecuritySolutionAnalyticsList* = Call_IotSecuritySolutionAnalyticsList_573879(
    name: "iotSecuritySolutionAnalyticsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels",
    validator: validate_IotSecuritySolutionAnalyticsList_573880, base: "",
    url: url_IotSecuritySolutionAnalyticsList_573881, schemes: {Scheme.Https})
type
  Call_IotSecuritySolutionAnalyticsGet_574193 = ref object of OpenApiRestCall_573657
proc url_IotSecuritySolutionAnalyticsGet_574195(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions/"),
               (kind: VariableSegment, value: "solutionName"),
               (kind: ConstantSegment, value: "/analyticsModels/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotSecuritySolutionAnalyticsGet_574194(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Use this method to get IoT Security Analytics metrics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_574196 = path.getOrDefault("solutionName")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "solutionName", valid_574196
  var valid_574197 = path.getOrDefault("resourceGroupName")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "resourceGroupName", valid_574197
  var valid_574198 = path.getOrDefault("subscriptionId")
  valid_574198 = validateParameter(valid_574198, JString, required = true,
                                 default = nil)
  if valid_574198 != nil:
    section.add "subscriptionId", valid_574198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574199 = query.getOrDefault("api-version")
  valid_574199 = validateParameter(valid_574199, JString, required = true,
                                 default = nil)
  if valid_574199 != nil:
    section.add "api-version", valid_574199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574200: Call_IotSecuritySolutionAnalyticsGet_574193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Use this method to get IoT Security Analytics metrics.
  ## 
  let valid = call_574200.validator(path, query, header, formData, body)
  let scheme = call_574200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574200.url(scheme.get, call_574200.host, call_574200.base,
                         call_574200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574200, url, valid)

proc call*(call_574201: Call_IotSecuritySolutionAnalyticsGet_574193;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## iotSecuritySolutionAnalyticsGet
  ## Use this method to get IoT Security Analytics metrics.
  ##   solutionName: string (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_574202 = newJObject()
  var query_574203 = newJObject()
  add(path_574202, "solutionName", newJString(solutionName))
  add(path_574202, "resourceGroupName", newJString(resourceGroupName))
  add(query_574203, "api-version", newJString(apiVersion))
  add(path_574202, "subscriptionId", newJString(subscriptionId))
  result = call_574201.call(path_574202, query_574203, nil, nil, nil)

var iotSecuritySolutionAnalyticsGet* = Call_IotSecuritySolutionAnalyticsGet_574193(
    name: "iotSecuritySolutionAnalyticsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels/default",
    validator: validate_IotSecuritySolutionAnalyticsGet_574194, base: "",
    url: url_IotSecuritySolutionAnalyticsGet_574195, schemes: {Scheme.Https})
type
  Call_IotSecuritySolutionsAnalyticsAggregatedAlertList_574204 = ref object of OpenApiRestCall_573657
proc url_IotSecuritySolutionsAnalyticsAggregatedAlertList_574206(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions/"),
               (kind: VariableSegment, value: "solutionName"), (
        kind: ConstantSegment, value: "/analyticsModels/default/aggregatedAlerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotSecuritySolutionsAnalyticsAggregatedAlertList_574205(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Use this method to get the aggregated alert list of yours IoT Security solution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_574208 = path.getOrDefault("solutionName")
  valid_574208 = validateParameter(valid_574208, JString, required = true,
                                 default = nil)
  if valid_574208 != nil:
    section.add "solutionName", valid_574208
  var valid_574209 = path.getOrDefault("resourceGroupName")
  valid_574209 = validateParameter(valid_574209, JString, required = true,
                                 default = nil)
  if valid_574209 != nil:
    section.add "resourceGroupName", valid_574209
  var valid_574210 = path.getOrDefault("subscriptionId")
  valid_574210 = validateParameter(valid_574210, JString, required = true,
                                 default = nil)
  if valid_574210 != nil:
    section.add "subscriptionId", valid_574210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $top: JInt
  ##       : Number of results to retrieve.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574211 = query.getOrDefault("api-version")
  valid_574211 = validateParameter(valid_574211, JString, required = true,
                                 default = nil)
  if valid_574211 != nil:
    section.add "api-version", valid_574211
  var valid_574212 = query.getOrDefault("$top")
  valid_574212 = validateParameter(valid_574212, JInt, required = false, default = nil)
  if valid_574212 != nil:
    section.add "$top", valid_574212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574213: Call_IotSecuritySolutionsAnalyticsAggregatedAlertList_574204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Use this method to get the aggregated alert list of yours IoT Security solution.
  ## 
  let valid = call_574213.validator(path, query, header, formData, body)
  let scheme = call_574213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574213.url(scheme.get, call_574213.host, call_574213.base,
                         call_574213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574213, url, valid)

proc call*(call_574214: Call_IotSecuritySolutionsAnalyticsAggregatedAlertList_574204;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## iotSecuritySolutionsAnalyticsAggregatedAlertList
  ## Use this method to get the aggregated alert list of yours IoT Security solution.
  ##   solutionName: string (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Top: int
  ##      : Number of results to retrieve.
  var path_574215 = newJObject()
  var query_574216 = newJObject()
  add(path_574215, "solutionName", newJString(solutionName))
  add(path_574215, "resourceGroupName", newJString(resourceGroupName))
  add(query_574216, "api-version", newJString(apiVersion))
  add(path_574215, "subscriptionId", newJString(subscriptionId))
  add(query_574216, "$top", newJInt(Top))
  result = call_574214.call(path_574215, query_574216, nil, nil, nil)

var iotSecuritySolutionsAnalyticsAggregatedAlertList* = Call_IotSecuritySolutionsAnalyticsAggregatedAlertList_574204(
    name: "iotSecuritySolutionsAnalyticsAggregatedAlertList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels/default/aggregatedAlerts",
    validator: validate_IotSecuritySolutionsAnalyticsAggregatedAlertList_574205,
    base: "", url: url_IotSecuritySolutionsAnalyticsAggregatedAlertList_574206,
    schemes: {Scheme.Https})
type
  Call_IotSecuritySolutionsAnalyticsAggregatedAlertGet_574217 = ref object of OpenApiRestCall_573657
proc url_IotSecuritySolutionsAnalyticsAggregatedAlertGet_574219(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  assert "aggregatedAlertName" in path,
        "`aggregatedAlertName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions/"),
               (kind: VariableSegment, value: "solutionName"), (
        kind: ConstantSegment, value: "/analyticsModels/default/aggregatedAlerts/"),
               (kind: VariableSegment, value: "aggregatedAlertName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotSecuritySolutionsAnalyticsAggregatedAlertGet_574218(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Use this method to get a single the aggregated alert of yours IoT Security solution. This aggregation is performed by alert name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   aggregatedAlertName: JString (required)
  ##                      : Identifier of the aggregated alert.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_574220 = path.getOrDefault("solutionName")
  valid_574220 = validateParameter(valid_574220, JString, required = true,
                                 default = nil)
  if valid_574220 != nil:
    section.add "solutionName", valid_574220
  var valid_574221 = path.getOrDefault("resourceGroupName")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "resourceGroupName", valid_574221
  var valid_574222 = path.getOrDefault("aggregatedAlertName")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = nil)
  if valid_574222 != nil:
    section.add "aggregatedAlertName", valid_574222
  var valid_574223 = path.getOrDefault("subscriptionId")
  valid_574223 = validateParameter(valid_574223, JString, required = true,
                                 default = nil)
  if valid_574223 != nil:
    section.add "subscriptionId", valid_574223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574224 = query.getOrDefault("api-version")
  valid_574224 = validateParameter(valid_574224, JString, required = true,
                                 default = nil)
  if valid_574224 != nil:
    section.add "api-version", valid_574224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574225: Call_IotSecuritySolutionsAnalyticsAggregatedAlertGet_574217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Use this method to get a single the aggregated alert of yours IoT Security solution. This aggregation is performed by alert name.
  ## 
  let valid = call_574225.validator(path, query, header, formData, body)
  let scheme = call_574225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574225.url(scheme.get, call_574225.host, call_574225.base,
                         call_574225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574225, url, valid)

proc call*(call_574226: Call_IotSecuritySolutionsAnalyticsAggregatedAlertGet_574217;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          aggregatedAlertName: string; subscriptionId: string): Recallable =
  ## iotSecuritySolutionsAnalyticsAggregatedAlertGet
  ## Use this method to get a single the aggregated alert of yours IoT Security solution. This aggregation is performed by alert name.
  ##   solutionName: string (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   aggregatedAlertName: string (required)
  ##                      : Identifier of the aggregated alert.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_574227 = newJObject()
  var query_574228 = newJObject()
  add(path_574227, "solutionName", newJString(solutionName))
  add(path_574227, "resourceGroupName", newJString(resourceGroupName))
  add(query_574228, "api-version", newJString(apiVersion))
  add(path_574227, "aggregatedAlertName", newJString(aggregatedAlertName))
  add(path_574227, "subscriptionId", newJString(subscriptionId))
  result = call_574226.call(path_574227, query_574228, nil, nil, nil)

var iotSecuritySolutionsAnalyticsAggregatedAlertGet* = Call_IotSecuritySolutionsAnalyticsAggregatedAlertGet_574217(
    name: "iotSecuritySolutionsAnalyticsAggregatedAlertGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels/default/aggregatedAlerts/{aggregatedAlertName}",
    validator: validate_IotSecuritySolutionsAnalyticsAggregatedAlertGet_574218,
    base: "", url: url_IotSecuritySolutionsAnalyticsAggregatedAlertGet_574219,
    schemes: {Scheme.Https})
type
  Call_IotSecuritySolutionsAnalyticsAggregatedAlertDismiss_574229 = ref object of OpenApiRestCall_573657
proc url_IotSecuritySolutionsAnalyticsAggregatedAlertDismiss_574231(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  assert "aggregatedAlertName" in path,
        "`aggregatedAlertName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions/"),
               (kind: VariableSegment, value: "solutionName"), (
        kind: ConstantSegment, value: "/analyticsModels/default/aggregatedAlerts/"),
               (kind: VariableSegment, value: "aggregatedAlertName"),
               (kind: ConstantSegment, value: "/dismiss")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotSecuritySolutionsAnalyticsAggregatedAlertDismiss_574230(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Use this method to dismiss an aggregated IoT Security Solution Alert.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   aggregatedAlertName: JString (required)
  ##                      : Identifier of the aggregated alert.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_574232 = path.getOrDefault("solutionName")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "solutionName", valid_574232
  var valid_574233 = path.getOrDefault("resourceGroupName")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = nil)
  if valid_574233 != nil:
    section.add "resourceGroupName", valid_574233
  var valid_574234 = path.getOrDefault("aggregatedAlertName")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "aggregatedAlertName", valid_574234
  var valid_574235 = path.getOrDefault("subscriptionId")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "subscriptionId", valid_574235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574236 = query.getOrDefault("api-version")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "api-version", valid_574236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574237: Call_IotSecuritySolutionsAnalyticsAggregatedAlertDismiss_574229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Use this method to dismiss an aggregated IoT Security Solution Alert.
  ## 
  let valid = call_574237.validator(path, query, header, formData, body)
  let scheme = call_574237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574237.url(scheme.get, call_574237.host, call_574237.base,
                         call_574237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574237, url, valid)

proc call*(call_574238: Call_IotSecuritySolutionsAnalyticsAggregatedAlertDismiss_574229;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          aggregatedAlertName: string; subscriptionId: string): Recallable =
  ## iotSecuritySolutionsAnalyticsAggregatedAlertDismiss
  ## Use this method to dismiss an aggregated IoT Security Solution Alert.
  ##   solutionName: string (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   aggregatedAlertName: string (required)
  ##                      : Identifier of the aggregated alert.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_574239 = newJObject()
  var query_574240 = newJObject()
  add(path_574239, "solutionName", newJString(solutionName))
  add(path_574239, "resourceGroupName", newJString(resourceGroupName))
  add(query_574240, "api-version", newJString(apiVersion))
  add(path_574239, "aggregatedAlertName", newJString(aggregatedAlertName))
  add(path_574239, "subscriptionId", newJString(subscriptionId))
  result = call_574238.call(path_574239, query_574240, nil, nil, nil)

var iotSecuritySolutionsAnalyticsAggregatedAlertDismiss* = Call_IotSecuritySolutionsAnalyticsAggregatedAlertDismiss_574229(
    name: "iotSecuritySolutionsAnalyticsAggregatedAlertDismiss",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels/default/aggregatedAlerts/{aggregatedAlertName}/dismiss",
    validator: validate_IotSecuritySolutionsAnalyticsAggregatedAlertDismiss_574230,
    base: "", url: url_IotSecuritySolutionsAnalyticsAggregatedAlertDismiss_574231,
    schemes: {Scheme.Https})
type
  Call_IotSecuritySolutionsAnalyticsRecommendationList_574241 = ref object of OpenApiRestCall_573657
proc url_IotSecuritySolutionsAnalyticsRecommendationList_574243(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions/"),
               (kind: VariableSegment, value: "solutionName"), (
        kind: ConstantSegment,
        value: "/analyticsModels/default/aggregatedRecommendations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotSecuritySolutionsAnalyticsRecommendationList_574242(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Use this method to get the list of aggregated security analytics recommendations of yours IoT Security solution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_574244 = path.getOrDefault("solutionName")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = nil)
  if valid_574244 != nil:
    section.add "solutionName", valid_574244
  var valid_574245 = path.getOrDefault("resourceGroupName")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "resourceGroupName", valid_574245
  var valid_574246 = path.getOrDefault("subscriptionId")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "subscriptionId", valid_574246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $top: JInt
  ##       : Number of results to retrieve.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574247 = query.getOrDefault("api-version")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "api-version", valid_574247
  var valid_574248 = query.getOrDefault("$top")
  valid_574248 = validateParameter(valid_574248, JInt, required = false, default = nil)
  if valid_574248 != nil:
    section.add "$top", valid_574248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574249: Call_IotSecuritySolutionsAnalyticsRecommendationList_574241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Use this method to get the list of aggregated security analytics recommendations of yours IoT Security solution.
  ## 
  let valid = call_574249.validator(path, query, header, formData, body)
  let scheme = call_574249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574249.url(scheme.get, call_574249.host, call_574249.base,
                         call_574249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574249, url, valid)

proc call*(call_574250: Call_IotSecuritySolutionsAnalyticsRecommendationList_574241;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## iotSecuritySolutionsAnalyticsRecommendationList
  ## Use this method to get the list of aggregated security analytics recommendations of yours IoT Security solution.
  ##   solutionName: string (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Top: int
  ##      : Number of results to retrieve.
  var path_574251 = newJObject()
  var query_574252 = newJObject()
  add(path_574251, "solutionName", newJString(solutionName))
  add(path_574251, "resourceGroupName", newJString(resourceGroupName))
  add(query_574252, "api-version", newJString(apiVersion))
  add(path_574251, "subscriptionId", newJString(subscriptionId))
  add(query_574252, "$top", newJInt(Top))
  result = call_574250.call(path_574251, query_574252, nil, nil, nil)

var iotSecuritySolutionsAnalyticsRecommendationList* = Call_IotSecuritySolutionsAnalyticsRecommendationList_574241(
    name: "iotSecuritySolutionsAnalyticsRecommendationList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels/default/aggregatedRecommendations",
    validator: validate_IotSecuritySolutionsAnalyticsRecommendationList_574242,
    base: "", url: url_IotSecuritySolutionsAnalyticsRecommendationList_574243,
    schemes: {Scheme.Https})
type
  Call_IotSecuritySolutionsAnalyticsRecommendationGet_574253 = ref object of OpenApiRestCall_573657
proc url_IotSecuritySolutionsAnalyticsRecommendationGet_574255(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  assert "aggregatedRecommendationName" in path,
        "`aggregatedRecommendationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/iotSecuritySolutions/"),
               (kind: VariableSegment, value: "solutionName"), (
        kind: ConstantSegment,
        value: "/analyticsModels/default/aggregatedRecommendations/"),
               (kind: VariableSegment, value: "aggregatedRecommendationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IotSecuritySolutionsAnalyticsRecommendationGet_574254(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Use this method to get the aggregated security analytics recommendation of yours IoT Security solution. This aggregation is performed by recommendation name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   aggregatedRecommendationName: JString (required)
  ##                               : Name of the recommendation aggregated for this query.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_574256 = path.getOrDefault("solutionName")
  valid_574256 = validateParameter(valid_574256, JString, required = true,
                                 default = nil)
  if valid_574256 != nil:
    section.add "solutionName", valid_574256
  var valid_574257 = path.getOrDefault("resourceGroupName")
  valid_574257 = validateParameter(valid_574257, JString, required = true,
                                 default = nil)
  if valid_574257 != nil:
    section.add "resourceGroupName", valid_574257
  var valid_574258 = path.getOrDefault("subscriptionId")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "subscriptionId", valid_574258
  var valid_574259 = path.getOrDefault("aggregatedRecommendationName")
  valid_574259 = validateParameter(valid_574259, JString, required = true,
                                 default = nil)
  if valid_574259 != nil:
    section.add "aggregatedRecommendationName", valid_574259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574260 = query.getOrDefault("api-version")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "api-version", valid_574260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574261: Call_IotSecuritySolutionsAnalyticsRecommendationGet_574253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Use this method to get the aggregated security analytics recommendation of yours IoT Security solution. This aggregation is performed by recommendation name.
  ## 
  let valid = call_574261.validator(path, query, header, formData, body)
  let scheme = call_574261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574261.url(scheme.get, call_574261.host, call_574261.base,
                         call_574261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574261, url, valid)

proc call*(call_574262: Call_IotSecuritySolutionsAnalyticsRecommendationGet_574253;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; aggregatedRecommendationName: string): Recallable =
  ## iotSecuritySolutionsAnalyticsRecommendationGet
  ## Use this method to get the aggregated security analytics recommendation of yours IoT Security solution. This aggregation is performed by recommendation name.
  ##   solutionName: string (required)
  ##               : The name of the IoT Security solution.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   aggregatedRecommendationName: string (required)
  ##                               : Name of the recommendation aggregated for this query.
  var path_574263 = newJObject()
  var query_574264 = newJObject()
  add(path_574263, "solutionName", newJString(solutionName))
  add(path_574263, "resourceGroupName", newJString(resourceGroupName))
  add(query_574264, "api-version", newJString(apiVersion))
  add(path_574263, "subscriptionId", newJString(subscriptionId))
  add(path_574263, "aggregatedRecommendationName",
      newJString(aggregatedRecommendationName))
  result = call_574262.call(path_574263, query_574264, nil, nil, nil)

var iotSecuritySolutionsAnalyticsRecommendationGet* = Call_IotSecuritySolutionsAnalyticsRecommendationGet_574253(
    name: "iotSecuritySolutionsAnalyticsRecommendationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels/default/aggregatedRecommendations/{aggregatedRecommendationName}",
    validator: validate_IotSecuritySolutionsAnalyticsRecommendationGet_574254,
    base: "", url: url_IotSecuritySolutionsAnalyticsRecommendationGet_574255,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
