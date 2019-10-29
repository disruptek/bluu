
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: TimeSeriesInsightsClient
## version: 2018-08-15-preview
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
  ##              : Version of the API to be used with the client request.
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
  ##             : Version of the API to be used with the client request.
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
  ##              : Version of the API to be used with the client request.
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
  ##             : Version of the API to be used with the client request.
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
  ##              : Version of the API to be used with the client request.
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
  ##             : Version of the API to be used with the client request.
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
  Call_EnvironmentsCreateOrUpdate_564130 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsCreateOrUpdate_564132(protocol: Scheme; host: string;
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

proc validate_EnvironmentsCreateOrUpdate_564131(path: JsonNode; query: JsonNode;
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
  var valid_564150 = path.getOrDefault("environmentName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "environmentName", valid_564150
  var valid_564151 = path.getOrDefault("subscriptionId")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "subscriptionId", valid_564151
  var valid_564152 = path.getOrDefault("resourceGroupName")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "resourceGroupName", valid_564152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564153 = query.getOrDefault("api-version")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "api-version", valid_564153
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

proc call*(call_564155: Call_EnvironmentsCreateOrUpdate_564130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an environment in the specified subscription and resource group.
  ## 
  let valid = call_564155.validator(path, query, header, formData, body)
  let scheme = call_564155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564155.url(scheme.get, call_564155.host, call_564155.base,
                         call_564155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564155, url, valid)

proc call*(call_564156: Call_EnvironmentsCreateOrUpdate_564130; apiVersion: string;
          environmentName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## environmentsCreateOrUpdate
  ## Create or update an environment in the specified subscription and resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   environmentName: string (required)
  ##                  : Name of the environment
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   parameters: JObject (required)
  ##             : Parameters for creating an environment resource.
  var path_564157 = newJObject()
  var query_564158 = newJObject()
  var body_564159 = newJObject()
  add(query_564158, "api-version", newJString(apiVersion))
  add(path_564157, "environmentName", newJString(environmentName))
  add(path_564157, "subscriptionId", newJString(subscriptionId))
  add(path_564157, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564159 = parameters
  result = call_564156.call(path_564157, query_564158, nil, nil, body_564159)

var environmentsCreateOrUpdate* = Call_EnvironmentsCreateOrUpdate_564130(
    name: "environmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsCreateOrUpdate_564131, base: "",
    url: url_EnvironmentsCreateOrUpdate_564132, schemes: {Scheme.Https})
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
  var valid_564121 = path.getOrDefault("environmentName")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "environmentName", valid_564121
  var valid_564122 = path.getOrDefault("subscriptionId")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "subscriptionId", valid_564122
  var valid_564123 = path.getOrDefault("resourceGroupName")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "resourceGroupName", valid_564123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $expand: JString
  ##          : Setting $expand=status will include the status of the internal services of the environment in the Time Series Insights service.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564124 = query.getOrDefault("api-version")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "api-version", valid_564124
  var valid_564125 = query.getOrDefault("$expand")
  valid_564125 = validateParameter(valid_564125, JString, required = false,
                                 default = nil)
  if valid_564125 != nil:
    section.add "$expand", valid_564125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564126: Call_EnvironmentsGet_564117; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the environment with the specified name in the specified subscription and resource group.
  ## 
  let valid = call_564126.validator(path, query, header, formData, body)
  let scheme = call_564126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564126.url(scheme.get, call_564126.host, call_564126.base,
                         call_564126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564126, url, valid)

proc call*(call_564127: Call_EnvironmentsGet_564117; apiVersion: string;
          environmentName: string; subscriptionId: string;
          resourceGroupName: string; Expand: string = ""): Recallable =
  ## environmentsGet
  ## Gets the environment with the specified name in the specified subscription and resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   Expand: string
  ##         : Setting $expand=status will include the status of the internal services of the environment in the Time Series Insights service.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564128 = newJObject()
  var query_564129 = newJObject()
  add(query_564129, "api-version", newJString(apiVersion))
  add(path_564128, "environmentName", newJString(environmentName))
  add(query_564129, "$expand", newJString(Expand))
  add(path_564128, "subscriptionId", newJString(subscriptionId))
  add(path_564128, "resourceGroupName", newJString(resourceGroupName))
  result = call_564127.call(path_564128, query_564129, nil, nil, nil)

var environmentsGet* = Call_EnvironmentsGet_564117(name: "environmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsGet_564118, base: "", url: url_EnvironmentsGet_564119,
    schemes: {Scheme.Https})
type
  Call_EnvironmentsUpdate_564171 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsUpdate_564173(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsUpdate_564172(path: JsonNode; query: JsonNode;
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
  var valid_564174 = path.getOrDefault("environmentName")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "environmentName", valid_564174
  var valid_564175 = path.getOrDefault("subscriptionId")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "subscriptionId", valid_564175
  var valid_564176 = path.getOrDefault("resourceGroupName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "resourceGroupName", valid_564176
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564177 = query.getOrDefault("api-version")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "api-version", valid_564177
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

proc call*(call_564179: Call_EnvironmentsUpdate_564171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the environment with the specified name in the specified subscription and resource group.
  ## 
  let valid = call_564179.validator(path, query, header, formData, body)
  let scheme = call_564179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564179.url(scheme.get, call_564179.host, call_564179.base,
                         call_564179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564179, url, valid)

proc call*(call_564180: Call_EnvironmentsUpdate_564171; apiVersion: string;
          environmentName: string; subscriptionId: string;
          environmentUpdateParameters: JsonNode; resourceGroupName: string): Recallable =
  ## environmentsUpdate
  ## Updates the environment with the specified name in the specified subscription and resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentUpdateParameters: JObject (required)
  ##                              : Request object that contains the updated information for the environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564181 = newJObject()
  var query_564182 = newJObject()
  var body_564183 = newJObject()
  add(query_564182, "api-version", newJString(apiVersion))
  add(path_564181, "environmentName", newJString(environmentName))
  add(path_564181, "subscriptionId", newJString(subscriptionId))
  if environmentUpdateParameters != nil:
    body_564183 = environmentUpdateParameters
  add(path_564181, "resourceGroupName", newJString(resourceGroupName))
  result = call_564180.call(path_564181, query_564182, nil, nil, body_564183)

var environmentsUpdate* = Call_EnvironmentsUpdate_564171(
    name: "environmentsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsUpdate_564172, base: "",
    url: url_EnvironmentsUpdate_564173, schemes: {Scheme.Https})
type
  Call_EnvironmentsDelete_564160 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsDelete_564162(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsDelete_564161(path: JsonNode; query: JsonNode;
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
  var valid_564163 = path.getOrDefault("environmentName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "environmentName", valid_564163
  var valid_564164 = path.getOrDefault("subscriptionId")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "subscriptionId", valid_564164
  var valid_564165 = path.getOrDefault("resourceGroupName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "resourceGroupName", valid_564165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564166 = query.getOrDefault("api-version")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "api-version", valid_564166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564167: Call_EnvironmentsDelete_564160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the environment with the specified name in the specified subscription and resource group.
  ## 
  let valid = call_564167.validator(path, query, header, formData, body)
  let scheme = call_564167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564167.url(scheme.get, call_564167.host, call_564167.base,
                         call_564167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564167, url, valid)

proc call*(call_564168: Call_EnvironmentsDelete_564160; apiVersion: string;
          environmentName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## environmentsDelete
  ## Deletes the environment with the specified name in the specified subscription and resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564169 = newJObject()
  var query_564170 = newJObject()
  add(query_564170, "api-version", newJString(apiVersion))
  add(path_564169, "environmentName", newJString(environmentName))
  add(path_564169, "subscriptionId", newJString(subscriptionId))
  add(path_564169, "resourceGroupName", newJString(resourceGroupName))
  result = call_564168.call(path_564169, query_564170, nil, nil, nil)

var environmentsDelete* = Call_EnvironmentsDelete_564160(
    name: "environmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsDelete_564161, base: "",
    url: url_EnvironmentsDelete_564162, schemes: {Scheme.Https})
type
  Call_AccessPoliciesListByEnvironment_564184 = ref object of OpenApiRestCall_563564
proc url_AccessPoliciesListByEnvironment_564186(protocol: Scheme; host: string;
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

proc validate_AccessPoliciesListByEnvironment_564185(path: JsonNode;
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
  var valid_564187 = path.getOrDefault("environmentName")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "environmentName", valid_564187
  var valid_564188 = path.getOrDefault("subscriptionId")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "subscriptionId", valid_564188
  var valid_564189 = path.getOrDefault("resourceGroupName")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "resourceGroupName", valid_564189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564190 = query.getOrDefault("api-version")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "api-version", valid_564190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564191: Call_AccessPoliciesListByEnvironment_564184;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the available access policies associated with the environment.
  ## 
  let valid = call_564191.validator(path, query, header, formData, body)
  let scheme = call_564191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564191.url(scheme.get, call_564191.host, call_564191.base,
                         call_564191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564191, url, valid)

proc call*(call_564192: Call_AccessPoliciesListByEnvironment_564184;
          apiVersion: string; environmentName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## accessPoliciesListByEnvironment
  ## Lists all the available access policies associated with the environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564193 = newJObject()
  var query_564194 = newJObject()
  add(query_564194, "api-version", newJString(apiVersion))
  add(path_564193, "environmentName", newJString(environmentName))
  add(path_564193, "subscriptionId", newJString(subscriptionId))
  add(path_564193, "resourceGroupName", newJString(resourceGroupName))
  result = call_564192.call(path_564193, query_564194, nil, nil, nil)

var accessPoliciesListByEnvironment* = Call_AccessPoliciesListByEnvironment_564184(
    name: "accessPoliciesListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies",
    validator: validate_AccessPoliciesListByEnvironment_564185, base: "",
    url: url_AccessPoliciesListByEnvironment_564186, schemes: {Scheme.Https})
type
  Call_AccessPoliciesCreateOrUpdate_564207 = ref object of OpenApiRestCall_563564
proc url_AccessPoliciesCreateOrUpdate_564209(protocol: Scheme; host: string;
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

proc validate_AccessPoliciesCreateOrUpdate_564208(path: JsonNode; query: JsonNode;
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
  var valid_564210 = path.getOrDefault("environmentName")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "environmentName", valid_564210
  var valid_564211 = path.getOrDefault("subscriptionId")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "subscriptionId", valid_564211
  var valid_564212 = path.getOrDefault("resourceGroupName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "resourceGroupName", valid_564212
  var valid_564213 = path.getOrDefault("accessPolicyName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "accessPolicyName", valid_564213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564214 = query.getOrDefault("api-version")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "api-version", valid_564214
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

proc call*(call_564216: Call_AccessPoliciesCreateOrUpdate_564207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an access policy in the specified environment.
  ## 
  let valid = call_564216.validator(path, query, header, formData, body)
  let scheme = call_564216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564216.url(scheme.get, call_564216.host, call_564216.base,
                         call_564216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564216, url, valid)

proc call*(call_564217: Call_AccessPoliciesCreateOrUpdate_564207;
          apiVersion: string; environmentName: string; subscriptionId: string;
          resourceGroupName: string; accessPolicyName: string; parameters: JsonNode): Recallable =
  ## accessPoliciesCreateOrUpdate
  ## Create or update an access policy in the specified environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
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
  var path_564218 = newJObject()
  var query_564219 = newJObject()
  var body_564220 = newJObject()
  add(query_564219, "api-version", newJString(apiVersion))
  add(path_564218, "environmentName", newJString(environmentName))
  add(path_564218, "subscriptionId", newJString(subscriptionId))
  add(path_564218, "resourceGroupName", newJString(resourceGroupName))
  add(path_564218, "accessPolicyName", newJString(accessPolicyName))
  if parameters != nil:
    body_564220 = parameters
  result = call_564217.call(path_564218, query_564219, nil, nil, body_564220)

var accessPoliciesCreateOrUpdate* = Call_AccessPoliciesCreateOrUpdate_564207(
    name: "accessPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesCreateOrUpdate_564208, base: "",
    url: url_AccessPoliciesCreateOrUpdate_564209, schemes: {Scheme.Https})
type
  Call_AccessPoliciesGet_564195 = ref object of OpenApiRestCall_563564
proc url_AccessPoliciesGet_564197(protocol: Scheme; host: string; base: string;
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

proc validate_AccessPoliciesGet_564196(path: JsonNode; query: JsonNode;
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
  var valid_564198 = path.getOrDefault("environmentName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "environmentName", valid_564198
  var valid_564199 = path.getOrDefault("subscriptionId")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "subscriptionId", valid_564199
  var valid_564200 = path.getOrDefault("resourceGroupName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "resourceGroupName", valid_564200
  var valid_564201 = path.getOrDefault("accessPolicyName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "accessPolicyName", valid_564201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564202 = query.getOrDefault("api-version")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "api-version", valid_564202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564203: Call_AccessPoliciesGet_564195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access policy with the specified name in the specified environment.
  ## 
  let valid = call_564203.validator(path, query, header, formData, body)
  let scheme = call_564203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564203.url(scheme.get, call_564203.host, call_564203.base,
                         call_564203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564203, url, valid)

proc call*(call_564204: Call_AccessPoliciesGet_564195; apiVersion: string;
          environmentName: string; subscriptionId: string;
          resourceGroupName: string; accessPolicyName: string): Recallable =
  ## accessPoliciesGet
  ## Gets the access policy with the specified name in the specified environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   accessPolicyName: string (required)
  ##                   : The name of the Time Series Insights access policy associated with the specified environment.
  var path_564205 = newJObject()
  var query_564206 = newJObject()
  add(query_564206, "api-version", newJString(apiVersion))
  add(path_564205, "environmentName", newJString(environmentName))
  add(path_564205, "subscriptionId", newJString(subscriptionId))
  add(path_564205, "resourceGroupName", newJString(resourceGroupName))
  add(path_564205, "accessPolicyName", newJString(accessPolicyName))
  result = call_564204.call(path_564205, query_564206, nil, nil, nil)

var accessPoliciesGet* = Call_AccessPoliciesGet_564195(name: "accessPoliciesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesGet_564196, base: "",
    url: url_AccessPoliciesGet_564197, schemes: {Scheme.Https})
type
  Call_AccessPoliciesUpdate_564233 = ref object of OpenApiRestCall_563564
proc url_AccessPoliciesUpdate_564235(protocol: Scheme; host: string; base: string;
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

proc validate_AccessPoliciesUpdate_564234(path: JsonNode; query: JsonNode;
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
  var valid_564236 = path.getOrDefault("environmentName")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "environmentName", valid_564236
  var valid_564237 = path.getOrDefault("subscriptionId")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "subscriptionId", valid_564237
  var valid_564238 = path.getOrDefault("resourceGroupName")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "resourceGroupName", valid_564238
  var valid_564239 = path.getOrDefault("accessPolicyName")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "accessPolicyName", valid_564239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564240 = query.getOrDefault("api-version")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "api-version", valid_564240
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

proc call*(call_564242: Call_AccessPoliciesUpdate_564233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the access policy with the specified name in the specified subscription, resource group, and environment.
  ## 
  let valid = call_564242.validator(path, query, header, formData, body)
  let scheme = call_564242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564242.url(scheme.get, call_564242.host, call_564242.base,
                         call_564242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564242, url, valid)

proc call*(call_564243: Call_AccessPoliciesUpdate_564233; apiVersion: string;
          environmentName: string; subscriptionId: string;
          resourceGroupName: string; accessPolicyName: string;
          accessPolicyUpdateParameters: JsonNode): Recallable =
  ## accessPoliciesUpdate
  ## Updates the access policy with the specified name in the specified subscription, resource group, and environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
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
  var path_564244 = newJObject()
  var query_564245 = newJObject()
  var body_564246 = newJObject()
  add(query_564245, "api-version", newJString(apiVersion))
  add(path_564244, "environmentName", newJString(environmentName))
  add(path_564244, "subscriptionId", newJString(subscriptionId))
  add(path_564244, "resourceGroupName", newJString(resourceGroupName))
  add(path_564244, "accessPolicyName", newJString(accessPolicyName))
  if accessPolicyUpdateParameters != nil:
    body_564246 = accessPolicyUpdateParameters
  result = call_564243.call(path_564244, query_564245, nil, nil, body_564246)

var accessPoliciesUpdate* = Call_AccessPoliciesUpdate_564233(
    name: "accessPoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesUpdate_564234, base: "",
    url: url_AccessPoliciesUpdate_564235, schemes: {Scheme.Https})
type
  Call_AccessPoliciesDelete_564221 = ref object of OpenApiRestCall_563564
proc url_AccessPoliciesDelete_564223(protocol: Scheme; host: string; base: string;
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

proc validate_AccessPoliciesDelete_564222(path: JsonNode; query: JsonNode;
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
  var valid_564224 = path.getOrDefault("environmentName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "environmentName", valid_564224
  var valid_564225 = path.getOrDefault("subscriptionId")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "subscriptionId", valid_564225
  var valid_564226 = path.getOrDefault("resourceGroupName")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "resourceGroupName", valid_564226
  var valid_564227 = path.getOrDefault("accessPolicyName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "accessPolicyName", valid_564227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564228 = query.getOrDefault("api-version")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "api-version", valid_564228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564229: Call_AccessPoliciesDelete_564221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the access policy with the specified name in the specified subscription, resource group, and environment
  ## 
  let valid = call_564229.validator(path, query, header, formData, body)
  let scheme = call_564229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564229.url(scheme.get, call_564229.host, call_564229.base,
                         call_564229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564229, url, valid)

proc call*(call_564230: Call_AccessPoliciesDelete_564221; apiVersion: string;
          environmentName: string; subscriptionId: string;
          resourceGroupName: string; accessPolicyName: string): Recallable =
  ## accessPoliciesDelete
  ## Deletes the access policy with the specified name in the specified subscription, resource group, and environment
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   accessPolicyName: string (required)
  ##                   : The name of the Time Series Insights access policy associated with the specified environment.
  var path_564231 = newJObject()
  var query_564232 = newJObject()
  add(query_564232, "api-version", newJString(apiVersion))
  add(path_564231, "environmentName", newJString(environmentName))
  add(path_564231, "subscriptionId", newJString(subscriptionId))
  add(path_564231, "resourceGroupName", newJString(resourceGroupName))
  add(path_564231, "accessPolicyName", newJString(accessPolicyName))
  result = call_564230.call(path_564231, query_564232, nil, nil, nil)

var accessPoliciesDelete* = Call_AccessPoliciesDelete_564221(
    name: "accessPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesDelete_564222, base: "",
    url: url_AccessPoliciesDelete_564223, schemes: {Scheme.Https})
type
  Call_EventSourcesListByEnvironment_564247 = ref object of OpenApiRestCall_563564
proc url_EventSourcesListByEnvironment_564249(protocol: Scheme; host: string;
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

proc validate_EventSourcesListByEnvironment_564248(path: JsonNode; query: JsonNode;
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
  var valid_564250 = path.getOrDefault("environmentName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "environmentName", valid_564250
  var valid_564251 = path.getOrDefault("subscriptionId")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "subscriptionId", valid_564251
  var valid_564252 = path.getOrDefault("resourceGroupName")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "resourceGroupName", valid_564252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564253 = query.getOrDefault("api-version")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "api-version", valid_564253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564254: Call_EventSourcesListByEnvironment_564247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available event sources associated with the subscription and within the specified resource group and environment.
  ## 
  let valid = call_564254.validator(path, query, header, formData, body)
  let scheme = call_564254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564254.url(scheme.get, call_564254.host, call_564254.base,
                         call_564254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564254, url, valid)

proc call*(call_564255: Call_EventSourcesListByEnvironment_564247;
          apiVersion: string; environmentName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## eventSourcesListByEnvironment
  ## Lists all the available event sources associated with the subscription and within the specified resource group and environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564256 = newJObject()
  var query_564257 = newJObject()
  add(query_564257, "api-version", newJString(apiVersion))
  add(path_564256, "environmentName", newJString(environmentName))
  add(path_564256, "subscriptionId", newJString(subscriptionId))
  add(path_564256, "resourceGroupName", newJString(resourceGroupName))
  result = call_564255.call(path_564256, query_564257, nil, nil, nil)

var eventSourcesListByEnvironment* = Call_EventSourcesListByEnvironment_564247(
    name: "eventSourcesListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources",
    validator: validate_EventSourcesListByEnvironment_564248, base: "",
    url: url_EventSourcesListByEnvironment_564249, schemes: {Scheme.Https})
type
  Call_EventSourcesCreateOrUpdate_564270 = ref object of OpenApiRestCall_563564
proc url_EventSourcesCreateOrUpdate_564272(protocol: Scheme; host: string;
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

proc validate_EventSourcesCreateOrUpdate_564271(path: JsonNode; query: JsonNode;
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
  var valid_564273 = path.getOrDefault("environmentName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "environmentName", valid_564273
  var valid_564274 = path.getOrDefault("subscriptionId")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "subscriptionId", valid_564274
  var valid_564275 = path.getOrDefault("resourceGroupName")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "resourceGroupName", valid_564275
  var valid_564276 = path.getOrDefault("eventSourceName")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "eventSourceName", valid_564276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564277 = query.getOrDefault("api-version")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "api-version", valid_564277
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

proc call*(call_564279: Call_EventSourcesCreateOrUpdate_564270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an event source under the specified environment.
  ## 
  let valid = call_564279.validator(path, query, header, formData, body)
  let scheme = call_564279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564279.url(scheme.get, call_564279.host, call_564279.base,
                         call_564279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564279, url, valid)

proc call*(call_564280: Call_EventSourcesCreateOrUpdate_564270; apiVersion: string;
          environmentName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode; eventSourceName: string): Recallable =
  ## eventSourcesCreateOrUpdate
  ## Create or update an event source under the specified environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
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
  var path_564281 = newJObject()
  var query_564282 = newJObject()
  var body_564283 = newJObject()
  add(query_564282, "api-version", newJString(apiVersion))
  add(path_564281, "environmentName", newJString(environmentName))
  add(path_564281, "subscriptionId", newJString(subscriptionId))
  add(path_564281, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564283 = parameters
  add(path_564281, "eventSourceName", newJString(eventSourceName))
  result = call_564280.call(path_564281, query_564282, nil, nil, body_564283)

var eventSourcesCreateOrUpdate* = Call_EventSourcesCreateOrUpdate_564270(
    name: "eventSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesCreateOrUpdate_564271, base: "",
    url: url_EventSourcesCreateOrUpdate_564272, schemes: {Scheme.Https})
type
  Call_EventSourcesGet_564258 = ref object of OpenApiRestCall_563564
proc url_EventSourcesGet_564260(protocol: Scheme; host: string; base: string;
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

proc validate_EventSourcesGet_564259(path: JsonNode; query: JsonNode;
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
  var valid_564261 = path.getOrDefault("environmentName")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "environmentName", valid_564261
  var valid_564262 = path.getOrDefault("subscriptionId")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "subscriptionId", valid_564262
  var valid_564263 = path.getOrDefault("resourceGroupName")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "resourceGroupName", valid_564263
  var valid_564264 = path.getOrDefault("eventSourceName")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "eventSourceName", valid_564264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564265 = query.getOrDefault("api-version")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "api-version", valid_564265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564266: Call_EventSourcesGet_564258; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the event source with the specified name in the specified environment.
  ## 
  let valid = call_564266.validator(path, query, header, formData, body)
  let scheme = call_564266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564266.url(scheme.get, call_564266.host, call_564266.base,
                         call_564266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564266, url, valid)

proc call*(call_564267: Call_EventSourcesGet_564258; apiVersion: string;
          environmentName: string; subscriptionId: string;
          resourceGroupName: string; eventSourceName: string): Recallable =
  ## eventSourcesGet
  ## Gets the event source with the specified name in the specified environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   eventSourceName: string (required)
  ##                  : The name of the Time Series Insights event source associated with the specified environment.
  var path_564268 = newJObject()
  var query_564269 = newJObject()
  add(query_564269, "api-version", newJString(apiVersion))
  add(path_564268, "environmentName", newJString(environmentName))
  add(path_564268, "subscriptionId", newJString(subscriptionId))
  add(path_564268, "resourceGroupName", newJString(resourceGroupName))
  add(path_564268, "eventSourceName", newJString(eventSourceName))
  result = call_564267.call(path_564268, query_564269, nil, nil, nil)

var eventSourcesGet* = Call_EventSourcesGet_564258(name: "eventSourcesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesGet_564259, base: "", url: url_EventSourcesGet_564260,
    schemes: {Scheme.Https})
type
  Call_EventSourcesUpdate_564296 = ref object of OpenApiRestCall_563564
proc url_EventSourcesUpdate_564298(protocol: Scheme; host: string; base: string;
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

proc validate_EventSourcesUpdate_564297(path: JsonNode; query: JsonNode;
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
  var valid_564299 = path.getOrDefault("environmentName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "environmentName", valid_564299
  var valid_564300 = path.getOrDefault("subscriptionId")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "subscriptionId", valid_564300
  var valid_564301 = path.getOrDefault("resourceGroupName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "resourceGroupName", valid_564301
  var valid_564302 = path.getOrDefault("eventSourceName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "eventSourceName", valid_564302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564303 = query.getOrDefault("api-version")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "api-version", valid_564303
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

proc call*(call_564305: Call_EventSourcesUpdate_564296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the event source with the specified name in the specified subscription, resource group, and environment.
  ## 
  let valid = call_564305.validator(path, query, header, formData, body)
  let scheme = call_564305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564305.url(scheme.get, call_564305.host, call_564305.base,
                         call_564305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564305, url, valid)

proc call*(call_564306: Call_EventSourcesUpdate_564296; apiVersion: string;
          environmentName: string; subscriptionId: string;
          eventSourceUpdateParameters: JsonNode; resourceGroupName: string;
          eventSourceName: string): Recallable =
  ## eventSourcesUpdate
  ## Updates the event source with the specified name in the specified subscription, resource group, and environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
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
  var path_564307 = newJObject()
  var query_564308 = newJObject()
  var body_564309 = newJObject()
  add(query_564308, "api-version", newJString(apiVersion))
  add(path_564307, "environmentName", newJString(environmentName))
  add(path_564307, "subscriptionId", newJString(subscriptionId))
  if eventSourceUpdateParameters != nil:
    body_564309 = eventSourceUpdateParameters
  add(path_564307, "resourceGroupName", newJString(resourceGroupName))
  add(path_564307, "eventSourceName", newJString(eventSourceName))
  result = call_564306.call(path_564307, query_564308, nil, nil, body_564309)

var eventSourcesUpdate* = Call_EventSourcesUpdate_564296(
    name: "eventSourcesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesUpdate_564297, base: "",
    url: url_EventSourcesUpdate_564298, schemes: {Scheme.Https})
type
  Call_EventSourcesDelete_564284 = ref object of OpenApiRestCall_563564
proc url_EventSourcesDelete_564286(protocol: Scheme; host: string; base: string;
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

proc validate_EventSourcesDelete_564285(path: JsonNode; query: JsonNode;
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
  var valid_564287 = path.getOrDefault("environmentName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "environmentName", valid_564287
  var valid_564288 = path.getOrDefault("subscriptionId")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "subscriptionId", valid_564288
  var valid_564289 = path.getOrDefault("resourceGroupName")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "resourceGroupName", valid_564289
  var valid_564290 = path.getOrDefault("eventSourceName")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "eventSourceName", valid_564290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564291 = query.getOrDefault("api-version")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "api-version", valid_564291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564292: Call_EventSourcesDelete_564284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the event source with the specified name in the specified subscription, resource group, and environment
  ## 
  let valid = call_564292.validator(path, query, header, formData, body)
  let scheme = call_564292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564292.url(scheme.get, call_564292.host, call_564292.base,
                         call_564292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564292, url, valid)

proc call*(call_564293: Call_EventSourcesDelete_564284; apiVersion: string;
          environmentName: string; subscriptionId: string;
          resourceGroupName: string; eventSourceName: string): Recallable =
  ## eventSourcesDelete
  ## Deletes the event source with the specified name in the specified subscription, resource group, and environment
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   eventSourceName: string (required)
  ##                  : The name of the Time Series Insights event source associated with the specified environment.
  var path_564294 = newJObject()
  var query_564295 = newJObject()
  add(query_564295, "api-version", newJString(apiVersion))
  add(path_564294, "environmentName", newJString(environmentName))
  add(path_564294, "subscriptionId", newJString(subscriptionId))
  add(path_564294, "resourceGroupName", newJString(resourceGroupName))
  add(path_564294, "eventSourceName", newJString(eventSourceName))
  result = call_564293.call(path_564294, query_564295, nil, nil, nil)

var eventSourcesDelete* = Call_EventSourcesDelete_564284(
    name: "eventSourcesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesDelete_564285, base: "",
    url: url_EventSourcesDelete_564286, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsListByEnvironment_564310 = ref object of OpenApiRestCall_563564
proc url_ReferenceDataSetsListByEnvironment_564312(protocol: Scheme; host: string;
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

proc validate_ReferenceDataSetsListByEnvironment_564311(path: JsonNode;
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
  var valid_564313 = path.getOrDefault("environmentName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "environmentName", valid_564313
  var valid_564314 = path.getOrDefault("subscriptionId")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "subscriptionId", valid_564314
  var valid_564315 = path.getOrDefault("resourceGroupName")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "resourceGroupName", valid_564315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564316 = query.getOrDefault("api-version")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "api-version", valid_564316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564317: Call_ReferenceDataSetsListByEnvironment_564310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the available reference data sets associated with the subscription and within the specified resource group and environment.
  ## 
  let valid = call_564317.validator(path, query, header, formData, body)
  let scheme = call_564317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564317.url(scheme.get, call_564317.host, call_564317.base,
                         call_564317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564317, url, valid)

proc call*(call_564318: Call_ReferenceDataSetsListByEnvironment_564310;
          apiVersion: string; environmentName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## referenceDataSetsListByEnvironment
  ## Lists all the available reference data sets associated with the subscription and within the specified resource group and environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564319 = newJObject()
  var query_564320 = newJObject()
  add(query_564320, "api-version", newJString(apiVersion))
  add(path_564319, "environmentName", newJString(environmentName))
  add(path_564319, "subscriptionId", newJString(subscriptionId))
  add(path_564319, "resourceGroupName", newJString(resourceGroupName))
  result = call_564318.call(path_564319, query_564320, nil, nil, nil)

var referenceDataSetsListByEnvironment* = Call_ReferenceDataSetsListByEnvironment_564310(
    name: "referenceDataSetsListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets",
    validator: validate_ReferenceDataSetsListByEnvironment_564311, base: "",
    url: url_ReferenceDataSetsListByEnvironment_564312, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsCreateOrUpdate_564333 = ref object of OpenApiRestCall_563564
proc url_ReferenceDataSetsCreateOrUpdate_564335(protocol: Scheme; host: string;
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

proc validate_ReferenceDataSetsCreateOrUpdate_564334(path: JsonNode;
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
  var valid_564336 = path.getOrDefault("environmentName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "environmentName", valid_564336
  var valid_564337 = path.getOrDefault("referenceDataSetName")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "referenceDataSetName", valid_564337
  var valid_564338 = path.getOrDefault("subscriptionId")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "subscriptionId", valid_564338
  var valid_564339 = path.getOrDefault("resourceGroupName")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "resourceGroupName", valid_564339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564340 = query.getOrDefault("api-version")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "api-version", valid_564340
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

proc call*(call_564342: Call_ReferenceDataSetsCreateOrUpdate_564333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a reference data set in the specified environment.
  ## 
  let valid = call_564342.validator(path, query, header, formData, body)
  let scheme = call_564342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564342.url(scheme.get, call_564342.host, call_564342.base,
                         call_564342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564342, url, valid)

proc call*(call_564343: Call_ReferenceDataSetsCreateOrUpdate_564333;
          apiVersion: string; environmentName: string; referenceDataSetName: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## referenceDataSetsCreateOrUpdate
  ## Create or update a reference data set in the specified environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
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
  var path_564344 = newJObject()
  var query_564345 = newJObject()
  var body_564346 = newJObject()
  add(query_564345, "api-version", newJString(apiVersion))
  add(path_564344, "environmentName", newJString(environmentName))
  add(path_564344, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_564344, "subscriptionId", newJString(subscriptionId))
  add(path_564344, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564346 = parameters
  result = call_564343.call(path_564344, query_564345, nil, nil, body_564346)

var referenceDataSetsCreateOrUpdate* = Call_ReferenceDataSetsCreateOrUpdate_564333(
    name: "referenceDataSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsCreateOrUpdate_564334, base: "",
    url: url_ReferenceDataSetsCreateOrUpdate_564335, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsGet_564321 = ref object of OpenApiRestCall_563564
proc url_ReferenceDataSetsGet_564323(protocol: Scheme; host: string; base: string;
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

proc validate_ReferenceDataSetsGet_564322(path: JsonNode; query: JsonNode;
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
  var valid_564324 = path.getOrDefault("environmentName")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "environmentName", valid_564324
  var valid_564325 = path.getOrDefault("referenceDataSetName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "referenceDataSetName", valid_564325
  var valid_564326 = path.getOrDefault("subscriptionId")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "subscriptionId", valid_564326
  var valid_564327 = path.getOrDefault("resourceGroupName")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "resourceGroupName", valid_564327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564328 = query.getOrDefault("api-version")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "api-version", valid_564328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564329: Call_ReferenceDataSetsGet_564321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the reference data set with the specified name in the specified environment.
  ## 
  let valid = call_564329.validator(path, query, header, formData, body)
  let scheme = call_564329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564329.url(scheme.get, call_564329.host, call_564329.base,
                         call_564329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564329, url, valid)

proc call*(call_564330: Call_ReferenceDataSetsGet_564321; apiVersion: string;
          environmentName: string; referenceDataSetName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## referenceDataSetsGet
  ## Gets the reference data set with the specified name in the specified environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   referenceDataSetName: string (required)
  ##                       : The name of the Time Series Insights reference data set associated with the specified environment.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564331 = newJObject()
  var query_564332 = newJObject()
  add(query_564332, "api-version", newJString(apiVersion))
  add(path_564331, "environmentName", newJString(environmentName))
  add(path_564331, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_564331, "subscriptionId", newJString(subscriptionId))
  add(path_564331, "resourceGroupName", newJString(resourceGroupName))
  result = call_564330.call(path_564331, query_564332, nil, nil, nil)

var referenceDataSetsGet* = Call_ReferenceDataSetsGet_564321(
    name: "referenceDataSetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsGet_564322, base: "",
    url: url_ReferenceDataSetsGet_564323, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsUpdate_564359 = ref object of OpenApiRestCall_563564
proc url_ReferenceDataSetsUpdate_564361(protocol: Scheme; host: string; base: string;
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

proc validate_ReferenceDataSetsUpdate_564360(path: JsonNode; query: JsonNode;
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
  var valid_564362 = path.getOrDefault("environmentName")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "environmentName", valid_564362
  var valid_564363 = path.getOrDefault("referenceDataSetName")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "referenceDataSetName", valid_564363
  var valid_564364 = path.getOrDefault("subscriptionId")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "subscriptionId", valid_564364
  var valid_564365 = path.getOrDefault("resourceGroupName")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "resourceGroupName", valid_564365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564366 = query.getOrDefault("api-version")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = nil)
  if valid_564366 != nil:
    section.add "api-version", valid_564366
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

proc call*(call_564368: Call_ReferenceDataSetsUpdate_564359; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the reference data set with the specified name in the specified subscription, resource group, and environment.
  ## 
  let valid = call_564368.validator(path, query, header, formData, body)
  let scheme = call_564368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564368.url(scheme.get, call_564368.host, call_564368.base,
                         call_564368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564368, url, valid)

proc call*(call_564369: Call_ReferenceDataSetsUpdate_564359; apiVersion: string;
          referenceDataSetUpdateParameters: JsonNode; environmentName: string;
          referenceDataSetName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## referenceDataSetsUpdate
  ## Updates the reference data set with the specified name in the specified subscription, resource group, and environment.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
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
  var path_564370 = newJObject()
  var query_564371 = newJObject()
  var body_564372 = newJObject()
  add(query_564371, "api-version", newJString(apiVersion))
  if referenceDataSetUpdateParameters != nil:
    body_564372 = referenceDataSetUpdateParameters
  add(path_564370, "environmentName", newJString(environmentName))
  add(path_564370, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_564370, "subscriptionId", newJString(subscriptionId))
  add(path_564370, "resourceGroupName", newJString(resourceGroupName))
  result = call_564369.call(path_564370, query_564371, nil, nil, body_564372)

var referenceDataSetsUpdate* = Call_ReferenceDataSetsUpdate_564359(
    name: "referenceDataSetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsUpdate_564360, base: "",
    url: url_ReferenceDataSetsUpdate_564361, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsDelete_564347 = ref object of OpenApiRestCall_563564
proc url_ReferenceDataSetsDelete_564349(protocol: Scheme; host: string; base: string;
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

proc validate_ReferenceDataSetsDelete_564348(path: JsonNode; query: JsonNode;
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
  var valid_564350 = path.getOrDefault("environmentName")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "environmentName", valid_564350
  var valid_564351 = path.getOrDefault("referenceDataSetName")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "referenceDataSetName", valid_564351
  var valid_564352 = path.getOrDefault("subscriptionId")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "subscriptionId", valid_564352
  var valid_564353 = path.getOrDefault("resourceGroupName")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "resourceGroupName", valid_564353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564354 = query.getOrDefault("api-version")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "api-version", valid_564354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564355: Call_ReferenceDataSetsDelete_564347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the reference data set with the specified name in the specified subscription, resource group, and environment
  ## 
  let valid = call_564355.validator(path, query, header, formData, body)
  let scheme = call_564355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564355.url(scheme.get, call_564355.host, call_564355.base,
                         call_564355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564355, url, valid)

proc call*(call_564356: Call_ReferenceDataSetsDelete_564347; apiVersion: string;
          environmentName: string; referenceDataSetName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## referenceDataSetsDelete
  ## Deletes the reference data set with the specified name in the specified subscription, resource group, and environment
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   referenceDataSetName: string (required)
  ##                       : The name of the Time Series Insights reference data set associated with the specified environment.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  var path_564357 = newJObject()
  var query_564358 = newJObject()
  add(query_564358, "api-version", newJString(apiVersion))
  add(path_564357, "environmentName", newJString(environmentName))
  add(path_564357, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_564357, "subscriptionId", newJString(subscriptionId))
  add(path_564357, "resourceGroupName", newJString(resourceGroupName))
  result = call_564356.call(path_564357, query_564358, nil, nil, nil)

var referenceDataSetsDelete* = Call_ReferenceDataSetsDelete_564347(
    name: "referenceDataSetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsDelete_564348, base: "",
    url: url_ReferenceDataSetsDelete_564349, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
