
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567666): Option[Scheme] {.used.} =
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
  macServiceName = "timeseriesinsights"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567888 = ref object of OpenApiRestCall_567666
proc url_OperationsList_567890(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567889(path: JsonNode; query: JsonNode;
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
  var valid_568049 = query.getOrDefault("api-version")
  valid_568049 = validateParameter(valid_568049, JString, required = true,
                                 default = nil)
  if valid_568049 != nil:
    section.add "api-version", valid_568049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568072: Call_OperationsList_567888; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Time Series Insights related operations.
  ## 
  let valid = call_568072.validator(path, query, header, formData, body)
  let scheme = call_568072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568072.url(scheme.get, call_568072.host, call_568072.base,
                         call_568072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568072, url, valid)

proc call*(call_568143: Call_OperationsList_567888; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Time Series Insights related operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  var query_568144 = newJObject()
  add(query_568144, "api-version", newJString(apiVersion))
  result = call_568143.call(nil, query_568144, nil, nil, nil)

var operationsList* = Call_OperationsList_567888(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.TimeSeriesInsights/operations",
    validator: validate_OperationsList_567889, base: "", url: url_OperationsList_567890,
    schemes: {Scheme.Https})
type
  Call_EnvironmentsListBySubscription_568184 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsListBySubscription_568186(protocol: Scheme; host: string;
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

proc validate_EnvironmentsListBySubscription_568185(path: JsonNode;
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
  var valid_568201 = path.getOrDefault("subscriptionId")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "subscriptionId", valid_568201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568202 = query.getOrDefault("api-version")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "api-version", valid_568202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568203: Call_EnvironmentsListBySubscription_568184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available environments within a subscription, irrespective of the resource groups.
  ## 
  let valid = call_568203.validator(path, query, header, formData, body)
  let scheme = call_568203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568203.url(scheme.get, call_568203.host, call_568203.base,
                         call_568203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568203, url, valid)

proc call*(call_568204: Call_EnvironmentsListBySubscription_568184;
          apiVersion: string; subscriptionId: string): Recallable =
  ## environmentsListBySubscription
  ## Lists all the available environments within a subscription, irrespective of the resource groups.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_568205 = newJObject()
  var query_568206 = newJObject()
  add(query_568206, "api-version", newJString(apiVersion))
  add(path_568205, "subscriptionId", newJString(subscriptionId))
  result = call_568204.call(path_568205, query_568206, nil, nil, nil)

var environmentsListBySubscription* = Call_EnvironmentsListBySubscription_568184(
    name: "environmentsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.TimeSeriesInsights/environments",
    validator: validate_EnvironmentsListBySubscription_568185, base: "",
    url: url_EnvironmentsListBySubscription_568186, schemes: {Scheme.Https})
type
  Call_EnvironmentsListByResourceGroup_568207 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsListByResourceGroup_568209(protocol: Scheme; host: string;
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

proc validate_EnvironmentsListByResourceGroup_568208(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available environments associated with the subscription and within the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568210 = path.getOrDefault("resourceGroupName")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "resourceGroupName", valid_568210
  var valid_568211 = path.getOrDefault("subscriptionId")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "subscriptionId", valid_568211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568212 = query.getOrDefault("api-version")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "api-version", valid_568212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568213: Call_EnvironmentsListByResourceGroup_568207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the available environments associated with the subscription and within the specified resource group.
  ## 
  let valid = call_568213.validator(path, query, header, formData, body)
  let scheme = call_568213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568213.url(scheme.get, call_568213.host, call_568213.base,
                         call_568213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568213, url, valid)

proc call*(call_568214: Call_EnvironmentsListByResourceGroup_568207;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## environmentsListByResourceGroup
  ## Lists all the available environments associated with the subscription and within the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_568215 = newJObject()
  var query_568216 = newJObject()
  add(path_568215, "resourceGroupName", newJString(resourceGroupName))
  add(query_568216, "api-version", newJString(apiVersion))
  add(path_568215, "subscriptionId", newJString(subscriptionId))
  result = call_568214.call(path_568215, query_568216, nil, nil, nil)

var environmentsListByResourceGroup* = Call_EnvironmentsListByResourceGroup_568207(
    name: "environmentsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments",
    validator: validate_EnvironmentsListByResourceGroup_568208, base: "",
    url: url_EnvironmentsListByResourceGroup_568209, schemes: {Scheme.Https})
type
  Call_EnvironmentsCreateOrUpdate_568228 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsCreateOrUpdate_568230(protocol: Scheme; host: string;
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

proc validate_EnvironmentsCreateOrUpdate_568229(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an environment in the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: JString (required)
  ##                  : Name of the environment
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568248 = path.getOrDefault("resourceGroupName")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "resourceGroupName", valid_568248
  var valid_568249 = path.getOrDefault("subscriptionId")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "subscriptionId", valid_568249
  var valid_568250 = path.getOrDefault("environmentName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "environmentName", valid_568250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568251 = query.getOrDefault("api-version")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "api-version", valid_568251
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

proc call*(call_568253: Call_EnvironmentsCreateOrUpdate_568228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an environment in the specified subscription and resource group.
  ## 
  let valid = call_568253.validator(path, query, header, formData, body)
  let scheme = call_568253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568253.url(scheme.get, call_568253.host, call_568253.base,
                         call_568253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568253, url, valid)

proc call*(call_568254: Call_EnvironmentsCreateOrUpdate_568228;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          environmentName: string; parameters: JsonNode): Recallable =
  ## environmentsCreateOrUpdate
  ## Create or update an environment in the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : Name of the environment
  ##   parameters: JObject (required)
  ##             : Parameters for creating an environment resource.
  var path_568255 = newJObject()
  var query_568256 = newJObject()
  var body_568257 = newJObject()
  add(path_568255, "resourceGroupName", newJString(resourceGroupName))
  add(query_568256, "api-version", newJString(apiVersion))
  add(path_568255, "subscriptionId", newJString(subscriptionId))
  add(path_568255, "environmentName", newJString(environmentName))
  if parameters != nil:
    body_568257 = parameters
  result = call_568254.call(path_568255, query_568256, nil, nil, body_568257)

var environmentsCreateOrUpdate* = Call_EnvironmentsCreateOrUpdate_568228(
    name: "environmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsCreateOrUpdate_568229, base: "",
    url: url_EnvironmentsCreateOrUpdate_568230, schemes: {Scheme.Https})
type
  Call_EnvironmentsGet_568217 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsGet_568219(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsGet_568218(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the environment with the specified name in the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568220 = path.getOrDefault("resourceGroupName")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "resourceGroupName", valid_568220
  var valid_568221 = path.getOrDefault("subscriptionId")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "subscriptionId", valid_568221
  var valid_568222 = path.getOrDefault("environmentName")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "environmentName", valid_568222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568223 = query.getOrDefault("api-version")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "api-version", valid_568223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568224: Call_EnvironmentsGet_568217; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the environment with the specified name in the specified subscription and resource group.
  ## 
  let valid = call_568224.validator(path, query, header, formData, body)
  let scheme = call_568224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568224.url(scheme.get, call_568224.host, call_568224.base,
                         call_568224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568224, url, valid)

proc call*(call_568225: Call_EnvironmentsGet_568217; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; environmentName: string): Recallable =
  ## environmentsGet
  ## Gets the environment with the specified name in the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568226 = newJObject()
  var query_568227 = newJObject()
  add(path_568226, "resourceGroupName", newJString(resourceGroupName))
  add(query_568227, "api-version", newJString(apiVersion))
  add(path_568226, "subscriptionId", newJString(subscriptionId))
  add(path_568226, "environmentName", newJString(environmentName))
  result = call_568225.call(path_568226, query_568227, nil, nil, nil)

var environmentsGet* = Call_EnvironmentsGet_568217(name: "environmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsGet_568218, base: "", url: url_EnvironmentsGet_568219,
    schemes: {Scheme.Https})
type
  Call_EnvironmentsUpdate_568269 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsUpdate_568271(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsUpdate_568270(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the environment with the specified name in the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568272 = path.getOrDefault("resourceGroupName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "resourceGroupName", valid_568272
  var valid_568273 = path.getOrDefault("subscriptionId")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "subscriptionId", valid_568273
  var valid_568274 = path.getOrDefault("environmentName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "environmentName", valid_568274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568275 = query.getOrDefault("api-version")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "api-version", valid_568275
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

proc call*(call_568277: Call_EnvironmentsUpdate_568269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the environment with the specified name in the specified subscription and resource group.
  ## 
  let valid = call_568277.validator(path, query, header, formData, body)
  let scheme = call_568277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568277.url(scheme.get, call_568277.host, call_568277.base,
                         call_568277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568277, url, valid)

proc call*(call_568278: Call_EnvironmentsUpdate_568269; resourceGroupName: string;
          apiVersion: string; environmentUpdateParameters: JsonNode;
          subscriptionId: string; environmentName: string): Recallable =
  ## environmentsUpdate
  ## Updates the environment with the specified name in the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   environmentUpdateParameters: JObject (required)
  ##                              : Request object that contains the updated information for the environment.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568279 = newJObject()
  var query_568280 = newJObject()
  var body_568281 = newJObject()
  add(path_568279, "resourceGroupName", newJString(resourceGroupName))
  add(query_568280, "api-version", newJString(apiVersion))
  if environmentUpdateParameters != nil:
    body_568281 = environmentUpdateParameters
  add(path_568279, "subscriptionId", newJString(subscriptionId))
  add(path_568279, "environmentName", newJString(environmentName))
  result = call_568278.call(path_568279, query_568280, nil, nil, body_568281)

var environmentsUpdate* = Call_EnvironmentsUpdate_568269(
    name: "environmentsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsUpdate_568270, base: "",
    url: url_EnvironmentsUpdate_568271, schemes: {Scheme.Https})
type
  Call_EnvironmentsDelete_568258 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsDelete_568260(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsDelete_568259(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the environment with the specified name in the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568261 = path.getOrDefault("resourceGroupName")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "resourceGroupName", valid_568261
  var valid_568262 = path.getOrDefault("subscriptionId")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "subscriptionId", valid_568262
  var valid_568263 = path.getOrDefault("environmentName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "environmentName", valid_568263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568264 = query.getOrDefault("api-version")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "api-version", valid_568264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568265: Call_EnvironmentsDelete_568258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the environment with the specified name in the specified subscription and resource group.
  ## 
  let valid = call_568265.validator(path, query, header, formData, body)
  let scheme = call_568265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568265.url(scheme.get, call_568265.host, call_568265.base,
                         call_568265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568265, url, valid)

proc call*(call_568266: Call_EnvironmentsDelete_568258; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; environmentName: string): Recallable =
  ## environmentsDelete
  ## Deletes the environment with the specified name in the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568267 = newJObject()
  var query_568268 = newJObject()
  add(path_568267, "resourceGroupName", newJString(resourceGroupName))
  add(query_568268, "api-version", newJString(apiVersion))
  add(path_568267, "subscriptionId", newJString(subscriptionId))
  add(path_568267, "environmentName", newJString(environmentName))
  result = call_568266.call(path_568267, query_568268, nil, nil, nil)

var environmentsDelete* = Call_EnvironmentsDelete_568258(
    name: "environmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsDelete_568259, base: "",
    url: url_EnvironmentsDelete_568260, schemes: {Scheme.Https})
type
  Call_AccessPoliciesListByEnvironment_568282 = ref object of OpenApiRestCall_567666
proc url_AccessPoliciesListByEnvironment_568284(protocol: Scheme; host: string;
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

proc validate_AccessPoliciesListByEnvironment_568283(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available access policies associated with the environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568285 = path.getOrDefault("resourceGroupName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "resourceGroupName", valid_568285
  var valid_568286 = path.getOrDefault("subscriptionId")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "subscriptionId", valid_568286
  var valid_568287 = path.getOrDefault("environmentName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "environmentName", valid_568287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568288 = query.getOrDefault("api-version")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "api-version", valid_568288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568289: Call_AccessPoliciesListByEnvironment_568282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the available access policies associated with the environment.
  ## 
  let valid = call_568289.validator(path, query, header, formData, body)
  let scheme = call_568289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568289.url(scheme.get, call_568289.host, call_568289.base,
                         call_568289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568289, url, valid)

proc call*(call_568290: Call_AccessPoliciesListByEnvironment_568282;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          environmentName: string): Recallable =
  ## accessPoliciesListByEnvironment
  ## Lists all the available access policies associated with the environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568291 = newJObject()
  var query_568292 = newJObject()
  add(path_568291, "resourceGroupName", newJString(resourceGroupName))
  add(query_568292, "api-version", newJString(apiVersion))
  add(path_568291, "subscriptionId", newJString(subscriptionId))
  add(path_568291, "environmentName", newJString(environmentName))
  result = call_568290.call(path_568291, query_568292, nil, nil, nil)

var accessPoliciesListByEnvironment* = Call_AccessPoliciesListByEnvironment_568282(
    name: "accessPoliciesListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies",
    validator: validate_AccessPoliciesListByEnvironment_568283, base: "",
    url: url_AccessPoliciesListByEnvironment_568284, schemes: {Scheme.Https})
type
  Call_AccessPoliciesCreateOrUpdate_568305 = ref object of OpenApiRestCall_567666
proc url_AccessPoliciesCreateOrUpdate_568307(protocol: Scheme; host: string;
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

proc validate_AccessPoliciesCreateOrUpdate_568306(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an access policy in the specified environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   accessPolicyName: JString (required)
  ##                   : Name of the access policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568308 = path.getOrDefault("resourceGroupName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "resourceGroupName", valid_568308
  var valid_568309 = path.getOrDefault("subscriptionId")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "subscriptionId", valid_568309
  var valid_568310 = path.getOrDefault("environmentName")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "environmentName", valid_568310
  var valid_568311 = path.getOrDefault("accessPolicyName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "accessPolicyName", valid_568311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568312 = query.getOrDefault("api-version")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "api-version", valid_568312
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

proc call*(call_568314: Call_AccessPoliciesCreateOrUpdate_568305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an access policy in the specified environment.
  ## 
  let valid = call_568314.validator(path, query, header, formData, body)
  let scheme = call_568314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568314.url(scheme.get, call_568314.host, call_568314.base,
                         call_568314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568314, url, valid)

proc call*(call_568315: Call_AccessPoliciesCreateOrUpdate_568305;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          environmentName: string; parameters: JsonNode; accessPolicyName: string): Recallable =
  ## accessPoliciesCreateOrUpdate
  ## Create or update an access policy in the specified environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   parameters: JObject (required)
  ##             : Parameters for creating an access policy.
  ##   accessPolicyName: string (required)
  ##                   : Name of the access policy.
  var path_568316 = newJObject()
  var query_568317 = newJObject()
  var body_568318 = newJObject()
  add(path_568316, "resourceGroupName", newJString(resourceGroupName))
  add(query_568317, "api-version", newJString(apiVersion))
  add(path_568316, "subscriptionId", newJString(subscriptionId))
  add(path_568316, "environmentName", newJString(environmentName))
  if parameters != nil:
    body_568318 = parameters
  add(path_568316, "accessPolicyName", newJString(accessPolicyName))
  result = call_568315.call(path_568316, query_568317, nil, nil, body_568318)

var accessPoliciesCreateOrUpdate* = Call_AccessPoliciesCreateOrUpdate_568305(
    name: "accessPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesCreateOrUpdate_568306, base: "",
    url: url_AccessPoliciesCreateOrUpdate_568307, schemes: {Scheme.Https})
type
  Call_AccessPoliciesGet_568293 = ref object of OpenApiRestCall_567666
proc url_AccessPoliciesGet_568295(protocol: Scheme; host: string; base: string;
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

proc validate_AccessPoliciesGet_568294(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the access policy with the specified name in the specified environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   accessPolicyName: JString (required)
  ##                   : The name of the Time Series Insights access policy associated with the specified environment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568296 = path.getOrDefault("resourceGroupName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "resourceGroupName", valid_568296
  var valid_568297 = path.getOrDefault("subscriptionId")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "subscriptionId", valid_568297
  var valid_568298 = path.getOrDefault("environmentName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "environmentName", valid_568298
  var valid_568299 = path.getOrDefault("accessPolicyName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "accessPolicyName", valid_568299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568300 = query.getOrDefault("api-version")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "api-version", valid_568300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568301: Call_AccessPoliciesGet_568293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access policy with the specified name in the specified environment.
  ## 
  let valid = call_568301.validator(path, query, header, formData, body)
  let scheme = call_568301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568301.url(scheme.get, call_568301.host, call_568301.base,
                         call_568301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568301, url, valid)

proc call*(call_568302: Call_AccessPoliciesGet_568293; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; environmentName: string;
          accessPolicyName: string): Recallable =
  ## accessPoliciesGet
  ## Gets the access policy with the specified name in the specified environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   accessPolicyName: string (required)
  ##                   : The name of the Time Series Insights access policy associated with the specified environment.
  var path_568303 = newJObject()
  var query_568304 = newJObject()
  add(path_568303, "resourceGroupName", newJString(resourceGroupName))
  add(query_568304, "api-version", newJString(apiVersion))
  add(path_568303, "subscriptionId", newJString(subscriptionId))
  add(path_568303, "environmentName", newJString(environmentName))
  add(path_568303, "accessPolicyName", newJString(accessPolicyName))
  result = call_568302.call(path_568303, query_568304, nil, nil, nil)

var accessPoliciesGet* = Call_AccessPoliciesGet_568293(name: "accessPoliciesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesGet_568294, base: "",
    url: url_AccessPoliciesGet_568295, schemes: {Scheme.Https})
type
  Call_AccessPoliciesUpdate_568331 = ref object of OpenApiRestCall_567666
proc url_AccessPoliciesUpdate_568333(protocol: Scheme; host: string; base: string;
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

proc validate_AccessPoliciesUpdate_568332(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the access policy with the specified name in the specified subscription, resource group, and environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   accessPolicyName: JString (required)
  ##                   : The name of the Time Series Insights access policy associated with the specified environment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568334 = path.getOrDefault("resourceGroupName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "resourceGroupName", valid_568334
  var valid_568335 = path.getOrDefault("subscriptionId")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "subscriptionId", valid_568335
  var valid_568336 = path.getOrDefault("environmentName")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "environmentName", valid_568336
  var valid_568337 = path.getOrDefault("accessPolicyName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "accessPolicyName", valid_568337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568338 = query.getOrDefault("api-version")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "api-version", valid_568338
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

proc call*(call_568340: Call_AccessPoliciesUpdate_568331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the access policy with the specified name in the specified subscription, resource group, and environment.
  ## 
  let valid = call_568340.validator(path, query, header, formData, body)
  let scheme = call_568340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568340.url(scheme.get, call_568340.host, call_568340.base,
                         call_568340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568340, url, valid)

proc call*(call_568341: Call_AccessPoliciesUpdate_568331;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accessPolicyUpdateParameters: JsonNode; environmentName: string;
          accessPolicyName: string): Recallable =
  ## accessPoliciesUpdate
  ## Updates the access policy with the specified name in the specified subscription, resource group, and environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   accessPolicyUpdateParameters: JObject (required)
  ##                               : Request object that contains the updated information for the access policy.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   accessPolicyName: string (required)
  ##                   : The name of the Time Series Insights access policy associated with the specified environment.
  var path_568342 = newJObject()
  var query_568343 = newJObject()
  var body_568344 = newJObject()
  add(path_568342, "resourceGroupName", newJString(resourceGroupName))
  add(query_568343, "api-version", newJString(apiVersion))
  add(path_568342, "subscriptionId", newJString(subscriptionId))
  if accessPolicyUpdateParameters != nil:
    body_568344 = accessPolicyUpdateParameters
  add(path_568342, "environmentName", newJString(environmentName))
  add(path_568342, "accessPolicyName", newJString(accessPolicyName))
  result = call_568341.call(path_568342, query_568343, nil, nil, body_568344)

var accessPoliciesUpdate* = Call_AccessPoliciesUpdate_568331(
    name: "accessPoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesUpdate_568332, base: "",
    url: url_AccessPoliciesUpdate_568333, schemes: {Scheme.Https})
type
  Call_AccessPoliciesDelete_568319 = ref object of OpenApiRestCall_567666
proc url_AccessPoliciesDelete_568321(protocol: Scheme; host: string; base: string;
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

proc validate_AccessPoliciesDelete_568320(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the access policy with the specified name in the specified subscription, resource group, and environment
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   accessPolicyName: JString (required)
  ##                   : The name of the Time Series Insights access policy associated with the specified environment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568322 = path.getOrDefault("resourceGroupName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "resourceGroupName", valid_568322
  var valid_568323 = path.getOrDefault("subscriptionId")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "subscriptionId", valid_568323
  var valid_568324 = path.getOrDefault("environmentName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "environmentName", valid_568324
  var valid_568325 = path.getOrDefault("accessPolicyName")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "accessPolicyName", valid_568325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568326 = query.getOrDefault("api-version")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "api-version", valid_568326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568327: Call_AccessPoliciesDelete_568319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the access policy with the specified name in the specified subscription, resource group, and environment
  ## 
  let valid = call_568327.validator(path, query, header, formData, body)
  let scheme = call_568327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568327.url(scheme.get, call_568327.host, call_568327.base,
                         call_568327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568327, url, valid)

proc call*(call_568328: Call_AccessPoliciesDelete_568319;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          environmentName: string; accessPolicyName: string): Recallable =
  ## accessPoliciesDelete
  ## Deletes the access policy with the specified name in the specified subscription, resource group, and environment
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   accessPolicyName: string (required)
  ##                   : The name of the Time Series Insights access policy associated with the specified environment.
  var path_568329 = newJObject()
  var query_568330 = newJObject()
  add(path_568329, "resourceGroupName", newJString(resourceGroupName))
  add(query_568330, "api-version", newJString(apiVersion))
  add(path_568329, "subscriptionId", newJString(subscriptionId))
  add(path_568329, "environmentName", newJString(environmentName))
  add(path_568329, "accessPolicyName", newJString(accessPolicyName))
  result = call_568328.call(path_568329, query_568330, nil, nil, nil)

var accessPoliciesDelete* = Call_AccessPoliciesDelete_568319(
    name: "accessPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesDelete_568320, base: "",
    url: url_AccessPoliciesDelete_568321, schemes: {Scheme.Https})
type
  Call_EventSourcesListByEnvironment_568345 = ref object of OpenApiRestCall_567666
proc url_EventSourcesListByEnvironment_568347(protocol: Scheme; host: string;
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

proc validate_EventSourcesListByEnvironment_568346(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available event sources associated with the subscription and within the specified resource group and environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568348 = path.getOrDefault("resourceGroupName")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "resourceGroupName", valid_568348
  var valid_568349 = path.getOrDefault("subscriptionId")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "subscriptionId", valid_568349
  var valid_568350 = path.getOrDefault("environmentName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "environmentName", valid_568350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568351 = query.getOrDefault("api-version")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "api-version", valid_568351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568352: Call_EventSourcesListByEnvironment_568345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available event sources associated with the subscription and within the specified resource group and environment.
  ## 
  let valid = call_568352.validator(path, query, header, formData, body)
  let scheme = call_568352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568352.url(scheme.get, call_568352.host, call_568352.base,
                         call_568352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568352, url, valid)

proc call*(call_568353: Call_EventSourcesListByEnvironment_568345;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          environmentName: string): Recallable =
  ## eventSourcesListByEnvironment
  ## Lists all the available event sources associated with the subscription and within the specified resource group and environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568354 = newJObject()
  var query_568355 = newJObject()
  add(path_568354, "resourceGroupName", newJString(resourceGroupName))
  add(query_568355, "api-version", newJString(apiVersion))
  add(path_568354, "subscriptionId", newJString(subscriptionId))
  add(path_568354, "environmentName", newJString(environmentName))
  result = call_568353.call(path_568354, query_568355, nil, nil, nil)

var eventSourcesListByEnvironment* = Call_EventSourcesListByEnvironment_568345(
    name: "eventSourcesListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources",
    validator: validate_EventSourcesListByEnvironment_568346, base: "",
    url: url_EventSourcesListByEnvironment_568347, schemes: {Scheme.Https})
type
  Call_EventSourcesCreateOrUpdate_568368 = ref object of OpenApiRestCall_567666
proc url_EventSourcesCreateOrUpdate_568370(protocol: Scheme; host: string;
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

proc validate_EventSourcesCreateOrUpdate_568369(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an event source under the specified environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   eventSourceName: JString (required)
  ##                  : Name of the event source.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568371 = path.getOrDefault("resourceGroupName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "resourceGroupName", valid_568371
  var valid_568372 = path.getOrDefault("eventSourceName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "eventSourceName", valid_568372
  var valid_568373 = path.getOrDefault("subscriptionId")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "subscriptionId", valid_568373
  var valid_568374 = path.getOrDefault("environmentName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "environmentName", valid_568374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568375 = query.getOrDefault("api-version")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "api-version", valid_568375
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

proc call*(call_568377: Call_EventSourcesCreateOrUpdate_568368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an event source under the specified environment.
  ## 
  let valid = call_568377.validator(path, query, header, formData, body)
  let scheme = call_568377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568377.url(scheme.get, call_568377.host, call_568377.base,
                         call_568377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568377, url, valid)

proc call*(call_568378: Call_EventSourcesCreateOrUpdate_568368;
          resourceGroupName: string; apiVersion: string; eventSourceName: string;
          subscriptionId: string; environmentName: string; parameters: JsonNode): Recallable =
  ## eventSourcesCreateOrUpdate
  ## Create or update an event source under the specified environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   eventSourceName: string (required)
  ##                  : Name of the event source.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   parameters: JObject (required)
  ##             : Parameters for creating an event source resource.
  var path_568379 = newJObject()
  var query_568380 = newJObject()
  var body_568381 = newJObject()
  add(path_568379, "resourceGroupName", newJString(resourceGroupName))
  add(query_568380, "api-version", newJString(apiVersion))
  add(path_568379, "eventSourceName", newJString(eventSourceName))
  add(path_568379, "subscriptionId", newJString(subscriptionId))
  add(path_568379, "environmentName", newJString(environmentName))
  if parameters != nil:
    body_568381 = parameters
  result = call_568378.call(path_568379, query_568380, nil, nil, body_568381)

var eventSourcesCreateOrUpdate* = Call_EventSourcesCreateOrUpdate_568368(
    name: "eventSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesCreateOrUpdate_568369, base: "",
    url: url_EventSourcesCreateOrUpdate_568370, schemes: {Scheme.Https})
type
  Call_EventSourcesGet_568356 = ref object of OpenApiRestCall_567666
proc url_EventSourcesGet_568358(protocol: Scheme; host: string; base: string;
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

proc validate_EventSourcesGet_568357(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the event source with the specified name in the specified environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   eventSourceName: JString (required)
  ##                  : The name of the Time Series Insights event source associated with the specified environment.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568359 = path.getOrDefault("resourceGroupName")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "resourceGroupName", valid_568359
  var valid_568360 = path.getOrDefault("eventSourceName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "eventSourceName", valid_568360
  var valid_568361 = path.getOrDefault("subscriptionId")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "subscriptionId", valid_568361
  var valid_568362 = path.getOrDefault("environmentName")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "environmentName", valid_568362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568363 = query.getOrDefault("api-version")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "api-version", valid_568363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568364: Call_EventSourcesGet_568356; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the event source with the specified name in the specified environment.
  ## 
  let valid = call_568364.validator(path, query, header, formData, body)
  let scheme = call_568364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568364.url(scheme.get, call_568364.host, call_568364.base,
                         call_568364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568364, url, valid)

proc call*(call_568365: Call_EventSourcesGet_568356; resourceGroupName: string;
          apiVersion: string; eventSourceName: string; subscriptionId: string;
          environmentName: string): Recallable =
  ## eventSourcesGet
  ## Gets the event source with the specified name in the specified environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   eventSourceName: string (required)
  ##                  : The name of the Time Series Insights event source associated with the specified environment.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568366 = newJObject()
  var query_568367 = newJObject()
  add(path_568366, "resourceGroupName", newJString(resourceGroupName))
  add(query_568367, "api-version", newJString(apiVersion))
  add(path_568366, "eventSourceName", newJString(eventSourceName))
  add(path_568366, "subscriptionId", newJString(subscriptionId))
  add(path_568366, "environmentName", newJString(environmentName))
  result = call_568365.call(path_568366, query_568367, nil, nil, nil)

var eventSourcesGet* = Call_EventSourcesGet_568356(name: "eventSourcesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesGet_568357, base: "", url: url_EventSourcesGet_568358,
    schemes: {Scheme.Https})
type
  Call_EventSourcesUpdate_568394 = ref object of OpenApiRestCall_567666
proc url_EventSourcesUpdate_568396(protocol: Scheme; host: string; base: string;
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

proc validate_EventSourcesUpdate_568395(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the event source with the specified name in the specified subscription, resource group, and environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   eventSourceName: JString (required)
  ##                  : The name of the Time Series Insights event source associated with the specified environment.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568397 = path.getOrDefault("resourceGroupName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "resourceGroupName", valid_568397
  var valid_568398 = path.getOrDefault("eventSourceName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "eventSourceName", valid_568398
  var valid_568399 = path.getOrDefault("subscriptionId")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "subscriptionId", valid_568399
  var valid_568400 = path.getOrDefault("environmentName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "environmentName", valid_568400
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568401 = query.getOrDefault("api-version")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "api-version", valid_568401
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

proc call*(call_568403: Call_EventSourcesUpdate_568394; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the event source with the specified name in the specified subscription, resource group, and environment.
  ## 
  let valid = call_568403.validator(path, query, header, formData, body)
  let scheme = call_568403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568403.url(scheme.get, call_568403.host, call_568403.base,
                         call_568403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568403, url, valid)

proc call*(call_568404: Call_EventSourcesUpdate_568394; resourceGroupName: string;
          apiVersion: string; eventSourceName: string; subscriptionId: string;
          eventSourceUpdateParameters: JsonNode; environmentName: string): Recallable =
  ## eventSourcesUpdate
  ## Updates the event source with the specified name in the specified subscription, resource group, and environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   eventSourceName: string (required)
  ##                  : The name of the Time Series Insights event source associated with the specified environment.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   eventSourceUpdateParameters: JObject (required)
  ##                              : Request object that contains the updated information for the event source.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568405 = newJObject()
  var query_568406 = newJObject()
  var body_568407 = newJObject()
  add(path_568405, "resourceGroupName", newJString(resourceGroupName))
  add(query_568406, "api-version", newJString(apiVersion))
  add(path_568405, "eventSourceName", newJString(eventSourceName))
  add(path_568405, "subscriptionId", newJString(subscriptionId))
  if eventSourceUpdateParameters != nil:
    body_568407 = eventSourceUpdateParameters
  add(path_568405, "environmentName", newJString(environmentName))
  result = call_568404.call(path_568405, query_568406, nil, nil, body_568407)

var eventSourcesUpdate* = Call_EventSourcesUpdate_568394(
    name: "eventSourcesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesUpdate_568395, base: "",
    url: url_EventSourcesUpdate_568396, schemes: {Scheme.Https})
type
  Call_EventSourcesDelete_568382 = ref object of OpenApiRestCall_567666
proc url_EventSourcesDelete_568384(protocol: Scheme; host: string; base: string;
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

proc validate_EventSourcesDelete_568383(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the event source with the specified name in the specified subscription, resource group, and environment
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   eventSourceName: JString (required)
  ##                  : The name of the Time Series Insights event source associated with the specified environment.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568385 = path.getOrDefault("resourceGroupName")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "resourceGroupName", valid_568385
  var valid_568386 = path.getOrDefault("eventSourceName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "eventSourceName", valid_568386
  var valid_568387 = path.getOrDefault("subscriptionId")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "subscriptionId", valid_568387
  var valid_568388 = path.getOrDefault("environmentName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "environmentName", valid_568388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568389 = query.getOrDefault("api-version")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "api-version", valid_568389
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568390: Call_EventSourcesDelete_568382; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the event source with the specified name in the specified subscription, resource group, and environment
  ## 
  let valid = call_568390.validator(path, query, header, formData, body)
  let scheme = call_568390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568390.url(scheme.get, call_568390.host, call_568390.base,
                         call_568390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568390, url, valid)

proc call*(call_568391: Call_EventSourcesDelete_568382; resourceGroupName: string;
          apiVersion: string; eventSourceName: string; subscriptionId: string;
          environmentName: string): Recallable =
  ## eventSourcesDelete
  ## Deletes the event source with the specified name in the specified subscription, resource group, and environment
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   eventSourceName: string (required)
  ##                  : The name of the Time Series Insights event source associated with the specified environment.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568392 = newJObject()
  var query_568393 = newJObject()
  add(path_568392, "resourceGroupName", newJString(resourceGroupName))
  add(query_568393, "api-version", newJString(apiVersion))
  add(path_568392, "eventSourceName", newJString(eventSourceName))
  add(path_568392, "subscriptionId", newJString(subscriptionId))
  add(path_568392, "environmentName", newJString(environmentName))
  result = call_568391.call(path_568392, query_568393, nil, nil, nil)

var eventSourcesDelete* = Call_EventSourcesDelete_568382(
    name: "eventSourcesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesDelete_568383, base: "",
    url: url_EventSourcesDelete_568384, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsListByEnvironment_568408 = ref object of OpenApiRestCall_567666
proc url_ReferenceDataSetsListByEnvironment_568410(protocol: Scheme; host: string;
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

proc validate_ReferenceDataSetsListByEnvironment_568409(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available reference data sets associated with the subscription and within the specified resource group and environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568411 = path.getOrDefault("resourceGroupName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "resourceGroupName", valid_568411
  var valid_568412 = path.getOrDefault("subscriptionId")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "subscriptionId", valid_568412
  var valid_568413 = path.getOrDefault("environmentName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "environmentName", valid_568413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568414 = query.getOrDefault("api-version")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "api-version", valid_568414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568415: Call_ReferenceDataSetsListByEnvironment_568408;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the available reference data sets associated with the subscription and within the specified resource group and environment.
  ## 
  let valid = call_568415.validator(path, query, header, formData, body)
  let scheme = call_568415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568415.url(scheme.get, call_568415.host, call_568415.base,
                         call_568415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568415, url, valid)

proc call*(call_568416: Call_ReferenceDataSetsListByEnvironment_568408;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          environmentName: string): Recallable =
  ## referenceDataSetsListByEnvironment
  ## Lists all the available reference data sets associated with the subscription and within the specified resource group and environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568417 = newJObject()
  var query_568418 = newJObject()
  add(path_568417, "resourceGroupName", newJString(resourceGroupName))
  add(query_568418, "api-version", newJString(apiVersion))
  add(path_568417, "subscriptionId", newJString(subscriptionId))
  add(path_568417, "environmentName", newJString(environmentName))
  result = call_568416.call(path_568417, query_568418, nil, nil, nil)

var referenceDataSetsListByEnvironment* = Call_ReferenceDataSetsListByEnvironment_568408(
    name: "referenceDataSetsListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets",
    validator: validate_ReferenceDataSetsListByEnvironment_568409, base: "",
    url: url_ReferenceDataSetsListByEnvironment_568410, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsCreateOrUpdate_568431 = ref object of OpenApiRestCall_567666
proc url_ReferenceDataSetsCreateOrUpdate_568433(protocol: Scheme; host: string;
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

proc validate_ReferenceDataSetsCreateOrUpdate_568432(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a reference data set in the specified environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   referenceDataSetName: JString (required)
  ##                       : Name of the reference data set.
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568434 = path.getOrDefault("resourceGroupName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "resourceGroupName", valid_568434
  var valid_568435 = path.getOrDefault("subscriptionId")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "subscriptionId", valid_568435
  var valid_568436 = path.getOrDefault("referenceDataSetName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "referenceDataSetName", valid_568436
  var valid_568437 = path.getOrDefault("environmentName")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "environmentName", valid_568437
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568438 = query.getOrDefault("api-version")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "api-version", valid_568438
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

proc call*(call_568440: Call_ReferenceDataSetsCreateOrUpdate_568431;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a reference data set in the specified environment.
  ## 
  let valid = call_568440.validator(path, query, header, formData, body)
  let scheme = call_568440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568440.url(scheme.get, call_568440.host, call_568440.base,
                         call_568440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568440, url, valid)

proc call*(call_568441: Call_ReferenceDataSetsCreateOrUpdate_568431;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          referenceDataSetName: string; environmentName: string;
          parameters: JsonNode): Recallable =
  ## referenceDataSetsCreateOrUpdate
  ## Create or update a reference data set in the specified environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   referenceDataSetName: string (required)
  ##                       : Name of the reference data set.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   parameters: JObject (required)
  ##             : Parameters for creating a reference data set.
  var path_568442 = newJObject()
  var query_568443 = newJObject()
  var body_568444 = newJObject()
  add(path_568442, "resourceGroupName", newJString(resourceGroupName))
  add(query_568443, "api-version", newJString(apiVersion))
  add(path_568442, "subscriptionId", newJString(subscriptionId))
  add(path_568442, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_568442, "environmentName", newJString(environmentName))
  if parameters != nil:
    body_568444 = parameters
  result = call_568441.call(path_568442, query_568443, nil, nil, body_568444)

var referenceDataSetsCreateOrUpdate* = Call_ReferenceDataSetsCreateOrUpdate_568431(
    name: "referenceDataSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsCreateOrUpdate_568432, base: "",
    url: url_ReferenceDataSetsCreateOrUpdate_568433, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsGet_568419 = ref object of OpenApiRestCall_567666
proc url_ReferenceDataSetsGet_568421(protocol: Scheme; host: string; base: string;
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

proc validate_ReferenceDataSetsGet_568420(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the reference data set with the specified name in the specified environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   referenceDataSetName: JString (required)
  ##                       : The name of the Time Series Insights reference data set associated with the specified environment.
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568422 = path.getOrDefault("resourceGroupName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "resourceGroupName", valid_568422
  var valid_568423 = path.getOrDefault("subscriptionId")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "subscriptionId", valid_568423
  var valid_568424 = path.getOrDefault("referenceDataSetName")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "referenceDataSetName", valid_568424
  var valid_568425 = path.getOrDefault("environmentName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "environmentName", valid_568425
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568426 = query.getOrDefault("api-version")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "api-version", valid_568426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568427: Call_ReferenceDataSetsGet_568419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the reference data set with the specified name in the specified environment.
  ## 
  let valid = call_568427.validator(path, query, header, formData, body)
  let scheme = call_568427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568427.url(scheme.get, call_568427.host, call_568427.base,
                         call_568427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568427, url, valid)

proc call*(call_568428: Call_ReferenceDataSetsGet_568419;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          referenceDataSetName: string; environmentName: string): Recallable =
  ## referenceDataSetsGet
  ## Gets the reference data set with the specified name in the specified environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   referenceDataSetName: string (required)
  ##                       : The name of the Time Series Insights reference data set associated with the specified environment.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568429 = newJObject()
  var query_568430 = newJObject()
  add(path_568429, "resourceGroupName", newJString(resourceGroupName))
  add(query_568430, "api-version", newJString(apiVersion))
  add(path_568429, "subscriptionId", newJString(subscriptionId))
  add(path_568429, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_568429, "environmentName", newJString(environmentName))
  result = call_568428.call(path_568429, query_568430, nil, nil, nil)

var referenceDataSetsGet* = Call_ReferenceDataSetsGet_568419(
    name: "referenceDataSetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsGet_568420, base: "",
    url: url_ReferenceDataSetsGet_568421, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsUpdate_568457 = ref object of OpenApiRestCall_567666
proc url_ReferenceDataSetsUpdate_568459(protocol: Scheme; host: string; base: string;
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

proc validate_ReferenceDataSetsUpdate_568458(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the reference data set with the specified name in the specified subscription, resource group, and environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   referenceDataSetName: JString (required)
  ##                       : The name of the Time Series Insights reference data set associated with the specified environment.
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568460 = path.getOrDefault("resourceGroupName")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "resourceGroupName", valid_568460
  var valid_568461 = path.getOrDefault("subscriptionId")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "subscriptionId", valid_568461
  var valid_568462 = path.getOrDefault("referenceDataSetName")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "referenceDataSetName", valid_568462
  var valid_568463 = path.getOrDefault("environmentName")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "environmentName", valid_568463
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568464 = query.getOrDefault("api-version")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "api-version", valid_568464
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

proc call*(call_568466: Call_ReferenceDataSetsUpdate_568457; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the reference data set with the specified name in the specified subscription, resource group, and environment.
  ## 
  let valid = call_568466.validator(path, query, header, formData, body)
  let scheme = call_568466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568466.url(scheme.get, call_568466.host, call_568466.base,
                         call_568466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568466, url, valid)

proc call*(call_568467: Call_ReferenceDataSetsUpdate_568457;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          referenceDataSetName: string; environmentName: string;
          referenceDataSetUpdateParameters: JsonNode): Recallable =
  ## referenceDataSetsUpdate
  ## Updates the reference data set with the specified name in the specified subscription, resource group, and environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   referenceDataSetName: string (required)
  ##                       : The name of the Time Series Insights reference data set associated with the specified environment.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   referenceDataSetUpdateParameters: JObject (required)
  ##                                   : Request object that contains the updated information for the reference data set.
  var path_568468 = newJObject()
  var query_568469 = newJObject()
  var body_568470 = newJObject()
  add(path_568468, "resourceGroupName", newJString(resourceGroupName))
  add(query_568469, "api-version", newJString(apiVersion))
  add(path_568468, "subscriptionId", newJString(subscriptionId))
  add(path_568468, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_568468, "environmentName", newJString(environmentName))
  if referenceDataSetUpdateParameters != nil:
    body_568470 = referenceDataSetUpdateParameters
  result = call_568467.call(path_568468, query_568469, nil, nil, body_568470)

var referenceDataSetsUpdate* = Call_ReferenceDataSetsUpdate_568457(
    name: "referenceDataSetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsUpdate_568458, base: "",
    url: url_ReferenceDataSetsUpdate_568459, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsDelete_568445 = ref object of OpenApiRestCall_567666
proc url_ReferenceDataSetsDelete_568447(protocol: Scheme; host: string; base: string;
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

proc validate_ReferenceDataSetsDelete_568446(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the reference data set with the specified name in the specified subscription, resource group, and environment
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   referenceDataSetName: JString (required)
  ##                       : The name of the Time Series Insights reference data set associated with the specified environment.
  ##   environmentName: JString (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568448 = path.getOrDefault("resourceGroupName")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "resourceGroupName", valid_568448
  var valid_568449 = path.getOrDefault("subscriptionId")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "subscriptionId", valid_568449
  var valid_568450 = path.getOrDefault("referenceDataSetName")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "referenceDataSetName", valid_568450
  var valid_568451 = path.getOrDefault("environmentName")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "environmentName", valid_568451
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568452 = query.getOrDefault("api-version")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "api-version", valid_568452
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568453: Call_ReferenceDataSetsDelete_568445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the reference data set with the specified name in the specified subscription, resource group, and environment
  ## 
  let valid = call_568453.validator(path, query, header, formData, body)
  let scheme = call_568453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568453.url(scheme.get, call_568453.host, call_568453.base,
                         call_568453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568453, url, valid)

proc call*(call_568454: Call_ReferenceDataSetsDelete_568445;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          referenceDataSetName: string; environmentName: string): Recallable =
  ## referenceDataSetsDelete
  ## Deletes the reference data set with the specified name in the specified subscription, resource group, and environment
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-02-28-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   referenceDataSetName: string (required)
  ##                       : The name of the Time Series Insights reference data set associated with the specified environment.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568455 = newJObject()
  var query_568456 = newJObject()
  add(path_568455, "resourceGroupName", newJString(resourceGroupName))
  add(query_568456, "api-version", newJString(apiVersion))
  add(path_568455, "subscriptionId", newJString(subscriptionId))
  add(path_568455, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_568455, "environmentName", newJString(environmentName))
  result = call_568454.call(path_568455, query_568456, nil, nil, nil)

var referenceDataSetsDelete* = Call_ReferenceDataSetsDelete_568445(
    name: "referenceDataSetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsDelete_568446, base: "",
    url: url_ReferenceDataSetsDelete_568447, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
