
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: TimeSeriesInsightsClient
## version: 2017-02-28-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Time Series Insights client
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

  OpenApiRestCall_563564 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563564](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563564): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "timeseriesinsights"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563786 = ref object of OpenApiRestCall_563564
proc url_OperationsList_563788(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563787(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Time Series Insights related operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563949 = query.getOrDefault("api-version")
  valid_563949 = validateParameter(valid_563949, JString, required = true,
                                 default = nil)
  if valid_563949 != nil:
    section.add "api-version", valid_563949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563972: Call_OperationsList_563786; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Time Series Insights related operations.
  ## 
  let valid = call_563972.validator(path, query, header, formData, body)
  let scheme = call_563972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563972.url(scheme.get, call_563972.host, call_563972.base,
                         call_563972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563972, url, valid)

proc call*(call_564043: Call_OperationsList_563786; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Time Series Insights related operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  var query_564044 = newJObject()
  add(query_564044, "api-version", newJString(apiVersion))
  result = call_564043.call(nil, query_564044, nil, nil, nil)

var operationsList* = Call_OperationsList_563786(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.TimeSeriesInsights/operations",
    validator: validate_OperationsList_563787, base: "", url: url_OperationsList_563788,
    schemes: {Scheme.Https})
type
  Call_EnvironmentsListBySubscription_564084 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsListBySubscription_564086(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsListBySubscription_564085(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available environments within a subscription, irrespective of the resource groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564101 = path.getOrDefault("subscriptionId")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "subscriptionId", valid_564101
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564102 = query.getOrDefault("api-version")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "api-version", valid_564102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564103: Call_EnvironmentsListBySubscription_564084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available environments within a subscription, irrespective of the resource groups.
  ## 
  let valid = call_564103.validator(path, query, header, formData, body)
  let scheme = call_564103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564103.url(scheme.get, call_564103.host, call_564103.base,
                         call_564103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564103, url, valid)

proc call*(call_564104: Call_EnvironmentsListBySubscription_564084;
          apiVersion: string; subscriptionId: string): Recallable =
  ## environmentsListBySubscription
  ## Lists all the available environments within a subscription, irrespective of the resource groups.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_564105 = newJObject()
  var query_564106 = newJObject()
  add(query_564106, "api-version", newJString(apiVersion))
  add(path_564105, "subscriptionId", newJString(subscriptionId))
  result = call_564104.call(path_564105, query_564106, nil, nil, nil)

var environmentsListBySubscription* = Call_EnvironmentsListBySubscription_564084(
    name: "environmentsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.TimeSeriesInsights/environments",
    validator: validate_EnvironmentsListBySubscription_564085, base: "",
    url: url_EnvironmentsListBySubscription_564086, schemes: {Scheme.Https})
type
  Call_EnvironmentsListByResourceGroup_564107 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsListByResourceGroup_564109(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsListByResourceGroup_564108(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available environments associated with the subscription and within the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564110 = path.getOrDefault("subscriptionId")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "subscriptionId", valid_564110
  var valid_564111 = path.getOrDefault("resourceGroupName")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "resourceGroupName", valid_564111
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564112 = query.getOrDefault("api-version")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "api-version", valid_564112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564113: Call_EnvironmentsListByResourceGroup_564107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the available environments associated with the subscription and within the specified resource group.
  ## 
  let valid = call_564113.validator(path, query, header, formData, body)
  let scheme = call_564113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564113.url(scheme.get, call_564113.host, call_564113.base,
                         call_564113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564113, url, valid)

proc call*(call_564114: Call_EnvironmentsListByResourceGroup_564107;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## environmentsListByResourceGroup
  ## Lists all the available environments associated with the subscription and within the specified resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564115 = newJObject()
  var query_564116 = newJObject()
  add(query_564116, "api-version", newJString(apiVersion))
  add(path_564115, "subscriptionId", newJString(subscriptionId))
  add(path_564115, "resourceGroupName", newJString(resourceGroupName))
  result = call_564114.call(path_564115, query_564116, nil, nil, nil)

var environmentsListByResourceGroup* = Call_EnvironmentsListByResourceGroup_564107(
    name: "environmentsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments",
    validator: validate_EnvironmentsListByResourceGroup_564108, base: "",
    url: url_EnvironmentsListByResourceGroup_564109, schemes: {Scheme.Https})
type
  Call_EnvironmentsCreateOrUpdate_564128 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsCreateOrUpdate_564130(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsCreateOrUpdate_564129(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an environment in the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : Name of the environment
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564148 = path.getOrDefault("environmentName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "environmentName", valid_564148
  var valid_564149 = path.getOrDefault("subscriptionId")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "subscriptionId", valid_564149
  var valid_564150 = path.getOrDefault("resourceGroupName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "resourceGroupName", valid_564150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564151 = query.getOrDefault("api-version")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "api-version", valid_564151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for creating an environment resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564153: Call_EnvironmentsCreateOrUpdate_564128; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an environment in the specified subscription and resource group.
  ## 
  let valid = call_564153.validator(path, query, header, formData, body)
  let scheme = call_564153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564153.url(scheme.get, call_564153.host, call_564153.base,
                         call_564153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564153, url, valid)

proc call*(call_564154: Call_EnvironmentsCreateOrUpdate_564128; apiVersion: string;
          environmentName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## environmentsCreateOrUpdate
  ## Create or update an environment in the specified subscription and resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentName: string (required)
  ##                  : Name of the environment
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   parameters: JObject (required)
  ##             : Parameters for creating an environment resource.
  var path_564155 = newJObject()
  var query_564156 = newJObject()
  var body_564157 = newJObject()
  add(query_564156, "api-version", newJString(apiVersion))
  add(path_564155, "environmentName", newJString(environmentName))
  add(path_564155, "subscriptionId", newJString(subscriptionId))
  add(path_564155, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564157 = parameters
  result = call_564154.call(path_564155, query_564156, nil, nil, body_564157)

var environmentsCreateOrUpdate* = Call_EnvironmentsCreateOrUpdate_564128(
    name: "environmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsCreateOrUpdate_564129, base: "",
    url: url_EnvironmentsCreateOrUpdate_564130, schemes: {Scheme.Https})
type
  Call_EnvironmentsGet_564117 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsGet_564119(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsGet_564118(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the environment with the specified name in the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564120 = path.getOrDefault("environmentName")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "environmentName", valid_564120
  var valid_564121 = path.getOrDefault("subscriptionId")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "subscriptionId", valid_564121
  var valid_564122 = path.getOrDefault("resourceGroupName")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "resourceGroupName", valid_564122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564123 = query.getOrDefault("api-version")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "api-version", valid_564123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564124: Call_EnvironmentsGet_564117; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the environment with the specified name in the specified subscription and resource group.
  ## 
  let valid = call_564124.validator(path, query, header, formData, body)
  let scheme = call_564124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564124.url(scheme.get, call_564124.host, call_564124.base,
                         call_564124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564124, url, valid)

proc call*(call_564125: Call_EnvironmentsGet_564117; apiVersion: string;
          environmentName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## environmentsGet
  ## Gets the environment with the specified name in the specified subscription and resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564126 = newJObject()
  var query_564127 = newJObject()
  add(query_564127, "api-version", newJString(apiVersion))
  add(path_564126, "environmentName", newJString(environmentName))
  add(path_564126, "subscriptionId", newJString(subscriptionId))
  add(path_564126, "resourceGroupName", newJString(resourceGroupName))
  result = call_564125.call(path_564126, query_564127, nil, nil, nil)

var environmentsGet* = Call_EnvironmentsGet_564117(name: "environmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsGet_564118, base: "", url: url_EnvironmentsGet_564119,
    schemes: {Scheme.Https})
type
  Call_EnvironmentsUpdate_564169 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsUpdate_564171(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsUpdate_564170(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the environment with the specified name in the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564172 = path.getOrDefault("environmentName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "environmentName", valid_564172
  var valid_564173 = path.getOrDefault("subscriptionId")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "subscriptionId", valid_564173
  var valid_564174 = path.getOrDefault("resourceGroupName")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "resourceGroupName", valid_564174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564175 = query.getOrDefault("api-version")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "api-version", valid_564175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   environmentUpdateParameters: JObject (required)
  ##                              : Request object that contains the updated information for the environment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564177: Call_EnvironmentsUpdate_564169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the environment with the specified name in the specified subscription and resource group.
  ## 
  let valid = call_564177.validator(path, query, header, formData, body)
  let scheme = call_564177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564177.url(scheme.get, call_564177.host, call_564177.base,
                         call_564177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564177, url, valid)

proc call*(call_564178: Call_EnvironmentsUpdate_564169; apiVersion: string;
          environmentName: string; subscriptionId: string;
          environmentUpdateParameters: JsonNode; resourceGroupName: string): Recallable =
  ## environmentsUpdate
  ## Updates the environment with the specified name in the specified subscription and resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentUpdateParameters: JObject (required)
  ##                              : Request object that contains the updated information for the environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564179 = newJObject()
  var query_564180 = newJObject()
  var body_564181 = newJObject()
  add(query_564180, "api-version", newJString(apiVersion))
  add(path_564179, "environmentName", newJString(environmentName))
  add(path_564179, "subscriptionId", newJString(subscriptionId))
  if environmentUpdateParameters != nil:
    body_564181 = environmentUpdateParameters
  add(path_564179, "resourceGroupName", newJString(resourceGroupName))
  result = call_564178.call(path_564179, query_564180, nil, nil, body_564181)

var environmentsUpdate* = Call_EnvironmentsUpdate_564169(
    name: "environmentsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsUpdate_564170, base: "",
    url: url_EnvironmentsUpdate_564171, schemes: {Scheme.Https})
type
  Call_EnvironmentsDelete_564158 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsDelete_564160(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsDelete_564159(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the environment with the specified name in the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564161 = path.getOrDefault("environmentName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "environmentName", valid_564161
  var valid_564162 = path.getOrDefault("subscriptionId")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "subscriptionId", valid_564162
  var valid_564163 = path.getOrDefault("resourceGroupName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "resourceGroupName", valid_564163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564164 = query.getOrDefault("api-version")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "api-version", valid_564164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564165: Call_EnvironmentsDelete_564158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the environment with the specified name in the specified subscription and resource group.
  ## 
  let valid = call_564165.validator(path, query, header, formData, body)
  let scheme = call_564165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564165.url(scheme.get, call_564165.host, call_564165.base,
                         call_564165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564165, url, valid)

proc call*(call_564166: Call_EnvironmentsDelete_564158; apiVersion: string;
          environmentName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## environmentsDelete
  ## Deletes the environment with the specified name in the specified subscription and resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564167 = newJObject()
  var query_564168 = newJObject()
  add(query_564168, "api-version", newJString(apiVersion))
  add(path_564167, "environmentName", newJString(environmentName))
  add(path_564167, "subscriptionId", newJString(subscriptionId))
  add(path_564167, "resourceGroupName", newJString(resourceGroupName))
  result = call_564166.call(path_564167, query_564168, nil, nil, nil)

var environmentsDelete* = Call_EnvironmentsDelete_564158(
    name: "environmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsDelete_564159, base: "",
    url: url_EnvironmentsDelete_564160, schemes: {Scheme.Https})
type
  Call_AccessPoliciesListByEnvironment_564182 = ref object of OpenApiRestCall_563564
proc url_AccessPoliciesListByEnvironment_564184(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/accessPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccessPoliciesListByEnvironment_564183(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available access policies associated with the environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564185 = path.getOrDefault("environmentName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "environmentName", valid_564185
  var valid_564186 = path.getOrDefault("subscriptionId")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "subscriptionId", valid_564186
  var valid_564187 = path.getOrDefault("resourceGroupName")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "resourceGroupName", valid_564187
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564188 = query.getOrDefault("api-version")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "api-version", valid_564188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564189: Call_AccessPoliciesListByEnvironment_564182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the available access policies associated with the environment.
  ## 
  let valid = call_564189.validator(path, query, header, formData, body)
  let scheme = call_564189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564189.url(scheme.get, call_564189.host, call_564189.base,
                         call_564189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564189, url, valid)

proc call*(call_564190: Call_AccessPoliciesListByEnvironment_564182;
          apiVersion: string; environmentName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## accessPoliciesListByEnvironment
  ## Lists all the available access policies associated with the environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564191 = newJObject()
  var query_564192 = newJObject()
  add(query_564192, "api-version", newJString(apiVersion))
  add(path_564191, "environmentName", newJString(environmentName))
  add(path_564191, "subscriptionId", newJString(subscriptionId))
  add(path_564191, "resourceGroupName", newJString(resourceGroupName))
  result = call_564190.call(path_564191, query_564192, nil, nil, nil)

var accessPoliciesListByEnvironment* = Call_AccessPoliciesListByEnvironment_564182(
    name: "accessPoliciesListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies",
    validator: validate_AccessPoliciesListByEnvironment_564183, base: "",
    url: url_AccessPoliciesListByEnvironment_564184, schemes: {Scheme.Https})
type
  Call_AccessPoliciesCreateOrUpdate_564205 = ref object of OpenApiRestCall_563564
proc url_AccessPoliciesCreateOrUpdate_564207(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  assert "accessPolicyName" in path,
        "`accessPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/accessPolicies/"),
               (kind: VariableSegment, value: "accessPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccessPoliciesCreateOrUpdate_564206(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an access policy in the specified environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   accessPolicyName: JString (required)
  ##                   : Name of the access policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564208 = path.getOrDefault("environmentName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "environmentName", valid_564208
  var valid_564209 = path.getOrDefault("subscriptionId")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "subscriptionId", valid_564209
  var valid_564210 = path.getOrDefault("resourceGroupName")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "resourceGroupName", valid_564210
  var valid_564211 = path.getOrDefault("accessPolicyName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "accessPolicyName", valid_564211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564212 = query.getOrDefault("api-version")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "api-version", valid_564212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for creating an access policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564214: Call_AccessPoliciesCreateOrUpdate_564205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an access policy in the specified environment.
  ## 
  let valid = call_564214.validator(path, query, header, formData, body)
  let scheme = call_564214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564214.url(scheme.get, call_564214.host, call_564214.base,
                         call_564214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564214, url, valid)

proc call*(call_564215: Call_AccessPoliciesCreateOrUpdate_564205;
          apiVersion: string; environmentName: string; subscriptionId: string;
          resourceGroupName: string; accessPolicyName: string; parameters: JsonNode): Recallable =
  ## accessPoliciesCreateOrUpdate
  ## Create or update an access policy in the specified environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   accessPolicyName: string (required)
  ##                   : Name of the access policy.
  ##   parameters: JObject (required)
  ##             : Parameters for creating an access policy.
  var path_564216 = newJObject()
  var query_564217 = newJObject()
  var body_564218 = newJObject()
  add(query_564217, "api-version", newJString(apiVersion))
  add(path_564216, "environmentName", newJString(environmentName))
  add(path_564216, "subscriptionId", newJString(subscriptionId))
  add(path_564216, "resourceGroupName", newJString(resourceGroupName))
  add(path_564216, "accessPolicyName", newJString(accessPolicyName))
  if parameters != nil:
    body_564218 = parameters
  result = call_564215.call(path_564216, query_564217, nil, nil, body_564218)

var accessPoliciesCreateOrUpdate* = Call_AccessPoliciesCreateOrUpdate_564205(
    name: "accessPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesCreateOrUpdate_564206, base: "",
    url: url_AccessPoliciesCreateOrUpdate_564207, schemes: {Scheme.Https})
type
  Call_AccessPoliciesGet_564193 = ref object of OpenApiRestCall_563564
proc url_AccessPoliciesGet_564195(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  assert "accessPolicyName" in path,
        "`accessPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/accessPolicies/"),
               (kind: VariableSegment, value: "accessPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccessPoliciesGet_564194(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the access policy with the specified name in the specified environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   accessPolicyName: JString (required)
  ##                   : The name of the Time Series Insights access policy associated with the specified environment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564196 = path.getOrDefault("environmentName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "environmentName", valid_564196
  var valid_564197 = path.getOrDefault("subscriptionId")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "subscriptionId", valid_564197
  var valid_564198 = path.getOrDefault("resourceGroupName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "resourceGroupName", valid_564198
  var valid_564199 = path.getOrDefault("accessPolicyName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "accessPolicyName", valid_564199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564200 = query.getOrDefault("api-version")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "api-version", valid_564200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564201: Call_AccessPoliciesGet_564193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access policy with the specified name in the specified environment.
  ## 
  let valid = call_564201.validator(path, query, header, formData, body)
  let scheme = call_564201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564201.url(scheme.get, call_564201.host, call_564201.base,
                         call_564201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564201, url, valid)

proc call*(call_564202: Call_AccessPoliciesGet_564193; apiVersion: string;
          environmentName: string; subscriptionId: string;
          resourceGroupName: string; accessPolicyName: string): Recallable =
  ## accessPoliciesGet
  ## Gets the access policy with the specified name in the specified environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   accessPolicyName: string (required)
  ##                   : The name of the Time Series Insights access policy associated with the specified environment.
  var path_564203 = newJObject()
  var query_564204 = newJObject()
  add(query_564204, "api-version", newJString(apiVersion))
  add(path_564203, "environmentName", newJString(environmentName))
  add(path_564203, "subscriptionId", newJString(subscriptionId))
  add(path_564203, "resourceGroupName", newJString(resourceGroupName))
  add(path_564203, "accessPolicyName", newJString(accessPolicyName))
  result = call_564202.call(path_564203, query_564204, nil, nil, nil)

var accessPoliciesGet* = Call_AccessPoliciesGet_564193(name: "accessPoliciesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesGet_564194, base: "",
    url: url_AccessPoliciesGet_564195, schemes: {Scheme.Https})
type
  Call_AccessPoliciesUpdate_564231 = ref object of OpenApiRestCall_563564
proc url_AccessPoliciesUpdate_564233(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  assert "accessPolicyName" in path,
        "`accessPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/accessPolicies/"),
               (kind: VariableSegment, value: "accessPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccessPoliciesUpdate_564232(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the access policy with the specified name in the specified subscription, resource group, and environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   accessPolicyName: JString (required)
  ##                   : The name of the Time Series Insights access policy associated with the specified environment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564234 = path.getOrDefault("environmentName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "environmentName", valid_564234
  var valid_564235 = path.getOrDefault("subscriptionId")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "subscriptionId", valid_564235
  var valid_564236 = path.getOrDefault("resourceGroupName")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "resourceGroupName", valid_564236
  var valid_564237 = path.getOrDefault("accessPolicyName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "accessPolicyName", valid_564237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564238 = query.getOrDefault("api-version")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "api-version", valid_564238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   accessPolicyUpdateParameters: JObject (required)
  ##                               : Request object that contains the updated information for the access policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564240: Call_AccessPoliciesUpdate_564231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the access policy with the specified name in the specified subscription, resource group, and environment.
  ## 
  let valid = call_564240.validator(path, query, header, formData, body)
  let scheme = call_564240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564240.url(scheme.get, call_564240.host, call_564240.base,
                         call_564240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564240, url, valid)

proc call*(call_564241: Call_AccessPoliciesUpdate_564231; apiVersion: string;
          environmentName: string; subscriptionId: string;
          resourceGroupName: string; accessPolicyName: string;
          accessPolicyUpdateParameters: JsonNode): Recallable =
  ## accessPoliciesUpdate
  ## Updates the access policy with the specified name in the specified subscription, resource group, and environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   accessPolicyName: string (required)
  ##                   : The name of the Time Series Insights access policy associated with the specified environment.
  ##   accessPolicyUpdateParameters: JObject (required)
  ##                               : Request object that contains the updated information for the access policy.
  var path_564242 = newJObject()
  var query_564243 = newJObject()
  var body_564244 = newJObject()
  add(query_564243, "api-version", newJString(apiVersion))
  add(path_564242, "environmentName", newJString(environmentName))
  add(path_564242, "subscriptionId", newJString(subscriptionId))
  add(path_564242, "resourceGroupName", newJString(resourceGroupName))
  add(path_564242, "accessPolicyName", newJString(accessPolicyName))
  if accessPolicyUpdateParameters != nil:
    body_564244 = accessPolicyUpdateParameters
  result = call_564241.call(path_564242, query_564243, nil, nil, body_564244)

var accessPoliciesUpdate* = Call_AccessPoliciesUpdate_564231(
    name: "accessPoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesUpdate_564232, base: "",
    url: url_AccessPoliciesUpdate_564233, schemes: {Scheme.Https})
type
  Call_AccessPoliciesDelete_564219 = ref object of OpenApiRestCall_563564
proc url_AccessPoliciesDelete_564221(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  assert "accessPolicyName" in path,
        "`accessPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/accessPolicies/"),
               (kind: VariableSegment, value: "accessPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccessPoliciesDelete_564220(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the access policy with the specified name in the specified subscription, resource group, and environment
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   accessPolicyName: JString (required)
  ##                   : The name of the Time Series Insights access policy associated with the specified environment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564222 = path.getOrDefault("environmentName")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "environmentName", valid_564222
  var valid_564223 = path.getOrDefault("subscriptionId")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "subscriptionId", valid_564223
  var valid_564224 = path.getOrDefault("resourceGroupName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "resourceGroupName", valid_564224
  var valid_564225 = path.getOrDefault("accessPolicyName")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "accessPolicyName", valid_564225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564226 = query.getOrDefault("api-version")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "api-version", valid_564226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564227: Call_AccessPoliciesDelete_564219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the access policy with the specified name in the specified subscription, resource group, and environment
  ## 
  let valid = call_564227.validator(path, query, header, formData, body)
  let scheme = call_564227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564227.url(scheme.get, call_564227.host, call_564227.base,
                         call_564227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564227, url, valid)

proc call*(call_564228: Call_AccessPoliciesDelete_564219; apiVersion: string;
          environmentName: string; subscriptionId: string;
          resourceGroupName: string; accessPolicyName: string): Recallable =
  ## accessPoliciesDelete
  ## Deletes the access policy with the specified name in the specified subscription, resource group, and environment
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   accessPolicyName: string (required)
  ##                   : The name of the Time Series Insights access policy associated with the specified environment.
  var path_564229 = newJObject()
  var query_564230 = newJObject()
  add(query_564230, "api-version", newJString(apiVersion))
  add(path_564229, "environmentName", newJString(environmentName))
  add(path_564229, "subscriptionId", newJString(subscriptionId))
  add(path_564229, "resourceGroupName", newJString(resourceGroupName))
  add(path_564229, "accessPolicyName", newJString(accessPolicyName))
  result = call_564228.call(path_564229, query_564230, nil, nil, nil)

var accessPoliciesDelete* = Call_AccessPoliciesDelete_564219(
    name: "accessPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesDelete_564220, base: "",
    url: url_AccessPoliciesDelete_564221, schemes: {Scheme.Https})
type
  Call_EventSourcesListByEnvironment_564245 = ref object of OpenApiRestCall_563564
proc url_EventSourcesListByEnvironment_564247(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/eventSources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSourcesListByEnvironment_564246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available event sources associated with the subscription and within the specified resource group and environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564248 = path.getOrDefault("environmentName")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "environmentName", valid_564248
  var valid_564249 = path.getOrDefault("subscriptionId")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "subscriptionId", valid_564249
  var valid_564250 = path.getOrDefault("resourceGroupName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "resourceGroupName", valid_564250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564251 = query.getOrDefault("api-version")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "api-version", valid_564251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564252: Call_EventSourcesListByEnvironment_564245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available event sources associated with the subscription and within the specified resource group and environment.
  ## 
  let valid = call_564252.validator(path, query, header, formData, body)
  let scheme = call_564252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564252.url(scheme.get, call_564252.host, call_564252.base,
                         call_564252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564252, url, valid)

proc call*(call_564253: Call_EventSourcesListByEnvironment_564245;
          apiVersion: string; environmentName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## eventSourcesListByEnvironment
  ## Lists all the available event sources associated with the subscription and within the specified resource group and environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564254 = newJObject()
  var query_564255 = newJObject()
  add(query_564255, "api-version", newJString(apiVersion))
  add(path_564254, "environmentName", newJString(environmentName))
  add(path_564254, "subscriptionId", newJString(subscriptionId))
  add(path_564254, "resourceGroupName", newJString(resourceGroupName))
  result = call_564253.call(path_564254, query_564255, nil, nil, nil)

var eventSourcesListByEnvironment* = Call_EventSourcesListByEnvironment_564245(
    name: "eventSourcesListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources",
    validator: validate_EventSourcesListByEnvironment_564246, base: "",
    url: url_EventSourcesListByEnvironment_564247, schemes: {Scheme.Https})
type
  Call_EventSourcesCreateOrUpdate_564268 = ref object of OpenApiRestCall_563564
proc url_EventSourcesCreateOrUpdate_564270(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  assert "eventSourceName" in path, "`eventSourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/eventSources/"),
               (kind: VariableSegment, value: "eventSourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSourcesCreateOrUpdate_564269(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an event source under the specified environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   eventSourceName: JString (required)
  ##                  : Name of the event source.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564271 = path.getOrDefault("environmentName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "environmentName", valid_564271
  var valid_564272 = path.getOrDefault("subscriptionId")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "subscriptionId", valid_564272
  var valid_564273 = path.getOrDefault("resourceGroupName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "resourceGroupName", valid_564273
  var valid_564274 = path.getOrDefault("eventSourceName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "eventSourceName", valid_564274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564275 = query.getOrDefault("api-version")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "api-version", valid_564275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for creating an event source resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564277: Call_EventSourcesCreateOrUpdate_564268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an event source under the specified environment.
  ## 
  let valid = call_564277.validator(path, query, header, formData, body)
  let scheme = call_564277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564277.url(scheme.get, call_564277.host, call_564277.base,
                         call_564277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564277, url, valid)

proc call*(call_564278: Call_EventSourcesCreateOrUpdate_564268; apiVersion: string;
          environmentName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode; eventSourceName: string): Recallable =
  ## eventSourcesCreateOrUpdate
  ## Create or update an event source under the specified environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   parameters: JObject (required)
  ##             : Parameters for creating an event source resource.
  ##   eventSourceName: string (required)
  ##                  : Name of the event source.
  var path_564279 = newJObject()
  var query_564280 = newJObject()
  var body_564281 = newJObject()
  add(query_564280, "api-version", newJString(apiVersion))
  add(path_564279, "environmentName", newJString(environmentName))
  add(path_564279, "subscriptionId", newJString(subscriptionId))
  add(path_564279, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564281 = parameters
  add(path_564279, "eventSourceName", newJString(eventSourceName))
  result = call_564278.call(path_564279, query_564280, nil, nil, body_564281)

var eventSourcesCreateOrUpdate* = Call_EventSourcesCreateOrUpdate_564268(
    name: "eventSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesCreateOrUpdate_564269, base: "",
    url: url_EventSourcesCreateOrUpdate_564270, schemes: {Scheme.Https})
type
  Call_EventSourcesGet_564256 = ref object of OpenApiRestCall_563564
proc url_EventSourcesGet_564258(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  assert "eventSourceName" in path, "`eventSourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/eventSources/"),
               (kind: VariableSegment, value: "eventSourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSourcesGet_564257(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the event source with the specified name in the specified environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   eventSourceName: JString (required)
  ##                  : The name of the Time Series Insights event source associated with the specified environment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564259 = path.getOrDefault("environmentName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "environmentName", valid_564259
  var valid_564260 = path.getOrDefault("subscriptionId")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "subscriptionId", valid_564260
  var valid_564261 = path.getOrDefault("resourceGroupName")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "resourceGroupName", valid_564261
  var valid_564262 = path.getOrDefault("eventSourceName")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "eventSourceName", valid_564262
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564263 = query.getOrDefault("api-version")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "api-version", valid_564263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564264: Call_EventSourcesGet_564256; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the event source with the specified name in the specified environment.
  ## 
  let valid = call_564264.validator(path, query, header, formData, body)
  let scheme = call_564264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564264.url(scheme.get, call_564264.host, call_564264.base,
                         call_564264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564264, url, valid)

proc call*(call_564265: Call_EventSourcesGet_564256; apiVersion: string;
          environmentName: string; subscriptionId: string;
          resourceGroupName: string; eventSourceName: string): Recallable =
  ## eventSourcesGet
  ## Gets the event source with the specified name in the specified environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   eventSourceName: string (required)
  ##                  : The name of the Time Series Insights event source associated with the specified environment.
  var path_564266 = newJObject()
  var query_564267 = newJObject()
  add(query_564267, "api-version", newJString(apiVersion))
  add(path_564266, "environmentName", newJString(environmentName))
  add(path_564266, "subscriptionId", newJString(subscriptionId))
  add(path_564266, "resourceGroupName", newJString(resourceGroupName))
  add(path_564266, "eventSourceName", newJString(eventSourceName))
  result = call_564265.call(path_564266, query_564267, nil, nil, nil)

var eventSourcesGet* = Call_EventSourcesGet_564256(name: "eventSourcesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesGet_564257, base: "", url: url_EventSourcesGet_564258,
    schemes: {Scheme.Https})
type
  Call_EventSourcesUpdate_564294 = ref object of OpenApiRestCall_563564
proc url_EventSourcesUpdate_564296(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  assert "eventSourceName" in path, "`eventSourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/eventSources/"),
               (kind: VariableSegment, value: "eventSourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSourcesUpdate_564295(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the event source with the specified name in the specified subscription, resource group, and environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   eventSourceName: JString (required)
  ##                  : The name of the Time Series Insights event source associated with the specified environment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564297 = path.getOrDefault("environmentName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "environmentName", valid_564297
  var valid_564298 = path.getOrDefault("subscriptionId")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "subscriptionId", valid_564298
  var valid_564299 = path.getOrDefault("resourceGroupName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "resourceGroupName", valid_564299
  var valid_564300 = path.getOrDefault("eventSourceName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "eventSourceName", valid_564300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564301 = query.getOrDefault("api-version")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "api-version", valid_564301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   eventSourceUpdateParameters: JObject (required)
  ##                              : Request object that contains the updated information for the event source.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564303: Call_EventSourcesUpdate_564294; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the event source with the specified name in the specified subscription, resource group, and environment.
  ## 
  let valid = call_564303.validator(path, query, header, formData, body)
  let scheme = call_564303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564303.url(scheme.get, call_564303.host, call_564303.base,
                         call_564303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564303, url, valid)

proc call*(call_564304: Call_EventSourcesUpdate_564294; apiVersion: string;
          environmentName: string; subscriptionId: string;
          eventSourceUpdateParameters: JsonNode; resourceGroupName: string;
          eventSourceName: string): Recallable =
  ## eventSourcesUpdate
  ## Updates the event source with the specified name in the specified subscription, resource group, and environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   eventSourceUpdateParameters: JObject (required)
  ##                              : Request object that contains the updated information for the event source.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   eventSourceName: string (required)
  ##                  : The name of the Time Series Insights event source associated with the specified environment.
  var path_564305 = newJObject()
  var query_564306 = newJObject()
  var body_564307 = newJObject()
  add(query_564306, "api-version", newJString(apiVersion))
  add(path_564305, "environmentName", newJString(environmentName))
  add(path_564305, "subscriptionId", newJString(subscriptionId))
  if eventSourceUpdateParameters != nil:
    body_564307 = eventSourceUpdateParameters
  add(path_564305, "resourceGroupName", newJString(resourceGroupName))
  add(path_564305, "eventSourceName", newJString(eventSourceName))
  result = call_564304.call(path_564305, query_564306, nil, nil, body_564307)

var eventSourcesUpdate* = Call_EventSourcesUpdate_564294(
    name: "eventSourcesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesUpdate_564295, base: "",
    url: url_EventSourcesUpdate_564296, schemes: {Scheme.Https})
type
  Call_EventSourcesDelete_564282 = ref object of OpenApiRestCall_563564
proc url_EventSourcesDelete_564284(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  assert "eventSourceName" in path, "`eventSourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/eventSources/"),
               (kind: VariableSegment, value: "eventSourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventSourcesDelete_564283(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the event source with the specified name in the specified subscription, resource group, and environment
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   eventSourceName: JString (required)
  ##                  : The name of the Time Series Insights event source associated with the specified environment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564285 = path.getOrDefault("environmentName")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "environmentName", valid_564285
  var valid_564286 = path.getOrDefault("subscriptionId")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "subscriptionId", valid_564286
  var valid_564287 = path.getOrDefault("resourceGroupName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "resourceGroupName", valid_564287
  var valid_564288 = path.getOrDefault("eventSourceName")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "eventSourceName", valid_564288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564289 = query.getOrDefault("api-version")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "api-version", valid_564289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564290: Call_EventSourcesDelete_564282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the event source with the specified name in the specified subscription, resource group, and environment
  ## 
  let valid = call_564290.validator(path, query, header, formData, body)
  let scheme = call_564290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564290.url(scheme.get, call_564290.host, call_564290.base,
                         call_564290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564290, url, valid)

proc call*(call_564291: Call_EventSourcesDelete_564282; apiVersion: string;
          environmentName: string; subscriptionId: string;
          resourceGroupName: string; eventSourceName: string): Recallable =
  ## eventSourcesDelete
  ## Deletes the event source with the specified name in the specified subscription, resource group, and environment
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   eventSourceName: string (required)
  ##                  : The name of the Time Series Insights event source associated with the specified environment.
  var path_564292 = newJObject()
  var query_564293 = newJObject()
  add(query_564293, "api-version", newJString(apiVersion))
  add(path_564292, "environmentName", newJString(environmentName))
  add(path_564292, "subscriptionId", newJString(subscriptionId))
  add(path_564292, "resourceGroupName", newJString(resourceGroupName))
  add(path_564292, "eventSourceName", newJString(eventSourceName))
  result = call_564291.call(path_564292, query_564293, nil, nil, nil)

var eventSourcesDelete* = Call_EventSourcesDelete_564282(
    name: "eventSourcesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesDelete_564283, base: "",
    url: url_EventSourcesDelete_564284, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsListByEnvironment_564308 = ref object of OpenApiRestCall_563564
proc url_ReferenceDataSetsListByEnvironment_564310(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/referenceDataSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReferenceDataSetsListByEnvironment_564309(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available reference data sets associated with the subscription and within the specified resource group and environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564311 = path.getOrDefault("environmentName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "environmentName", valid_564311
  var valid_564312 = path.getOrDefault("subscriptionId")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "subscriptionId", valid_564312
  var valid_564313 = path.getOrDefault("resourceGroupName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "resourceGroupName", valid_564313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564314 = query.getOrDefault("api-version")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "api-version", valid_564314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564315: Call_ReferenceDataSetsListByEnvironment_564308;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the available reference data sets associated with the subscription and within the specified resource group and environment.
  ## 
  let valid = call_564315.validator(path, query, header, formData, body)
  let scheme = call_564315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564315.url(scheme.get, call_564315.host, call_564315.base,
                         call_564315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564315, url, valid)

proc call*(call_564316: Call_ReferenceDataSetsListByEnvironment_564308;
          apiVersion: string; environmentName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## referenceDataSetsListByEnvironment
  ## Lists all the available reference data sets associated with the subscription and within the specified resource group and environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564317 = newJObject()
  var query_564318 = newJObject()
  add(query_564318, "api-version", newJString(apiVersion))
  add(path_564317, "environmentName", newJString(environmentName))
  add(path_564317, "subscriptionId", newJString(subscriptionId))
  add(path_564317, "resourceGroupName", newJString(resourceGroupName))
  result = call_564316.call(path_564317, query_564318, nil, nil, nil)

var referenceDataSetsListByEnvironment* = Call_ReferenceDataSetsListByEnvironment_564308(
    name: "referenceDataSetsListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets",
    validator: validate_ReferenceDataSetsListByEnvironment_564309, base: "",
    url: url_ReferenceDataSetsListByEnvironment_564310, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsCreateOrUpdate_564331 = ref object of OpenApiRestCall_563564
proc url_ReferenceDataSetsCreateOrUpdate_564333(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  assert "referenceDataSetName" in path,
        "`referenceDataSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/referenceDataSets/"),
               (kind: VariableSegment, value: "referenceDataSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReferenceDataSetsCreateOrUpdate_564332(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a reference data set in the specified environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   referenceDataSetName: JString (required)
  ##                       : Name of the reference data set.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564334 = path.getOrDefault("environmentName")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "environmentName", valid_564334
  var valid_564335 = path.getOrDefault("referenceDataSetName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "referenceDataSetName", valid_564335
  var valid_564336 = path.getOrDefault("subscriptionId")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "subscriptionId", valid_564336
  var valid_564337 = path.getOrDefault("resourceGroupName")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "resourceGroupName", valid_564337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564338 = query.getOrDefault("api-version")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "api-version", valid_564338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for creating a reference data set.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564340: Call_ReferenceDataSetsCreateOrUpdate_564331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a reference data set in the specified environment.
  ## 
  let valid = call_564340.validator(path, query, header, formData, body)
  let scheme = call_564340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564340.url(scheme.get, call_564340.host, call_564340.base,
                         call_564340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564340, url, valid)

proc call*(call_564341: Call_ReferenceDataSetsCreateOrUpdate_564331;
          apiVersion: string; environmentName: string; referenceDataSetName: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## referenceDataSetsCreateOrUpdate
  ## Create or update a reference data set in the specified environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   referenceDataSetName: string (required)
  ##                       : Name of the reference data set.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   parameters: JObject (required)
  ##             : Parameters for creating a reference data set.
  var path_564342 = newJObject()
  var query_564343 = newJObject()
  var body_564344 = newJObject()
  add(query_564343, "api-version", newJString(apiVersion))
  add(path_564342, "environmentName", newJString(environmentName))
  add(path_564342, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_564342, "subscriptionId", newJString(subscriptionId))
  add(path_564342, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564344 = parameters
  result = call_564341.call(path_564342, query_564343, nil, nil, body_564344)

var referenceDataSetsCreateOrUpdate* = Call_ReferenceDataSetsCreateOrUpdate_564331(
    name: "referenceDataSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsCreateOrUpdate_564332, base: "",
    url: url_ReferenceDataSetsCreateOrUpdate_564333, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsGet_564319 = ref object of OpenApiRestCall_563564
proc url_ReferenceDataSetsGet_564321(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  assert "referenceDataSetName" in path,
        "`referenceDataSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/referenceDataSets/"),
               (kind: VariableSegment, value: "referenceDataSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReferenceDataSetsGet_564320(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the reference data set with the specified name in the specified environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   referenceDataSetName: JString (required)
  ##                       : The name of the Time Series Insights reference data set associated with the specified environment.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564322 = path.getOrDefault("environmentName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "environmentName", valid_564322
  var valid_564323 = path.getOrDefault("referenceDataSetName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "referenceDataSetName", valid_564323
  var valid_564324 = path.getOrDefault("subscriptionId")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "subscriptionId", valid_564324
  var valid_564325 = path.getOrDefault("resourceGroupName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "resourceGroupName", valid_564325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564326 = query.getOrDefault("api-version")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "api-version", valid_564326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564327: Call_ReferenceDataSetsGet_564319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the reference data set with the specified name in the specified environment.
  ## 
  let valid = call_564327.validator(path, query, header, formData, body)
  let scheme = call_564327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564327.url(scheme.get, call_564327.host, call_564327.base,
                         call_564327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564327, url, valid)

proc call*(call_564328: Call_ReferenceDataSetsGet_564319; apiVersion: string;
          environmentName: string; referenceDataSetName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## referenceDataSetsGet
  ## Gets the reference data set with the specified name in the specified environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   referenceDataSetName: string (required)
  ##                       : The name of the Time Series Insights reference data set associated with the specified environment.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564329 = newJObject()
  var query_564330 = newJObject()
  add(query_564330, "api-version", newJString(apiVersion))
  add(path_564329, "environmentName", newJString(environmentName))
  add(path_564329, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_564329, "subscriptionId", newJString(subscriptionId))
  add(path_564329, "resourceGroupName", newJString(resourceGroupName))
  result = call_564328.call(path_564329, query_564330, nil, nil, nil)

var referenceDataSetsGet* = Call_ReferenceDataSetsGet_564319(
    name: "referenceDataSetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsGet_564320, base: "",
    url: url_ReferenceDataSetsGet_564321, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsUpdate_564357 = ref object of OpenApiRestCall_563564
proc url_ReferenceDataSetsUpdate_564359(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  assert "referenceDataSetName" in path,
        "`referenceDataSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/referenceDataSets/"),
               (kind: VariableSegment, value: "referenceDataSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReferenceDataSetsUpdate_564358(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the reference data set with the specified name in the specified subscription, resource group, and environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   referenceDataSetName: JString (required)
  ##                       : The name of the Time Series Insights reference data set associated with the specified environment.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564360 = path.getOrDefault("environmentName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "environmentName", valid_564360
  var valid_564361 = path.getOrDefault("referenceDataSetName")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "referenceDataSetName", valid_564361
  var valid_564362 = path.getOrDefault("subscriptionId")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "subscriptionId", valid_564362
  var valid_564363 = path.getOrDefault("resourceGroupName")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "resourceGroupName", valid_564363
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564364 = query.getOrDefault("api-version")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "api-version", valid_564364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   referenceDataSetUpdateParameters: JObject (required)
  ##                                   : Request object that contains the updated information for the reference data set.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564366: Call_ReferenceDataSetsUpdate_564357; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the reference data set with the specified name in the specified subscription, resource group, and environment.
  ## 
  let valid = call_564366.validator(path, query, header, formData, body)
  let scheme = call_564366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564366.url(scheme.get, call_564366.host, call_564366.base,
                         call_564366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564366, url, valid)

proc call*(call_564367: Call_ReferenceDataSetsUpdate_564357; apiVersion: string;
          referenceDataSetUpdateParameters: JsonNode; environmentName: string;
          referenceDataSetName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## referenceDataSetsUpdate
  ## Updates the reference data set with the specified name in the specified subscription, resource group, and environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   referenceDataSetUpdateParameters: JObject (required)
  ##                                   : Request object that contains the updated information for the reference data set.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   referenceDataSetName: string (required)
  ##                       : The name of the Time Series Insights reference data set associated with the specified environment.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564368 = newJObject()
  var query_564369 = newJObject()
  var body_564370 = newJObject()
  add(query_564369, "api-version", newJString(apiVersion))
  if referenceDataSetUpdateParameters != nil:
    body_564370 = referenceDataSetUpdateParameters
  add(path_564368, "environmentName", newJString(environmentName))
  add(path_564368, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_564368, "subscriptionId", newJString(subscriptionId))
  add(path_564368, "resourceGroupName", newJString(resourceGroupName))
  result = call_564367.call(path_564368, query_564369, nil, nil, body_564370)

var referenceDataSetsUpdate* = Call_ReferenceDataSetsUpdate_564357(
    name: "referenceDataSetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsUpdate_564358, base: "",
    url: url_ReferenceDataSetsUpdate_564359, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsDelete_564345 = ref object of OpenApiRestCall_563564
proc url_ReferenceDataSetsDelete_564347(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "environmentName" in path, "`environmentName` is a required path parameter"
  assert "referenceDataSetName" in path,
        "`referenceDataSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.TimeSeriesInsights/environments/"),
               (kind: VariableSegment, value: "environmentName"),
               (kind: ConstantSegment, value: "/referenceDataSets/"),
               (kind: VariableSegment, value: "referenceDataSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReferenceDataSetsDelete_564346(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the reference data set with the specified name in the specified subscription, resource group, and environment
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   referenceDataSetName: JString (required)
  ##                       : The name of the Time Series Insights reference data set associated with the specified environment.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentName` field"
  var valid_564348 = path.getOrDefault("environmentName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "environmentName", valid_564348
  var valid_564349 = path.getOrDefault("referenceDataSetName")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "referenceDataSetName", valid_564349
  var valid_564350 = path.getOrDefault("subscriptionId")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "subscriptionId", valid_564350
  var valid_564351 = path.getOrDefault("resourceGroupName")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "resourceGroupName", valid_564351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564352 = query.getOrDefault("api-version")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "api-version", valid_564352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564353: Call_ReferenceDataSetsDelete_564345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the reference data set with the specified name in the specified subscription, resource group, and environment
  ## 
  let valid = call_564353.validator(path, query, header, formData, body)
  let scheme = call_564353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564353.url(scheme.get, call_564353.host, call_564353.base,
                         call_564353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564353, url, valid)

proc call*(call_564354: Call_ReferenceDataSetsDelete_564345; apiVersion: string;
          environmentName: string; referenceDataSetName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## referenceDataSetsDelete
  ## Deletes the reference data set with the specified name in the specified subscription, resource group, and environment
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   referenceDataSetName: string (required)
  ##                       : The name of the Time Series Insights reference data set associated with the specified environment.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564355 = newJObject()
  var query_564356 = newJObject()
  add(query_564356, "api-version", newJString(apiVersion))
  add(path_564355, "environmentName", newJString(environmentName))
  add(path_564355, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_564355, "subscriptionId", newJString(subscriptionId))
  add(path_564355, "resourceGroupName", newJString(resourceGroupName))
  result = call_564354.call(path_564355, query_564356, nil, nil, nil)

var referenceDataSetsDelete* = Call_ReferenceDataSetsDelete_564345(
    name: "referenceDataSetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsDelete_564346, base: "",
    url: url_ReferenceDataSetsDelete_564347, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
