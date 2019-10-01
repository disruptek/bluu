
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  ##              : Version of the API to be used with the client request.
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
  ##             : Version of the API to be used with the client request.
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
  ##              : Version of the API to be used with the client request.
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
  ##             : Version of the API to be used with the client request.
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
  ##              : Version of the API to be used with the client request.
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
  ##             : Version of the API to be used with the client request.
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
  Call_EnvironmentsCreateOrUpdate_568230 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsCreateOrUpdate_568232(protocol: Scheme; host: string;
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

proc validate_EnvironmentsCreateOrUpdate_568231(path: JsonNode; query: JsonNode;
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
  var valid_568250 = path.getOrDefault("resourceGroupName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "resourceGroupName", valid_568250
  var valid_568251 = path.getOrDefault("subscriptionId")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "subscriptionId", valid_568251
  var valid_568252 = path.getOrDefault("environmentName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "environmentName", valid_568252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568253 = query.getOrDefault("api-version")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "api-version", valid_568253
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

proc call*(call_568255: Call_EnvironmentsCreateOrUpdate_568230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an environment in the specified subscription and resource group.
  ## 
  let valid = call_568255.validator(path, query, header, formData, body)
  let scheme = call_568255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568255.url(scheme.get, call_568255.host, call_568255.base,
                         call_568255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568255, url, valid)

proc call*(call_568256: Call_EnvironmentsCreateOrUpdate_568230;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          environmentName: string; parameters: JsonNode): Recallable =
  ## environmentsCreateOrUpdate
  ## Create or update an environment in the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : Name of the environment
  ##   parameters: JObject (required)
  ##             : Parameters for creating an environment resource.
  var path_568257 = newJObject()
  var query_568258 = newJObject()
  var body_568259 = newJObject()
  add(path_568257, "resourceGroupName", newJString(resourceGroupName))
  add(query_568258, "api-version", newJString(apiVersion))
  add(path_568257, "subscriptionId", newJString(subscriptionId))
  add(path_568257, "environmentName", newJString(environmentName))
  if parameters != nil:
    body_568259 = parameters
  result = call_568256.call(path_568257, query_568258, nil, nil, body_568259)

var environmentsCreateOrUpdate* = Call_EnvironmentsCreateOrUpdate_568230(
    name: "environmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsCreateOrUpdate_568231, base: "",
    url: url_EnvironmentsCreateOrUpdate_568232, schemes: {Scheme.Https})
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
  var valid_568221 = path.getOrDefault("resourceGroupName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "resourceGroupName", valid_568221
  var valid_568222 = path.getOrDefault("subscriptionId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "subscriptionId", valid_568222
  var valid_568223 = path.getOrDefault("environmentName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "environmentName", valid_568223
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Setting $expand=status will include the status of the internal services of the environment in the Time Series Insights service.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  var valid_568224 = query.getOrDefault("$expand")
  valid_568224 = validateParameter(valid_568224, JString, required = false,
                                 default = nil)
  if valid_568224 != nil:
    section.add "$expand", valid_568224
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568225 = query.getOrDefault("api-version")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "api-version", valid_568225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568226: Call_EnvironmentsGet_568217; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the environment with the specified name in the specified subscription and resource group.
  ## 
  let valid = call_568226.validator(path, query, header, formData, body)
  let scheme = call_568226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568226.url(scheme.get, call_568226.host, call_568226.base,
                         call_568226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568226, url, valid)

proc call*(call_568227: Call_EnvironmentsGet_568217; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; environmentName: string;
          Expand: string = ""): Recallable =
  ## environmentsGet
  ## Gets the environment with the specified name in the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   Expand: string
  ##         : Setting $expand=status will include the status of the internal services of the environment in the Time Series Insights service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568228 = newJObject()
  var query_568229 = newJObject()
  add(path_568228, "resourceGroupName", newJString(resourceGroupName))
  add(query_568229, "$expand", newJString(Expand))
  add(query_568229, "api-version", newJString(apiVersion))
  add(path_568228, "subscriptionId", newJString(subscriptionId))
  add(path_568228, "environmentName", newJString(environmentName))
  result = call_568227.call(path_568228, query_568229, nil, nil, nil)

var environmentsGet* = Call_EnvironmentsGet_568217(name: "environmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsGet_568218, base: "", url: url_EnvironmentsGet_568219,
    schemes: {Scheme.Https})
type
  Call_EnvironmentsUpdate_568271 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsUpdate_568273(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsUpdate_568272(path: JsonNode; query: JsonNode;
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
  var valid_568274 = path.getOrDefault("resourceGroupName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "resourceGroupName", valid_568274
  var valid_568275 = path.getOrDefault("subscriptionId")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "subscriptionId", valid_568275
  var valid_568276 = path.getOrDefault("environmentName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "environmentName", valid_568276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568277 = query.getOrDefault("api-version")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "api-version", valid_568277
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

proc call*(call_568279: Call_EnvironmentsUpdate_568271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the environment with the specified name in the specified subscription and resource group.
  ## 
  let valid = call_568279.validator(path, query, header, formData, body)
  let scheme = call_568279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568279.url(scheme.get, call_568279.host, call_568279.base,
                         call_568279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568279, url, valid)

proc call*(call_568280: Call_EnvironmentsUpdate_568271; resourceGroupName: string;
          apiVersion: string; environmentUpdateParameters: JsonNode;
          subscriptionId: string; environmentName: string): Recallable =
  ## environmentsUpdate
  ## Updates the environment with the specified name in the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   environmentUpdateParameters: JObject (required)
  ##                              : Request object that contains the updated information for the environment.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568281 = newJObject()
  var query_568282 = newJObject()
  var body_568283 = newJObject()
  add(path_568281, "resourceGroupName", newJString(resourceGroupName))
  add(query_568282, "api-version", newJString(apiVersion))
  if environmentUpdateParameters != nil:
    body_568283 = environmentUpdateParameters
  add(path_568281, "subscriptionId", newJString(subscriptionId))
  add(path_568281, "environmentName", newJString(environmentName))
  result = call_568280.call(path_568281, query_568282, nil, nil, body_568283)

var environmentsUpdate* = Call_EnvironmentsUpdate_568271(
    name: "environmentsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsUpdate_568272, base: "",
    url: url_EnvironmentsUpdate_568273, schemes: {Scheme.Https})
type
  Call_EnvironmentsDelete_568260 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsDelete_568262(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsDelete_568261(path: JsonNode; query: JsonNode;
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
  var valid_568263 = path.getOrDefault("resourceGroupName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "resourceGroupName", valid_568263
  var valid_568264 = path.getOrDefault("subscriptionId")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "subscriptionId", valid_568264
  var valid_568265 = path.getOrDefault("environmentName")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "environmentName", valid_568265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568266 = query.getOrDefault("api-version")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "api-version", valid_568266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568267: Call_EnvironmentsDelete_568260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the environment with the specified name in the specified subscription and resource group.
  ## 
  let valid = call_568267.validator(path, query, header, formData, body)
  let scheme = call_568267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568267.url(scheme.get, call_568267.host, call_568267.base,
                         call_568267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568267, url, valid)

proc call*(call_568268: Call_EnvironmentsDelete_568260; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; environmentName: string): Recallable =
  ## environmentsDelete
  ## Deletes the environment with the specified name in the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568269 = newJObject()
  var query_568270 = newJObject()
  add(path_568269, "resourceGroupName", newJString(resourceGroupName))
  add(query_568270, "api-version", newJString(apiVersion))
  add(path_568269, "subscriptionId", newJString(subscriptionId))
  add(path_568269, "environmentName", newJString(environmentName))
  result = call_568268.call(path_568269, query_568270, nil, nil, nil)

var environmentsDelete* = Call_EnvironmentsDelete_568260(
    name: "environmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsDelete_568261, base: "",
    url: url_EnvironmentsDelete_568262, schemes: {Scheme.Https})
type
  Call_AccessPoliciesListByEnvironment_568284 = ref object of OpenApiRestCall_567666
proc url_AccessPoliciesListByEnvironment_568286(protocol: Scheme; host: string;
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

proc validate_AccessPoliciesListByEnvironment_568285(path: JsonNode;
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
  var valid_568287 = path.getOrDefault("resourceGroupName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "resourceGroupName", valid_568287
  var valid_568288 = path.getOrDefault("subscriptionId")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "subscriptionId", valid_568288
  var valid_568289 = path.getOrDefault("environmentName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "environmentName", valid_568289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568290 = query.getOrDefault("api-version")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "api-version", valid_568290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568291: Call_AccessPoliciesListByEnvironment_568284;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the available access policies associated with the environment.
  ## 
  let valid = call_568291.validator(path, query, header, formData, body)
  let scheme = call_568291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568291.url(scheme.get, call_568291.host, call_568291.base,
                         call_568291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568291, url, valid)

proc call*(call_568292: Call_AccessPoliciesListByEnvironment_568284;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          environmentName: string): Recallable =
  ## accessPoliciesListByEnvironment
  ## Lists all the available access policies associated with the environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568293 = newJObject()
  var query_568294 = newJObject()
  add(path_568293, "resourceGroupName", newJString(resourceGroupName))
  add(query_568294, "api-version", newJString(apiVersion))
  add(path_568293, "subscriptionId", newJString(subscriptionId))
  add(path_568293, "environmentName", newJString(environmentName))
  result = call_568292.call(path_568293, query_568294, nil, nil, nil)

var accessPoliciesListByEnvironment* = Call_AccessPoliciesListByEnvironment_568284(
    name: "accessPoliciesListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies",
    validator: validate_AccessPoliciesListByEnvironment_568285, base: "",
    url: url_AccessPoliciesListByEnvironment_568286, schemes: {Scheme.Https})
type
  Call_AccessPoliciesCreateOrUpdate_568307 = ref object of OpenApiRestCall_567666
proc url_AccessPoliciesCreateOrUpdate_568309(protocol: Scheme; host: string;
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

proc validate_AccessPoliciesCreateOrUpdate_568308(path: JsonNode; query: JsonNode;
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
  var valid_568310 = path.getOrDefault("resourceGroupName")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "resourceGroupName", valid_568310
  var valid_568311 = path.getOrDefault("subscriptionId")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "subscriptionId", valid_568311
  var valid_568312 = path.getOrDefault("environmentName")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "environmentName", valid_568312
  var valid_568313 = path.getOrDefault("accessPolicyName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "accessPolicyName", valid_568313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568314 = query.getOrDefault("api-version")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "api-version", valid_568314
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

proc call*(call_568316: Call_AccessPoliciesCreateOrUpdate_568307; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an access policy in the specified environment.
  ## 
  let valid = call_568316.validator(path, query, header, formData, body)
  let scheme = call_568316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568316.url(scheme.get, call_568316.host, call_568316.base,
                         call_568316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568316, url, valid)

proc call*(call_568317: Call_AccessPoliciesCreateOrUpdate_568307;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          environmentName: string; parameters: JsonNode; accessPolicyName: string): Recallable =
  ## accessPoliciesCreateOrUpdate
  ## Create or update an access policy in the specified environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   parameters: JObject (required)
  ##             : Parameters for creating an access policy.
  ##   accessPolicyName: string (required)
  ##                   : Name of the access policy.
  var path_568318 = newJObject()
  var query_568319 = newJObject()
  var body_568320 = newJObject()
  add(path_568318, "resourceGroupName", newJString(resourceGroupName))
  add(query_568319, "api-version", newJString(apiVersion))
  add(path_568318, "subscriptionId", newJString(subscriptionId))
  add(path_568318, "environmentName", newJString(environmentName))
  if parameters != nil:
    body_568320 = parameters
  add(path_568318, "accessPolicyName", newJString(accessPolicyName))
  result = call_568317.call(path_568318, query_568319, nil, nil, body_568320)

var accessPoliciesCreateOrUpdate* = Call_AccessPoliciesCreateOrUpdate_568307(
    name: "accessPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesCreateOrUpdate_568308, base: "",
    url: url_AccessPoliciesCreateOrUpdate_568309, schemes: {Scheme.Https})
type
  Call_AccessPoliciesGet_568295 = ref object of OpenApiRestCall_567666
proc url_AccessPoliciesGet_568297(protocol: Scheme; host: string; base: string;
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

proc validate_AccessPoliciesGet_568296(path: JsonNode; query: JsonNode;
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
  var valid_568298 = path.getOrDefault("resourceGroupName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "resourceGroupName", valid_568298
  var valid_568299 = path.getOrDefault("subscriptionId")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "subscriptionId", valid_568299
  var valid_568300 = path.getOrDefault("environmentName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "environmentName", valid_568300
  var valid_568301 = path.getOrDefault("accessPolicyName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "accessPolicyName", valid_568301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568302 = query.getOrDefault("api-version")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "api-version", valid_568302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568303: Call_AccessPoliciesGet_568295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access policy with the specified name in the specified environment.
  ## 
  let valid = call_568303.validator(path, query, header, formData, body)
  let scheme = call_568303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568303.url(scheme.get, call_568303.host, call_568303.base,
                         call_568303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568303, url, valid)

proc call*(call_568304: Call_AccessPoliciesGet_568295; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; environmentName: string;
          accessPolicyName: string): Recallable =
  ## accessPoliciesGet
  ## Gets the access policy with the specified name in the specified environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   accessPolicyName: string (required)
  ##                   : The name of the Time Series Insights access policy associated with the specified environment.
  var path_568305 = newJObject()
  var query_568306 = newJObject()
  add(path_568305, "resourceGroupName", newJString(resourceGroupName))
  add(query_568306, "api-version", newJString(apiVersion))
  add(path_568305, "subscriptionId", newJString(subscriptionId))
  add(path_568305, "environmentName", newJString(environmentName))
  add(path_568305, "accessPolicyName", newJString(accessPolicyName))
  result = call_568304.call(path_568305, query_568306, nil, nil, nil)

var accessPoliciesGet* = Call_AccessPoliciesGet_568295(name: "accessPoliciesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesGet_568296, base: "",
    url: url_AccessPoliciesGet_568297, schemes: {Scheme.Https})
type
  Call_AccessPoliciesUpdate_568333 = ref object of OpenApiRestCall_567666
proc url_AccessPoliciesUpdate_568335(protocol: Scheme; host: string; base: string;
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

proc validate_AccessPoliciesUpdate_568334(path: JsonNode; query: JsonNode;
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
  var valid_568336 = path.getOrDefault("resourceGroupName")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "resourceGroupName", valid_568336
  var valid_568337 = path.getOrDefault("subscriptionId")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "subscriptionId", valid_568337
  var valid_568338 = path.getOrDefault("environmentName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "environmentName", valid_568338
  var valid_568339 = path.getOrDefault("accessPolicyName")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "accessPolicyName", valid_568339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568340 = query.getOrDefault("api-version")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "api-version", valid_568340
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

proc call*(call_568342: Call_AccessPoliciesUpdate_568333; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the access policy with the specified name in the specified subscription, resource group, and environment.
  ## 
  let valid = call_568342.validator(path, query, header, formData, body)
  let scheme = call_568342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568342.url(scheme.get, call_568342.host, call_568342.base,
                         call_568342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568342, url, valid)

proc call*(call_568343: Call_AccessPoliciesUpdate_568333;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accessPolicyUpdateParameters: JsonNode; environmentName: string;
          accessPolicyName: string): Recallable =
  ## accessPoliciesUpdate
  ## Updates the access policy with the specified name in the specified subscription, resource group, and environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   accessPolicyUpdateParameters: JObject (required)
  ##                               : Request object that contains the updated information for the access policy.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   accessPolicyName: string (required)
  ##                   : The name of the Time Series Insights access policy associated with the specified environment.
  var path_568344 = newJObject()
  var query_568345 = newJObject()
  var body_568346 = newJObject()
  add(path_568344, "resourceGroupName", newJString(resourceGroupName))
  add(query_568345, "api-version", newJString(apiVersion))
  add(path_568344, "subscriptionId", newJString(subscriptionId))
  if accessPolicyUpdateParameters != nil:
    body_568346 = accessPolicyUpdateParameters
  add(path_568344, "environmentName", newJString(environmentName))
  add(path_568344, "accessPolicyName", newJString(accessPolicyName))
  result = call_568343.call(path_568344, query_568345, nil, nil, body_568346)

var accessPoliciesUpdate* = Call_AccessPoliciesUpdate_568333(
    name: "accessPoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesUpdate_568334, base: "",
    url: url_AccessPoliciesUpdate_568335, schemes: {Scheme.Https})
type
  Call_AccessPoliciesDelete_568321 = ref object of OpenApiRestCall_567666
proc url_AccessPoliciesDelete_568323(protocol: Scheme; host: string; base: string;
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

proc validate_AccessPoliciesDelete_568322(path: JsonNode; query: JsonNode;
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
  var valid_568324 = path.getOrDefault("resourceGroupName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "resourceGroupName", valid_568324
  var valid_568325 = path.getOrDefault("subscriptionId")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "subscriptionId", valid_568325
  var valid_568326 = path.getOrDefault("environmentName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "environmentName", valid_568326
  var valid_568327 = path.getOrDefault("accessPolicyName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "accessPolicyName", valid_568327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568328 = query.getOrDefault("api-version")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "api-version", valid_568328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568329: Call_AccessPoliciesDelete_568321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the access policy with the specified name in the specified subscription, resource group, and environment
  ## 
  let valid = call_568329.validator(path, query, header, formData, body)
  let scheme = call_568329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568329.url(scheme.get, call_568329.host, call_568329.base,
                         call_568329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568329, url, valid)

proc call*(call_568330: Call_AccessPoliciesDelete_568321;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          environmentName: string; accessPolicyName: string): Recallable =
  ## accessPoliciesDelete
  ## Deletes the access policy with the specified name in the specified subscription, resource group, and environment
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   accessPolicyName: string (required)
  ##                   : The name of the Time Series Insights access policy associated with the specified environment.
  var path_568331 = newJObject()
  var query_568332 = newJObject()
  add(path_568331, "resourceGroupName", newJString(resourceGroupName))
  add(query_568332, "api-version", newJString(apiVersion))
  add(path_568331, "subscriptionId", newJString(subscriptionId))
  add(path_568331, "environmentName", newJString(environmentName))
  add(path_568331, "accessPolicyName", newJString(accessPolicyName))
  result = call_568330.call(path_568331, query_568332, nil, nil, nil)

var accessPoliciesDelete* = Call_AccessPoliciesDelete_568321(
    name: "accessPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesDelete_568322, base: "",
    url: url_AccessPoliciesDelete_568323, schemes: {Scheme.Https})
type
  Call_EventSourcesListByEnvironment_568347 = ref object of OpenApiRestCall_567666
proc url_EventSourcesListByEnvironment_568349(protocol: Scheme; host: string;
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

proc validate_EventSourcesListByEnvironment_568348(path: JsonNode; query: JsonNode;
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
  var valid_568350 = path.getOrDefault("resourceGroupName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "resourceGroupName", valid_568350
  var valid_568351 = path.getOrDefault("subscriptionId")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "subscriptionId", valid_568351
  var valid_568352 = path.getOrDefault("environmentName")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "environmentName", valid_568352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568353 = query.getOrDefault("api-version")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "api-version", valid_568353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568354: Call_EventSourcesListByEnvironment_568347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available event sources associated with the subscription and within the specified resource group and environment.
  ## 
  let valid = call_568354.validator(path, query, header, formData, body)
  let scheme = call_568354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568354.url(scheme.get, call_568354.host, call_568354.base,
                         call_568354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568354, url, valid)

proc call*(call_568355: Call_EventSourcesListByEnvironment_568347;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          environmentName: string): Recallable =
  ## eventSourcesListByEnvironment
  ## Lists all the available event sources associated with the subscription and within the specified resource group and environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568356 = newJObject()
  var query_568357 = newJObject()
  add(path_568356, "resourceGroupName", newJString(resourceGroupName))
  add(query_568357, "api-version", newJString(apiVersion))
  add(path_568356, "subscriptionId", newJString(subscriptionId))
  add(path_568356, "environmentName", newJString(environmentName))
  result = call_568355.call(path_568356, query_568357, nil, nil, nil)

var eventSourcesListByEnvironment* = Call_EventSourcesListByEnvironment_568347(
    name: "eventSourcesListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources",
    validator: validate_EventSourcesListByEnvironment_568348, base: "",
    url: url_EventSourcesListByEnvironment_568349, schemes: {Scheme.Https})
type
  Call_EventSourcesCreateOrUpdate_568370 = ref object of OpenApiRestCall_567666
proc url_EventSourcesCreateOrUpdate_568372(protocol: Scheme; host: string;
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

proc validate_EventSourcesCreateOrUpdate_568371(path: JsonNode; query: JsonNode;
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
  var valid_568373 = path.getOrDefault("resourceGroupName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "resourceGroupName", valid_568373
  var valid_568374 = path.getOrDefault("eventSourceName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "eventSourceName", valid_568374
  var valid_568375 = path.getOrDefault("subscriptionId")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "subscriptionId", valid_568375
  var valid_568376 = path.getOrDefault("environmentName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "environmentName", valid_568376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568377 = query.getOrDefault("api-version")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "api-version", valid_568377
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

proc call*(call_568379: Call_EventSourcesCreateOrUpdate_568370; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an event source under the specified environment.
  ## 
  let valid = call_568379.validator(path, query, header, formData, body)
  let scheme = call_568379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568379.url(scheme.get, call_568379.host, call_568379.base,
                         call_568379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568379, url, valid)

proc call*(call_568380: Call_EventSourcesCreateOrUpdate_568370;
          resourceGroupName: string; apiVersion: string; eventSourceName: string;
          subscriptionId: string; environmentName: string; parameters: JsonNode): Recallable =
  ## eventSourcesCreateOrUpdate
  ## Create or update an event source under the specified environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   eventSourceName: string (required)
  ##                  : Name of the event source.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   parameters: JObject (required)
  ##             : Parameters for creating an event source resource.
  var path_568381 = newJObject()
  var query_568382 = newJObject()
  var body_568383 = newJObject()
  add(path_568381, "resourceGroupName", newJString(resourceGroupName))
  add(query_568382, "api-version", newJString(apiVersion))
  add(path_568381, "eventSourceName", newJString(eventSourceName))
  add(path_568381, "subscriptionId", newJString(subscriptionId))
  add(path_568381, "environmentName", newJString(environmentName))
  if parameters != nil:
    body_568383 = parameters
  result = call_568380.call(path_568381, query_568382, nil, nil, body_568383)

var eventSourcesCreateOrUpdate* = Call_EventSourcesCreateOrUpdate_568370(
    name: "eventSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesCreateOrUpdate_568371, base: "",
    url: url_EventSourcesCreateOrUpdate_568372, schemes: {Scheme.Https})
type
  Call_EventSourcesGet_568358 = ref object of OpenApiRestCall_567666
proc url_EventSourcesGet_568360(protocol: Scheme; host: string; base: string;
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

proc validate_EventSourcesGet_568359(path: JsonNode; query: JsonNode;
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
  var valid_568361 = path.getOrDefault("resourceGroupName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "resourceGroupName", valid_568361
  var valid_568362 = path.getOrDefault("eventSourceName")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "eventSourceName", valid_568362
  var valid_568363 = path.getOrDefault("subscriptionId")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "subscriptionId", valid_568363
  var valid_568364 = path.getOrDefault("environmentName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "environmentName", valid_568364
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568365 = query.getOrDefault("api-version")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "api-version", valid_568365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568366: Call_EventSourcesGet_568358; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the event source with the specified name in the specified environment.
  ## 
  let valid = call_568366.validator(path, query, header, formData, body)
  let scheme = call_568366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568366.url(scheme.get, call_568366.host, call_568366.base,
                         call_568366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568366, url, valid)

proc call*(call_568367: Call_EventSourcesGet_568358; resourceGroupName: string;
          apiVersion: string; eventSourceName: string; subscriptionId: string;
          environmentName: string): Recallable =
  ## eventSourcesGet
  ## Gets the event source with the specified name in the specified environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   eventSourceName: string (required)
  ##                  : The name of the Time Series Insights event source associated with the specified environment.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568368 = newJObject()
  var query_568369 = newJObject()
  add(path_568368, "resourceGroupName", newJString(resourceGroupName))
  add(query_568369, "api-version", newJString(apiVersion))
  add(path_568368, "eventSourceName", newJString(eventSourceName))
  add(path_568368, "subscriptionId", newJString(subscriptionId))
  add(path_568368, "environmentName", newJString(environmentName))
  result = call_568367.call(path_568368, query_568369, nil, nil, nil)

var eventSourcesGet* = Call_EventSourcesGet_568358(name: "eventSourcesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesGet_568359, base: "", url: url_EventSourcesGet_568360,
    schemes: {Scheme.Https})
type
  Call_EventSourcesUpdate_568396 = ref object of OpenApiRestCall_567666
proc url_EventSourcesUpdate_568398(protocol: Scheme; host: string; base: string;
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

proc validate_EventSourcesUpdate_568397(path: JsonNode; query: JsonNode;
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
  var valid_568399 = path.getOrDefault("resourceGroupName")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "resourceGroupName", valid_568399
  var valid_568400 = path.getOrDefault("eventSourceName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "eventSourceName", valid_568400
  var valid_568401 = path.getOrDefault("subscriptionId")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "subscriptionId", valid_568401
  var valid_568402 = path.getOrDefault("environmentName")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "environmentName", valid_568402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568403 = query.getOrDefault("api-version")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "api-version", valid_568403
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

proc call*(call_568405: Call_EventSourcesUpdate_568396; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the event source with the specified name in the specified subscription, resource group, and environment.
  ## 
  let valid = call_568405.validator(path, query, header, formData, body)
  let scheme = call_568405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568405.url(scheme.get, call_568405.host, call_568405.base,
                         call_568405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568405, url, valid)

proc call*(call_568406: Call_EventSourcesUpdate_568396; resourceGroupName: string;
          apiVersion: string; eventSourceName: string; subscriptionId: string;
          eventSourceUpdateParameters: JsonNode; environmentName: string): Recallable =
  ## eventSourcesUpdate
  ## Updates the event source with the specified name in the specified subscription, resource group, and environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   eventSourceName: string (required)
  ##                  : The name of the Time Series Insights event source associated with the specified environment.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   eventSourceUpdateParameters: JObject (required)
  ##                              : Request object that contains the updated information for the event source.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568407 = newJObject()
  var query_568408 = newJObject()
  var body_568409 = newJObject()
  add(path_568407, "resourceGroupName", newJString(resourceGroupName))
  add(query_568408, "api-version", newJString(apiVersion))
  add(path_568407, "eventSourceName", newJString(eventSourceName))
  add(path_568407, "subscriptionId", newJString(subscriptionId))
  if eventSourceUpdateParameters != nil:
    body_568409 = eventSourceUpdateParameters
  add(path_568407, "environmentName", newJString(environmentName))
  result = call_568406.call(path_568407, query_568408, nil, nil, body_568409)

var eventSourcesUpdate* = Call_EventSourcesUpdate_568396(
    name: "eventSourcesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesUpdate_568397, base: "",
    url: url_EventSourcesUpdate_568398, schemes: {Scheme.Https})
type
  Call_EventSourcesDelete_568384 = ref object of OpenApiRestCall_567666
proc url_EventSourcesDelete_568386(protocol: Scheme; host: string; base: string;
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

proc validate_EventSourcesDelete_568385(path: JsonNode; query: JsonNode;
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
  var valid_568387 = path.getOrDefault("resourceGroupName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "resourceGroupName", valid_568387
  var valid_568388 = path.getOrDefault("eventSourceName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "eventSourceName", valid_568388
  var valid_568389 = path.getOrDefault("subscriptionId")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "subscriptionId", valid_568389
  var valid_568390 = path.getOrDefault("environmentName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "environmentName", valid_568390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568391 = query.getOrDefault("api-version")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "api-version", valid_568391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568392: Call_EventSourcesDelete_568384; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the event source with the specified name in the specified subscription, resource group, and environment
  ## 
  let valid = call_568392.validator(path, query, header, formData, body)
  let scheme = call_568392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568392.url(scheme.get, call_568392.host, call_568392.base,
                         call_568392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568392, url, valid)

proc call*(call_568393: Call_EventSourcesDelete_568384; resourceGroupName: string;
          apiVersion: string; eventSourceName: string; subscriptionId: string;
          environmentName: string): Recallable =
  ## eventSourcesDelete
  ## Deletes the event source with the specified name in the specified subscription, resource group, and environment
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   eventSourceName: string (required)
  ##                  : The name of the Time Series Insights event source associated with the specified environment.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568394 = newJObject()
  var query_568395 = newJObject()
  add(path_568394, "resourceGroupName", newJString(resourceGroupName))
  add(query_568395, "api-version", newJString(apiVersion))
  add(path_568394, "eventSourceName", newJString(eventSourceName))
  add(path_568394, "subscriptionId", newJString(subscriptionId))
  add(path_568394, "environmentName", newJString(environmentName))
  result = call_568393.call(path_568394, query_568395, nil, nil, nil)

var eventSourcesDelete* = Call_EventSourcesDelete_568384(
    name: "eventSourcesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesDelete_568385, base: "",
    url: url_EventSourcesDelete_568386, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsListByEnvironment_568410 = ref object of OpenApiRestCall_567666
proc url_ReferenceDataSetsListByEnvironment_568412(protocol: Scheme; host: string;
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

proc validate_ReferenceDataSetsListByEnvironment_568411(path: JsonNode;
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
  var valid_568413 = path.getOrDefault("resourceGroupName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "resourceGroupName", valid_568413
  var valid_568414 = path.getOrDefault("subscriptionId")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "subscriptionId", valid_568414
  var valid_568415 = path.getOrDefault("environmentName")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "environmentName", valid_568415
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568416 = query.getOrDefault("api-version")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "api-version", valid_568416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568417: Call_ReferenceDataSetsListByEnvironment_568410;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the available reference data sets associated with the subscription and within the specified resource group and environment.
  ## 
  let valid = call_568417.validator(path, query, header, formData, body)
  let scheme = call_568417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568417.url(scheme.get, call_568417.host, call_568417.base,
                         call_568417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568417, url, valid)

proc call*(call_568418: Call_ReferenceDataSetsListByEnvironment_568410;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          environmentName: string): Recallable =
  ## referenceDataSetsListByEnvironment
  ## Lists all the available reference data sets associated with the subscription and within the specified resource group and environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568419 = newJObject()
  var query_568420 = newJObject()
  add(path_568419, "resourceGroupName", newJString(resourceGroupName))
  add(query_568420, "api-version", newJString(apiVersion))
  add(path_568419, "subscriptionId", newJString(subscriptionId))
  add(path_568419, "environmentName", newJString(environmentName))
  result = call_568418.call(path_568419, query_568420, nil, nil, nil)

var referenceDataSetsListByEnvironment* = Call_ReferenceDataSetsListByEnvironment_568410(
    name: "referenceDataSetsListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets",
    validator: validate_ReferenceDataSetsListByEnvironment_568411, base: "",
    url: url_ReferenceDataSetsListByEnvironment_568412, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsCreateOrUpdate_568433 = ref object of OpenApiRestCall_567666
proc url_ReferenceDataSetsCreateOrUpdate_568435(protocol: Scheme; host: string;
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

proc validate_ReferenceDataSetsCreateOrUpdate_568434(path: JsonNode;
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
  var valid_568436 = path.getOrDefault("resourceGroupName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "resourceGroupName", valid_568436
  var valid_568437 = path.getOrDefault("subscriptionId")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "subscriptionId", valid_568437
  var valid_568438 = path.getOrDefault("referenceDataSetName")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "referenceDataSetName", valid_568438
  var valid_568439 = path.getOrDefault("environmentName")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "environmentName", valid_568439
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568440 = query.getOrDefault("api-version")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "api-version", valid_568440
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

proc call*(call_568442: Call_ReferenceDataSetsCreateOrUpdate_568433;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a reference data set in the specified environment.
  ## 
  let valid = call_568442.validator(path, query, header, formData, body)
  let scheme = call_568442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568442.url(scheme.get, call_568442.host, call_568442.base,
                         call_568442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568442, url, valid)

proc call*(call_568443: Call_ReferenceDataSetsCreateOrUpdate_568433;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          referenceDataSetName: string; environmentName: string;
          parameters: JsonNode): Recallable =
  ## referenceDataSetsCreateOrUpdate
  ## Create or update a reference data set in the specified environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   referenceDataSetName: string (required)
  ##                       : Name of the reference data set.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   parameters: JObject (required)
  ##             : Parameters for creating a reference data set.
  var path_568444 = newJObject()
  var query_568445 = newJObject()
  var body_568446 = newJObject()
  add(path_568444, "resourceGroupName", newJString(resourceGroupName))
  add(query_568445, "api-version", newJString(apiVersion))
  add(path_568444, "subscriptionId", newJString(subscriptionId))
  add(path_568444, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_568444, "environmentName", newJString(environmentName))
  if parameters != nil:
    body_568446 = parameters
  result = call_568443.call(path_568444, query_568445, nil, nil, body_568446)

var referenceDataSetsCreateOrUpdate* = Call_ReferenceDataSetsCreateOrUpdate_568433(
    name: "referenceDataSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsCreateOrUpdate_568434, base: "",
    url: url_ReferenceDataSetsCreateOrUpdate_568435, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsGet_568421 = ref object of OpenApiRestCall_567666
proc url_ReferenceDataSetsGet_568423(protocol: Scheme; host: string; base: string;
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

proc validate_ReferenceDataSetsGet_568422(path: JsonNode; query: JsonNode;
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
  var valid_568424 = path.getOrDefault("resourceGroupName")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "resourceGroupName", valid_568424
  var valid_568425 = path.getOrDefault("subscriptionId")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "subscriptionId", valid_568425
  var valid_568426 = path.getOrDefault("referenceDataSetName")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "referenceDataSetName", valid_568426
  var valid_568427 = path.getOrDefault("environmentName")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "environmentName", valid_568427
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568428 = query.getOrDefault("api-version")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "api-version", valid_568428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568429: Call_ReferenceDataSetsGet_568421; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the reference data set with the specified name in the specified environment.
  ## 
  let valid = call_568429.validator(path, query, header, formData, body)
  let scheme = call_568429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568429.url(scheme.get, call_568429.host, call_568429.base,
                         call_568429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568429, url, valid)

proc call*(call_568430: Call_ReferenceDataSetsGet_568421;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          referenceDataSetName: string; environmentName: string): Recallable =
  ## referenceDataSetsGet
  ## Gets the reference data set with the specified name in the specified environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   referenceDataSetName: string (required)
  ##                       : The name of the Time Series Insights reference data set associated with the specified environment.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568431 = newJObject()
  var query_568432 = newJObject()
  add(path_568431, "resourceGroupName", newJString(resourceGroupName))
  add(query_568432, "api-version", newJString(apiVersion))
  add(path_568431, "subscriptionId", newJString(subscriptionId))
  add(path_568431, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_568431, "environmentName", newJString(environmentName))
  result = call_568430.call(path_568431, query_568432, nil, nil, nil)

var referenceDataSetsGet* = Call_ReferenceDataSetsGet_568421(
    name: "referenceDataSetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsGet_568422, base: "",
    url: url_ReferenceDataSetsGet_568423, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsUpdate_568459 = ref object of OpenApiRestCall_567666
proc url_ReferenceDataSetsUpdate_568461(protocol: Scheme; host: string; base: string;
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

proc validate_ReferenceDataSetsUpdate_568460(path: JsonNode; query: JsonNode;
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
  var valid_568462 = path.getOrDefault("resourceGroupName")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "resourceGroupName", valid_568462
  var valid_568463 = path.getOrDefault("subscriptionId")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "subscriptionId", valid_568463
  var valid_568464 = path.getOrDefault("referenceDataSetName")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "referenceDataSetName", valid_568464
  var valid_568465 = path.getOrDefault("environmentName")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "environmentName", valid_568465
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568466 = query.getOrDefault("api-version")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "api-version", valid_568466
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

proc call*(call_568468: Call_ReferenceDataSetsUpdate_568459; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the reference data set with the specified name in the specified subscription, resource group, and environment.
  ## 
  let valid = call_568468.validator(path, query, header, formData, body)
  let scheme = call_568468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568468.url(scheme.get, call_568468.host, call_568468.base,
                         call_568468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568468, url, valid)

proc call*(call_568469: Call_ReferenceDataSetsUpdate_568459;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          referenceDataSetName: string; environmentName: string;
          referenceDataSetUpdateParameters: JsonNode): Recallable =
  ## referenceDataSetsUpdate
  ## Updates the reference data set with the specified name in the specified subscription, resource group, and environment.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   referenceDataSetName: string (required)
  ##                       : The name of the Time Series Insights reference data set associated with the specified environment.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  ##   referenceDataSetUpdateParameters: JObject (required)
  ##                                   : Request object that contains the updated information for the reference data set.
  var path_568470 = newJObject()
  var query_568471 = newJObject()
  var body_568472 = newJObject()
  add(path_568470, "resourceGroupName", newJString(resourceGroupName))
  add(query_568471, "api-version", newJString(apiVersion))
  add(path_568470, "subscriptionId", newJString(subscriptionId))
  add(path_568470, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_568470, "environmentName", newJString(environmentName))
  if referenceDataSetUpdateParameters != nil:
    body_568472 = referenceDataSetUpdateParameters
  result = call_568469.call(path_568470, query_568471, nil, nil, body_568472)

var referenceDataSetsUpdate* = Call_ReferenceDataSetsUpdate_568459(
    name: "referenceDataSetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsUpdate_568460, base: "",
    url: url_ReferenceDataSetsUpdate_568461, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsDelete_568447 = ref object of OpenApiRestCall_567666
proc url_ReferenceDataSetsDelete_568449(protocol: Scheme; host: string; base: string;
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

proc validate_ReferenceDataSetsDelete_568448(path: JsonNode; query: JsonNode;
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
  var valid_568450 = path.getOrDefault("resourceGroupName")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "resourceGroupName", valid_568450
  var valid_568451 = path.getOrDefault("subscriptionId")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "subscriptionId", valid_568451
  var valid_568452 = path.getOrDefault("referenceDataSetName")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "referenceDataSetName", valid_568452
  var valid_568453 = path.getOrDefault("environmentName")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "environmentName", valid_568453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568454 = query.getOrDefault("api-version")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "api-version", valid_568454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568455: Call_ReferenceDataSetsDelete_568447; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the reference data set with the specified name in the specified subscription, resource group, and environment
  ## 
  let valid = call_568455.validator(path, query, header, formData, body)
  let scheme = call_568455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568455.url(scheme.get, call_568455.host, call_568455.base,
                         call_568455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568455, url, valid)

proc call*(call_568456: Call_ReferenceDataSetsDelete_568447;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          referenceDataSetName: string; environmentName: string): Recallable =
  ## referenceDataSetsDelete
  ## Deletes the reference data set with the specified name in the specified subscription, resource group, and environment
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   referenceDataSetName: string (required)
  ##                       : The name of the Time Series Insights reference data set associated with the specified environment.
  ##   environmentName: string (required)
  ##                  : The name of the Time Series Insights environment associated with the specified resource group.
  var path_568457 = newJObject()
  var query_568458 = newJObject()
  add(path_568457, "resourceGroupName", newJString(resourceGroupName))
  add(query_568458, "api-version", newJString(apiVersion))
  add(path_568457, "subscriptionId", newJString(subscriptionId))
  add(path_568457, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_568457, "environmentName", newJString(environmentName))
  result = call_568456.call(path_568457, query_568458, nil, nil, nil)

var referenceDataSetsDelete* = Call_ReferenceDataSetsDelete_568447(
    name: "referenceDataSetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsDelete_568448, base: "",
    url: url_ReferenceDataSetsDelete_568449, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
