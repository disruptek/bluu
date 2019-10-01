
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2017-08-01-preview
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  Call_IoTSecuritySolutionsAnalyticsGetAll_567879 = ref object of OpenApiRestCall_567657
proc url_IoTSecuritySolutionsAnalyticsGetAll_567881(protocol: Scheme; host: string;
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

proc validate_IoTSecuritySolutionsAnalyticsGetAll_567880(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Security Analytics of a security solution
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The solution manager name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568054 = path.getOrDefault("solutionName")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = nil)
  if valid_568054 != nil:
    section.add "solutionName", valid_568054
  var valid_568055 = path.getOrDefault("resourceGroupName")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "resourceGroupName", valid_568055
  var valid_568056 = path.getOrDefault("subscriptionId")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "subscriptionId", valid_568056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568057 = query.getOrDefault("api-version")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "api-version", valid_568057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568080: Call_IoTSecuritySolutionsAnalyticsGetAll_567879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security Analytics of a security solution
  ## 
  let valid = call_568080.validator(path, query, header, formData, body)
  let scheme = call_568080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568080.url(scheme.get, call_568080.host, call_568080.base,
                         call_568080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568080, url, valid)

proc call*(call_568151: Call_IoTSecuritySolutionsAnalyticsGetAll_567879;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## ioTSecuritySolutionsAnalyticsGetAll
  ## Security Analytics of a security solution
  ##   solutionName: string (required)
  ##               : The solution manager name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568152 = newJObject()
  var query_568154 = newJObject()
  add(path_568152, "solutionName", newJString(solutionName))
  add(path_568152, "resourceGroupName", newJString(resourceGroupName))
  add(query_568154, "api-version", newJString(apiVersion))
  add(path_568152, "subscriptionId", newJString(subscriptionId))
  result = call_568151.call(path_568152, query_568154, nil, nil, nil)

var ioTSecuritySolutionsAnalyticsGetAll* = Call_IoTSecuritySolutionsAnalyticsGetAll_567879(
    name: "ioTSecuritySolutionsAnalyticsGetAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels",
    validator: validate_IoTSecuritySolutionsAnalyticsGetAll_567880, base: "",
    url: url_IoTSecuritySolutionsAnalyticsGetAll_567881, schemes: {Scheme.Https})
type
  Call_IoTSecuritySolutionsAnalyticsGetDefault_568193 = ref object of OpenApiRestCall_567657
proc url_IoTSecuritySolutionsAnalyticsGetDefault_568195(protocol: Scheme;
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
               (kind: VariableSegment, value: "solutionName"),
               (kind: ConstantSegment, value: "/analyticsModels/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IoTSecuritySolutionsAnalyticsGetDefault_568194(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Security Analytics of a security solution
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The solution manager name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568196 = path.getOrDefault("solutionName")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "solutionName", valid_568196
  var valid_568197 = path.getOrDefault("resourceGroupName")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "resourceGroupName", valid_568197
  var valid_568198 = path.getOrDefault("subscriptionId")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "subscriptionId", valid_568198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568199 = query.getOrDefault("api-version")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "api-version", valid_568199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568200: Call_IoTSecuritySolutionsAnalyticsGetDefault_568193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security Analytics of a security solution
  ## 
  let valid = call_568200.validator(path, query, header, formData, body)
  let scheme = call_568200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568200.url(scheme.get, call_568200.host, call_568200.base,
                         call_568200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568200, url, valid)

proc call*(call_568201: Call_IoTSecuritySolutionsAnalyticsGetDefault_568193;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## ioTSecuritySolutionsAnalyticsGetDefault
  ## Security Analytics of a security solution
  ##   solutionName: string (required)
  ##               : The solution manager name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568202 = newJObject()
  var query_568203 = newJObject()
  add(path_568202, "solutionName", newJString(solutionName))
  add(path_568202, "resourceGroupName", newJString(resourceGroupName))
  add(query_568203, "api-version", newJString(apiVersion))
  add(path_568202, "subscriptionId", newJString(subscriptionId))
  result = call_568201.call(path_568202, query_568203, nil, nil, nil)

var ioTSecuritySolutionsAnalyticsGetDefault* = Call_IoTSecuritySolutionsAnalyticsGetDefault_568193(
    name: "ioTSecuritySolutionsAnalyticsGetDefault", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels/default",
    validator: validate_IoTSecuritySolutionsAnalyticsGetDefault_568194, base: "",
    url: url_IoTSecuritySolutionsAnalyticsGetDefault_568195,
    schemes: {Scheme.Https})
type
  Call_IoTSecuritySolutionsAnalyticsAggregatedAlertsList_568204 = ref object of OpenApiRestCall_567657
proc url_IoTSecuritySolutionsAnalyticsAggregatedAlertsList_568206(
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

proc validate_IoTSecuritySolutionsAnalyticsAggregatedAlertsList_568205(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Security Analytics of a security solution
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The solution manager name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568208 = path.getOrDefault("solutionName")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "solutionName", valid_568208
  var valid_568209 = path.getOrDefault("resourceGroupName")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "resourceGroupName", valid_568209
  var valid_568210 = path.getOrDefault("subscriptionId")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "subscriptionId", valid_568210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $top: JInt
  ##       : The number of results to retrieve.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568211 = query.getOrDefault("api-version")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "api-version", valid_568211
  var valid_568212 = query.getOrDefault("$top")
  valid_568212 = validateParameter(valid_568212, JInt, required = false, default = nil)
  if valid_568212 != nil:
    section.add "$top", valid_568212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568213: Call_IoTSecuritySolutionsAnalyticsAggregatedAlertsList_568204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security Analytics of a security solution
  ## 
  let valid = call_568213.validator(path, query, header, formData, body)
  let scheme = call_568213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568213.url(scheme.get, call_568213.host, call_568213.base,
                         call_568213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568213, url, valid)

proc call*(call_568214: Call_IoTSecuritySolutionsAnalyticsAggregatedAlertsList_568204;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## ioTSecuritySolutionsAnalyticsAggregatedAlertsList
  ## Security Analytics of a security solution
  ##   solutionName: string (required)
  ##               : The solution manager name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Top: int
  ##      : The number of results to retrieve.
  var path_568215 = newJObject()
  var query_568216 = newJObject()
  add(path_568215, "solutionName", newJString(solutionName))
  add(path_568215, "resourceGroupName", newJString(resourceGroupName))
  add(query_568216, "api-version", newJString(apiVersion))
  add(path_568215, "subscriptionId", newJString(subscriptionId))
  add(query_568216, "$top", newJInt(Top))
  result = call_568214.call(path_568215, query_568216, nil, nil, nil)

var ioTSecuritySolutionsAnalyticsAggregatedAlertsList* = Call_IoTSecuritySolutionsAnalyticsAggregatedAlertsList_568204(
    name: "ioTSecuritySolutionsAnalyticsAggregatedAlertsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels/default/aggregatedAlerts",
    validator: validate_IoTSecuritySolutionsAnalyticsAggregatedAlertsList_568205,
    base: "", url: url_IoTSecuritySolutionsAnalyticsAggregatedAlertsList_568206,
    schemes: {Scheme.Https})
type
  Call_IoTSecuritySolutionsAnalyticsAggregatedAlertGet_568217 = ref object of OpenApiRestCall_567657
proc url_IoTSecuritySolutionsAnalyticsAggregatedAlertGet_568219(protocol: Scheme;
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

proc validate_IoTSecuritySolutionsAnalyticsAggregatedAlertGet_568218(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Security Analytics of a security solution
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The solution manager name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   aggregatedAlertName: JString (required)
  ##                      : Identifier of the aggregated alert
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568220 = path.getOrDefault("solutionName")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "solutionName", valid_568220
  var valid_568221 = path.getOrDefault("resourceGroupName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "resourceGroupName", valid_568221
  var valid_568222 = path.getOrDefault("aggregatedAlertName")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "aggregatedAlertName", valid_568222
  var valid_568223 = path.getOrDefault("subscriptionId")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "subscriptionId", valid_568223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568224 = query.getOrDefault("api-version")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "api-version", valid_568224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568225: Call_IoTSecuritySolutionsAnalyticsAggregatedAlertGet_568217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security Analytics of a security solution
  ## 
  let valid = call_568225.validator(path, query, header, formData, body)
  let scheme = call_568225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568225.url(scheme.get, call_568225.host, call_568225.base,
                         call_568225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568225, url, valid)

proc call*(call_568226: Call_IoTSecuritySolutionsAnalyticsAggregatedAlertGet_568217;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          aggregatedAlertName: string; subscriptionId: string): Recallable =
  ## ioTSecuritySolutionsAnalyticsAggregatedAlertGet
  ## Security Analytics of a security solution
  ##   solutionName: string (required)
  ##               : The solution manager name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   aggregatedAlertName: string (required)
  ##                      : Identifier of the aggregated alert
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568227 = newJObject()
  var query_568228 = newJObject()
  add(path_568227, "solutionName", newJString(solutionName))
  add(path_568227, "resourceGroupName", newJString(resourceGroupName))
  add(query_568228, "api-version", newJString(apiVersion))
  add(path_568227, "aggregatedAlertName", newJString(aggregatedAlertName))
  add(path_568227, "subscriptionId", newJString(subscriptionId))
  result = call_568226.call(path_568227, query_568228, nil, nil, nil)

var ioTSecuritySolutionsAnalyticsAggregatedAlertGet* = Call_IoTSecuritySolutionsAnalyticsAggregatedAlertGet_568217(
    name: "ioTSecuritySolutionsAnalyticsAggregatedAlertGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels/default/aggregatedAlerts/{aggregatedAlertName}",
    validator: validate_IoTSecuritySolutionsAnalyticsAggregatedAlertGet_568218,
    base: "", url: url_IoTSecuritySolutionsAnalyticsAggregatedAlertGet_568219,
    schemes: {Scheme.Https})
type
  Call_IoTSecuritySolutionsAnalyticsAggregatedAlertDismiss_568229 = ref object of OpenApiRestCall_567657
proc url_IoTSecuritySolutionsAnalyticsAggregatedAlertDismiss_568231(
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

proc validate_IoTSecuritySolutionsAnalyticsAggregatedAlertDismiss_568230(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Security Analytics of a security solution
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The solution manager name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   aggregatedAlertName: JString (required)
  ##                      : Identifier of the aggregated alert
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568232 = path.getOrDefault("solutionName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "solutionName", valid_568232
  var valid_568233 = path.getOrDefault("resourceGroupName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "resourceGroupName", valid_568233
  var valid_568234 = path.getOrDefault("aggregatedAlertName")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "aggregatedAlertName", valid_568234
  var valid_568235 = path.getOrDefault("subscriptionId")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "subscriptionId", valid_568235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568236 = query.getOrDefault("api-version")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "api-version", valid_568236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568237: Call_IoTSecuritySolutionsAnalyticsAggregatedAlertDismiss_568229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security Analytics of a security solution
  ## 
  let valid = call_568237.validator(path, query, header, formData, body)
  let scheme = call_568237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568237.url(scheme.get, call_568237.host, call_568237.base,
                         call_568237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568237, url, valid)

proc call*(call_568238: Call_IoTSecuritySolutionsAnalyticsAggregatedAlertDismiss_568229;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          aggregatedAlertName: string; subscriptionId: string): Recallable =
  ## ioTSecuritySolutionsAnalyticsAggregatedAlertDismiss
  ## Security Analytics of a security solution
  ##   solutionName: string (required)
  ##               : The solution manager name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   aggregatedAlertName: string (required)
  ##                      : Identifier of the aggregated alert
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568239 = newJObject()
  var query_568240 = newJObject()
  add(path_568239, "solutionName", newJString(solutionName))
  add(path_568239, "resourceGroupName", newJString(resourceGroupName))
  add(query_568240, "api-version", newJString(apiVersion))
  add(path_568239, "aggregatedAlertName", newJString(aggregatedAlertName))
  add(path_568239, "subscriptionId", newJString(subscriptionId))
  result = call_568238.call(path_568239, query_568240, nil, nil, nil)

var ioTSecuritySolutionsAnalyticsAggregatedAlertDismiss* = Call_IoTSecuritySolutionsAnalyticsAggregatedAlertDismiss_568229(
    name: "ioTSecuritySolutionsAnalyticsAggregatedAlertDismiss",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels/default/aggregatedAlerts/{aggregatedAlertName}/dismiss",
    validator: validate_IoTSecuritySolutionsAnalyticsAggregatedAlertDismiss_568230,
    base: "", url: url_IoTSecuritySolutionsAnalyticsAggregatedAlertDismiss_568231,
    schemes: {Scheme.Https})
type
  Call_IoTSecuritySolutionsAnalyticsRecommendationsList_568241 = ref object of OpenApiRestCall_567657
proc url_IoTSecuritySolutionsAnalyticsRecommendationsList_568243(
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
        kind: ConstantSegment,
        value: "/analyticsModels/default/aggregatedRecommendations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IoTSecuritySolutionsAnalyticsRecommendationsList_568242(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Security Analytics of a security solution
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The solution manager name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568244 = path.getOrDefault("solutionName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "solutionName", valid_568244
  var valid_568245 = path.getOrDefault("resourceGroupName")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "resourceGroupName", valid_568245
  var valid_568246 = path.getOrDefault("subscriptionId")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "subscriptionId", valid_568246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $top: JInt
  ##       : The number of results to retrieve.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568247 = query.getOrDefault("api-version")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "api-version", valid_568247
  var valid_568248 = query.getOrDefault("$top")
  valid_568248 = validateParameter(valid_568248, JInt, required = false, default = nil)
  if valid_568248 != nil:
    section.add "$top", valid_568248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568249: Call_IoTSecuritySolutionsAnalyticsRecommendationsList_568241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security Analytics of a security solution
  ## 
  let valid = call_568249.validator(path, query, header, formData, body)
  let scheme = call_568249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568249.url(scheme.get, call_568249.host, call_568249.base,
                         call_568249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568249, url, valid)

proc call*(call_568250: Call_IoTSecuritySolutionsAnalyticsRecommendationsList_568241;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## ioTSecuritySolutionsAnalyticsRecommendationsList
  ## Security Analytics of a security solution
  ##   solutionName: string (required)
  ##               : The solution manager name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Top: int
  ##      : The number of results to retrieve.
  var path_568251 = newJObject()
  var query_568252 = newJObject()
  add(path_568251, "solutionName", newJString(solutionName))
  add(path_568251, "resourceGroupName", newJString(resourceGroupName))
  add(query_568252, "api-version", newJString(apiVersion))
  add(path_568251, "subscriptionId", newJString(subscriptionId))
  add(query_568252, "$top", newJInt(Top))
  result = call_568250.call(path_568251, query_568252, nil, nil, nil)

var ioTSecuritySolutionsAnalyticsRecommendationsList* = Call_IoTSecuritySolutionsAnalyticsRecommendationsList_568241(
    name: "ioTSecuritySolutionsAnalyticsRecommendationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels/default/aggregatedRecommendations",
    validator: validate_IoTSecuritySolutionsAnalyticsRecommendationsList_568242,
    base: "", url: url_IoTSecuritySolutionsAnalyticsRecommendationsList_568243,
    schemes: {Scheme.Https})
type
  Call_IoTSecuritySolutionsAnalyticsRecommendationGet_568253 = ref object of OpenApiRestCall_567657
proc url_IoTSecuritySolutionsAnalyticsRecommendationGet_568255(protocol: Scheme;
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

proc validate_IoTSecuritySolutionsAnalyticsRecommendationGet_568254(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Security Analytics of a security solution
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : The solution manager name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   aggregatedRecommendationName: JString (required)
  ##                               : Identifier of the aggregated recommendation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_568256 = path.getOrDefault("solutionName")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "solutionName", valid_568256
  var valid_568257 = path.getOrDefault("resourceGroupName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "resourceGroupName", valid_568257
  var valid_568258 = path.getOrDefault("subscriptionId")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "subscriptionId", valid_568258
  var valid_568259 = path.getOrDefault("aggregatedRecommendationName")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "aggregatedRecommendationName", valid_568259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568260 = query.getOrDefault("api-version")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "api-version", valid_568260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568261: Call_IoTSecuritySolutionsAnalyticsRecommendationGet_568253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security Analytics of a security solution
  ## 
  let valid = call_568261.validator(path, query, header, formData, body)
  let scheme = call_568261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568261.url(scheme.get, call_568261.host, call_568261.base,
                         call_568261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568261, url, valid)

proc call*(call_568262: Call_IoTSecuritySolutionsAnalyticsRecommendationGet_568253;
          solutionName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; aggregatedRecommendationName: string): Recallable =
  ## ioTSecuritySolutionsAnalyticsRecommendationGet
  ## Security Analytics of a security solution
  ##   solutionName: string (required)
  ##               : The solution manager name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   aggregatedRecommendationName: string (required)
  ##                               : Identifier of the aggregated recommendation
  var path_568263 = newJObject()
  var query_568264 = newJObject()
  add(path_568263, "solutionName", newJString(solutionName))
  add(path_568263, "resourceGroupName", newJString(resourceGroupName))
  add(query_568264, "api-version", newJString(apiVersion))
  add(path_568263, "subscriptionId", newJString(subscriptionId))
  add(path_568263, "aggregatedRecommendationName",
      newJString(aggregatedRecommendationName))
  result = call_568262.call(path_568263, query_568264, nil, nil, nil)

var ioTSecuritySolutionsAnalyticsRecommendationGet* = Call_IoTSecuritySolutionsAnalyticsRecommendationGet_568253(
    name: "ioTSecuritySolutionsAnalyticsRecommendationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/iotSecuritySolutions/{solutionName}/analyticsModels/default/aggregatedRecommendations/{aggregatedRecommendationName}",
    validator: validate_IoTSecuritySolutionsAnalyticsRecommendationGet_568254,
    base: "", url: url_IoTSecuritySolutionsAnalyticsRecommendationGet_568255,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
