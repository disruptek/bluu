
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: TimeSeriesInsightsClient
## version: 2017-11-15
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

  OpenApiRestCall_593437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593437): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_OperationsList_593659 = ref object of OpenApiRestCall_593437
proc url_OperationsList_593661(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593660(path: JsonNode; query: JsonNode;
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
  var valid_593820 = query.getOrDefault("api-version")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "api-version", valid_593820
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593843: Call_OperationsList_593659; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Time Series Insights related operations.
  ## 
  let valid = call_593843.validator(path, query, header, formData, body)
  let scheme = call_593843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593843.url(scheme.get, call_593843.host, call_593843.base,
                         call_593843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593843, url, valid)

proc call*(call_593914: Call_OperationsList_593659; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Time Series Insights related operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_593915 = newJObject()
  add(query_593915, "api-version", newJString(apiVersion))
  result = call_593914.call(nil, query_593915, nil, nil, nil)

var operationsList* = Call_OperationsList_593659(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.TimeSeriesInsights/operations",
    validator: validate_OperationsList_593660, base: "", url: url_OperationsList_593661,
    schemes: {Scheme.Https})
type
  Call_EnvironmentsListBySubscription_593955 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsListBySubscription_593957(protocol: Scheme; host: string;
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

proc validate_EnvironmentsListBySubscription_593956(path: JsonNode;
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
  var valid_593972 = path.getOrDefault("subscriptionId")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "subscriptionId", valid_593972
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593973 = query.getOrDefault("api-version")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "api-version", valid_593973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593974: Call_EnvironmentsListBySubscription_593955; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available environments within a subscription, irrespective of the resource groups.
  ## 
  let valid = call_593974.validator(path, query, header, formData, body)
  let scheme = call_593974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593974.url(scheme.get, call_593974.host, call_593974.base,
                         call_593974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593974, url, valid)

proc call*(call_593975: Call_EnvironmentsListBySubscription_593955;
          apiVersion: string; subscriptionId: string): Recallable =
  ## environmentsListBySubscription
  ## Lists all the available environments within a subscription, irrespective of the resource groups.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_593976 = newJObject()
  var query_593977 = newJObject()
  add(query_593977, "api-version", newJString(apiVersion))
  add(path_593976, "subscriptionId", newJString(subscriptionId))
  result = call_593975.call(path_593976, query_593977, nil, nil, nil)

var environmentsListBySubscription* = Call_EnvironmentsListBySubscription_593955(
    name: "environmentsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.TimeSeriesInsights/environments",
    validator: validate_EnvironmentsListBySubscription_593956, base: "",
    url: url_EnvironmentsListBySubscription_593957, schemes: {Scheme.Https})
type
  Call_EnvironmentsListByResourceGroup_593978 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsListByResourceGroup_593980(protocol: Scheme; host: string;
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

proc validate_EnvironmentsListByResourceGroup_593979(path: JsonNode;
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
  var valid_593981 = path.getOrDefault("resourceGroupName")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "resourceGroupName", valid_593981
  var valid_593982 = path.getOrDefault("subscriptionId")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "subscriptionId", valid_593982
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593983 = query.getOrDefault("api-version")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "api-version", valid_593983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593984: Call_EnvironmentsListByResourceGroup_593978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the available environments associated with the subscription and within the specified resource group.
  ## 
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_EnvironmentsListByResourceGroup_593978;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## environmentsListByResourceGroup
  ## Lists all the available environments associated with the subscription and within the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_593986 = newJObject()
  var query_593987 = newJObject()
  add(path_593986, "resourceGroupName", newJString(resourceGroupName))
  add(query_593987, "api-version", newJString(apiVersion))
  add(path_593986, "subscriptionId", newJString(subscriptionId))
  result = call_593985.call(path_593986, query_593987, nil, nil, nil)

var environmentsListByResourceGroup* = Call_EnvironmentsListByResourceGroup_593978(
    name: "environmentsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments",
    validator: validate_EnvironmentsListByResourceGroup_593979, base: "",
    url: url_EnvironmentsListByResourceGroup_593980, schemes: {Scheme.Https})
type
  Call_EnvironmentsCreateOrUpdate_594001 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsCreateOrUpdate_594003(protocol: Scheme; host: string;
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

proc validate_EnvironmentsCreateOrUpdate_594002(path: JsonNode; query: JsonNode;
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
  var valid_594021 = path.getOrDefault("resourceGroupName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "resourceGroupName", valid_594021
  var valid_594022 = path.getOrDefault("subscriptionId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "subscriptionId", valid_594022
  var valid_594023 = path.getOrDefault("environmentName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "environmentName", valid_594023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594024 = query.getOrDefault("api-version")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "api-version", valid_594024
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

proc call*(call_594026: Call_EnvironmentsCreateOrUpdate_594001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an environment in the specified subscription and resource group.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_EnvironmentsCreateOrUpdate_594001;
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
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  var body_594030 = newJObject()
  add(path_594028, "resourceGroupName", newJString(resourceGroupName))
  add(query_594029, "api-version", newJString(apiVersion))
  add(path_594028, "subscriptionId", newJString(subscriptionId))
  add(path_594028, "environmentName", newJString(environmentName))
  if parameters != nil:
    body_594030 = parameters
  result = call_594027.call(path_594028, query_594029, nil, nil, body_594030)

var environmentsCreateOrUpdate* = Call_EnvironmentsCreateOrUpdate_594001(
    name: "environmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsCreateOrUpdate_594002, base: "",
    url: url_EnvironmentsCreateOrUpdate_594003, schemes: {Scheme.Https})
type
  Call_EnvironmentsGet_593988 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsGet_593990(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsGet_593989(path: JsonNode; query: JsonNode;
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
  var valid_593992 = path.getOrDefault("resourceGroupName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "resourceGroupName", valid_593992
  var valid_593993 = path.getOrDefault("subscriptionId")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "subscriptionId", valid_593993
  var valid_593994 = path.getOrDefault("environmentName")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "environmentName", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Setting $expand=status will include the status of the internal services of the environment in the Time Series Insights service.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  var valid_593995 = query.getOrDefault("$expand")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "$expand", valid_593995
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593996 = query.getOrDefault("api-version")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "api-version", valid_593996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593997: Call_EnvironmentsGet_593988; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the environment with the specified name in the specified subscription and resource group.
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_EnvironmentsGet_593988; resourceGroupName: string;
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
  var path_593999 = newJObject()
  var query_594000 = newJObject()
  add(path_593999, "resourceGroupName", newJString(resourceGroupName))
  add(query_594000, "$expand", newJString(Expand))
  add(query_594000, "api-version", newJString(apiVersion))
  add(path_593999, "subscriptionId", newJString(subscriptionId))
  add(path_593999, "environmentName", newJString(environmentName))
  result = call_593998.call(path_593999, query_594000, nil, nil, nil)

var environmentsGet* = Call_EnvironmentsGet_593988(name: "environmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsGet_593989, base: "", url: url_EnvironmentsGet_593990,
    schemes: {Scheme.Https})
type
  Call_EnvironmentsUpdate_594042 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsUpdate_594044(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsUpdate_594043(path: JsonNode; query: JsonNode;
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
  var valid_594045 = path.getOrDefault("resourceGroupName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "resourceGroupName", valid_594045
  var valid_594046 = path.getOrDefault("subscriptionId")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "subscriptionId", valid_594046
  var valid_594047 = path.getOrDefault("environmentName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "environmentName", valid_594047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594048 = query.getOrDefault("api-version")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "api-version", valid_594048
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

proc call*(call_594050: Call_EnvironmentsUpdate_594042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the environment with the specified name in the specified subscription and resource group.
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_EnvironmentsUpdate_594042; resourceGroupName: string;
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
  var path_594052 = newJObject()
  var query_594053 = newJObject()
  var body_594054 = newJObject()
  add(path_594052, "resourceGroupName", newJString(resourceGroupName))
  add(query_594053, "api-version", newJString(apiVersion))
  if environmentUpdateParameters != nil:
    body_594054 = environmentUpdateParameters
  add(path_594052, "subscriptionId", newJString(subscriptionId))
  add(path_594052, "environmentName", newJString(environmentName))
  result = call_594051.call(path_594052, query_594053, nil, nil, body_594054)

var environmentsUpdate* = Call_EnvironmentsUpdate_594042(
    name: "environmentsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsUpdate_594043, base: "",
    url: url_EnvironmentsUpdate_594044, schemes: {Scheme.Https})
type
  Call_EnvironmentsDelete_594031 = ref object of OpenApiRestCall_593437
proc url_EnvironmentsDelete_594033(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsDelete_594032(path: JsonNode; query: JsonNode;
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
  var valid_594034 = path.getOrDefault("resourceGroupName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "resourceGroupName", valid_594034
  var valid_594035 = path.getOrDefault("subscriptionId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "subscriptionId", valid_594035
  var valid_594036 = path.getOrDefault("environmentName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "environmentName", valid_594036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594037 = query.getOrDefault("api-version")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "api-version", valid_594037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594038: Call_EnvironmentsDelete_594031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the environment with the specified name in the specified subscription and resource group.
  ## 
  let valid = call_594038.validator(path, query, header, formData, body)
  let scheme = call_594038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594038.url(scheme.get, call_594038.host, call_594038.base,
                         call_594038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594038, url, valid)

proc call*(call_594039: Call_EnvironmentsDelete_594031; resourceGroupName: string;
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
  var path_594040 = newJObject()
  var query_594041 = newJObject()
  add(path_594040, "resourceGroupName", newJString(resourceGroupName))
  add(query_594041, "api-version", newJString(apiVersion))
  add(path_594040, "subscriptionId", newJString(subscriptionId))
  add(path_594040, "environmentName", newJString(environmentName))
  result = call_594039.call(path_594040, query_594041, nil, nil, nil)

var environmentsDelete* = Call_EnvironmentsDelete_594031(
    name: "environmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}",
    validator: validate_EnvironmentsDelete_594032, base: "",
    url: url_EnvironmentsDelete_594033, schemes: {Scheme.Https})
type
  Call_AccessPoliciesListByEnvironment_594055 = ref object of OpenApiRestCall_593437
proc url_AccessPoliciesListByEnvironment_594057(protocol: Scheme; host: string;
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

proc validate_AccessPoliciesListByEnvironment_594056(path: JsonNode;
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
  var valid_594058 = path.getOrDefault("resourceGroupName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "resourceGroupName", valid_594058
  var valid_594059 = path.getOrDefault("subscriptionId")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "subscriptionId", valid_594059
  var valid_594060 = path.getOrDefault("environmentName")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "environmentName", valid_594060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594061 = query.getOrDefault("api-version")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "api-version", valid_594061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594062: Call_AccessPoliciesListByEnvironment_594055;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the available access policies associated with the environment.
  ## 
  let valid = call_594062.validator(path, query, header, formData, body)
  let scheme = call_594062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594062.url(scheme.get, call_594062.host, call_594062.base,
                         call_594062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594062, url, valid)

proc call*(call_594063: Call_AccessPoliciesListByEnvironment_594055;
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
  var path_594064 = newJObject()
  var query_594065 = newJObject()
  add(path_594064, "resourceGroupName", newJString(resourceGroupName))
  add(query_594065, "api-version", newJString(apiVersion))
  add(path_594064, "subscriptionId", newJString(subscriptionId))
  add(path_594064, "environmentName", newJString(environmentName))
  result = call_594063.call(path_594064, query_594065, nil, nil, nil)

var accessPoliciesListByEnvironment* = Call_AccessPoliciesListByEnvironment_594055(
    name: "accessPoliciesListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies",
    validator: validate_AccessPoliciesListByEnvironment_594056, base: "",
    url: url_AccessPoliciesListByEnvironment_594057, schemes: {Scheme.Https})
type
  Call_AccessPoliciesCreateOrUpdate_594078 = ref object of OpenApiRestCall_593437
proc url_AccessPoliciesCreateOrUpdate_594080(protocol: Scheme; host: string;
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

proc validate_AccessPoliciesCreateOrUpdate_594079(path: JsonNode; query: JsonNode;
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
  var valid_594081 = path.getOrDefault("resourceGroupName")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "resourceGroupName", valid_594081
  var valid_594082 = path.getOrDefault("subscriptionId")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "subscriptionId", valid_594082
  var valid_594083 = path.getOrDefault("environmentName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "environmentName", valid_594083
  var valid_594084 = path.getOrDefault("accessPolicyName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "accessPolicyName", valid_594084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594085 = query.getOrDefault("api-version")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "api-version", valid_594085
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

proc call*(call_594087: Call_AccessPoliciesCreateOrUpdate_594078; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an access policy in the specified environment.
  ## 
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_AccessPoliciesCreateOrUpdate_594078;
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
  var path_594089 = newJObject()
  var query_594090 = newJObject()
  var body_594091 = newJObject()
  add(path_594089, "resourceGroupName", newJString(resourceGroupName))
  add(query_594090, "api-version", newJString(apiVersion))
  add(path_594089, "subscriptionId", newJString(subscriptionId))
  add(path_594089, "environmentName", newJString(environmentName))
  if parameters != nil:
    body_594091 = parameters
  add(path_594089, "accessPolicyName", newJString(accessPolicyName))
  result = call_594088.call(path_594089, query_594090, nil, nil, body_594091)

var accessPoliciesCreateOrUpdate* = Call_AccessPoliciesCreateOrUpdate_594078(
    name: "accessPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesCreateOrUpdate_594079, base: "",
    url: url_AccessPoliciesCreateOrUpdate_594080, schemes: {Scheme.Https})
type
  Call_AccessPoliciesGet_594066 = ref object of OpenApiRestCall_593437
proc url_AccessPoliciesGet_594068(protocol: Scheme; host: string; base: string;
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

proc validate_AccessPoliciesGet_594067(path: JsonNode; query: JsonNode;
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
  var valid_594069 = path.getOrDefault("resourceGroupName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "resourceGroupName", valid_594069
  var valid_594070 = path.getOrDefault("subscriptionId")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "subscriptionId", valid_594070
  var valid_594071 = path.getOrDefault("environmentName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "environmentName", valid_594071
  var valid_594072 = path.getOrDefault("accessPolicyName")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "accessPolicyName", valid_594072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594073 = query.getOrDefault("api-version")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "api-version", valid_594073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594074: Call_AccessPoliciesGet_594066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access policy with the specified name in the specified environment.
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_AccessPoliciesGet_594066; resourceGroupName: string;
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
  var path_594076 = newJObject()
  var query_594077 = newJObject()
  add(path_594076, "resourceGroupName", newJString(resourceGroupName))
  add(query_594077, "api-version", newJString(apiVersion))
  add(path_594076, "subscriptionId", newJString(subscriptionId))
  add(path_594076, "environmentName", newJString(environmentName))
  add(path_594076, "accessPolicyName", newJString(accessPolicyName))
  result = call_594075.call(path_594076, query_594077, nil, nil, nil)

var accessPoliciesGet* = Call_AccessPoliciesGet_594066(name: "accessPoliciesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesGet_594067, base: "",
    url: url_AccessPoliciesGet_594068, schemes: {Scheme.Https})
type
  Call_AccessPoliciesUpdate_594104 = ref object of OpenApiRestCall_593437
proc url_AccessPoliciesUpdate_594106(protocol: Scheme; host: string; base: string;
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

proc validate_AccessPoliciesUpdate_594105(path: JsonNode; query: JsonNode;
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
  var valid_594107 = path.getOrDefault("resourceGroupName")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "resourceGroupName", valid_594107
  var valid_594108 = path.getOrDefault("subscriptionId")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "subscriptionId", valid_594108
  var valid_594109 = path.getOrDefault("environmentName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "environmentName", valid_594109
  var valid_594110 = path.getOrDefault("accessPolicyName")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "accessPolicyName", valid_594110
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594111 = query.getOrDefault("api-version")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "api-version", valid_594111
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

proc call*(call_594113: Call_AccessPoliciesUpdate_594104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the access policy with the specified name in the specified subscription, resource group, and environment.
  ## 
  let valid = call_594113.validator(path, query, header, formData, body)
  let scheme = call_594113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594113.url(scheme.get, call_594113.host, call_594113.base,
                         call_594113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594113, url, valid)

proc call*(call_594114: Call_AccessPoliciesUpdate_594104;
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
  var path_594115 = newJObject()
  var query_594116 = newJObject()
  var body_594117 = newJObject()
  add(path_594115, "resourceGroupName", newJString(resourceGroupName))
  add(query_594116, "api-version", newJString(apiVersion))
  add(path_594115, "subscriptionId", newJString(subscriptionId))
  if accessPolicyUpdateParameters != nil:
    body_594117 = accessPolicyUpdateParameters
  add(path_594115, "environmentName", newJString(environmentName))
  add(path_594115, "accessPolicyName", newJString(accessPolicyName))
  result = call_594114.call(path_594115, query_594116, nil, nil, body_594117)

var accessPoliciesUpdate* = Call_AccessPoliciesUpdate_594104(
    name: "accessPoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesUpdate_594105, base: "",
    url: url_AccessPoliciesUpdate_594106, schemes: {Scheme.Https})
type
  Call_AccessPoliciesDelete_594092 = ref object of OpenApiRestCall_593437
proc url_AccessPoliciesDelete_594094(protocol: Scheme; host: string; base: string;
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

proc validate_AccessPoliciesDelete_594093(path: JsonNode; query: JsonNode;
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
  var valid_594095 = path.getOrDefault("resourceGroupName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "resourceGroupName", valid_594095
  var valid_594096 = path.getOrDefault("subscriptionId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "subscriptionId", valid_594096
  var valid_594097 = path.getOrDefault("environmentName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "environmentName", valid_594097
  var valid_594098 = path.getOrDefault("accessPolicyName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "accessPolicyName", valid_594098
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594099 = query.getOrDefault("api-version")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "api-version", valid_594099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594100: Call_AccessPoliciesDelete_594092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the access policy with the specified name in the specified subscription, resource group, and environment
  ## 
  let valid = call_594100.validator(path, query, header, formData, body)
  let scheme = call_594100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594100.url(scheme.get, call_594100.host, call_594100.base,
                         call_594100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594100, url, valid)

proc call*(call_594101: Call_AccessPoliciesDelete_594092;
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
  var path_594102 = newJObject()
  var query_594103 = newJObject()
  add(path_594102, "resourceGroupName", newJString(resourceGroupName))
  add(query_594103, "api-version", newJString(apiVersion))
  add(path_594102, "subscriptionId", newJString(subscriptionId))
  add(path_594102, "environmentName", newJString(environmentName))
  add(path_594102, "accessPolicyName", newJString(accessPolicyName))
  result = call_594101.call(path_594102, query_594103, nil, nil, nil)

var accessPoliciesDelete* = Call_AccessPoliciesDelete_594092(
    name: "accessPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/accessPolicies/{accessPolicyName}",
    validator: validate_AccessPoliciesDelete_594093, base: "",
    url: url_AccessPoliciesDelete_594094, schemes: {Scheme.Https})
type
  Call_EventSourcesListByEnvironment_594118 = ref object of OpenApiRestCall_593437
proc url_EventSourcesListByEnvironment_594120(protocol: Scheme; host: string;
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

proc validate_EventSourcesListByEnvironment_594119(path: JsonNode; query: JsonNode;
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
  var valid_594121 = path.getOrDefault("resourceGroupName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "resourceGroupName", valid_594121
  var valid_594122 = path.getOrDefault("subscriptionId")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "subscriptionId", valid_594122
  var valid_594123 = path.getOrDefault("environmentName")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "environmentName", valid_594123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594124 = query.getOrDefault("api-version")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "api-version", valid_594124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594125: Call_EventSourcesListByEnvironment_594118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available event sources associated with the subscription and within the specified resource group and environment.
  ## 
  let valid = call_594125.validator(path, query, header, formData, body)
  let scheme = call_594125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594125.url(scheme.get, call_594125.host, call_594125.base,
                         call_594125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594125, url, valid)

proc call*(call_594126: Call_EventSourcesListByEnvironment_594118;
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
  var path_594127 = newJObject()
  var query_594128 = newJObject()
  add(path_594127, "resourceGroupName", newJString(resourceGroupName))
  add(query_594128, "api-version", newJString(apiVersion))
  add(path_594127, "subscriptionId", newJString(subscriptionId))
  add(path_594127, "environmentName", newJString(environmentName))
  result = call_594126.call(path_594127, query_594128, nil, nil, nil)

var eventSourcesListByEnvironment* = Call_EventSourcesListByEnvironment_594118(
    name: "eventSourcesListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources",
    validator: validate_EventSourcesListByEnvironment_594119, base: "",
    url: url_EventSourcesListByEnvironment_594120, schemes: {Scheme.Https})
type
  Call_EventSourcesCreateOrUpdate_594141 = ref object of OpenApiRestCall_593437
proc url_EventSourcesCreateOrUpdate_594143(protocol: Scheme; host: string;
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

proc validate_EventSourcesCreateOrUpdate_594142(path: JsonNode; query: JsonNode;
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
  var valid_594144 = path.getOrDefault("resourceGroupName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "resourceGroupName", valid_594144
  var valid_594145 = path.getOrDefault("eventSourceName")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "eventSourceName", valid_594145
  var valid_594146 = path.getOrDefault("subscriptionId")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "subscriptionId", valid_594146
  var valid_594147 = path.getOrDefault("environmentName")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "environmentName", valid_594147
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594148 = query.getOrDefault("api-version")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "api-version", valid_594148
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

proc call*(call_594150: Call_EventSourcesCreateOrUpdate_594141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an event source under the specified environment.
  ## 
  let valid = call_594150.validator(path, query, header, formData, body)
  let scheme = call_594150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594150.url(scheme.get, call_594150.host, call_594150.base,
                         call_594150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594150, url, valid)

proc call*(call_594151: Call_EventSourcesCreateOrUpdate_594141;
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
  var path_594152 = newJObject()
  var query_594153 = newJObject()
  var body_594154 = newJObject()
  add(path_594152, "resourceGroupName", newJString(resourceGroupName))
  add(query_594153, "api-version", newJString(apiVersion))
  add(path_594152, "eventSourceName", newJString(eventSourceName))
  add(path_594152, "subscriptionId", newJString(subscriptionId))
  add(path_594152, "environmentName", newJString(environmentName))
  if parameters != nil:
    body_594154 = parameters
  result = call_594151.call(path_594152, query_594153, nil, nil, body_594154)

var eventSourcesCreateOrUpdate* = Call_EventSourcesCreateOrUpdate_594141(
    name: "eventSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesCreateOrUpdate_594142, base: "",
    url: url_EventSourcesCreateOrUpdate_594143, schemes: {Scheme.Https})
type
  Call_EventSourcesGet_594129 = ref object of OpenApiRestCall_593437
proc url_EventSourcesGet_594131(protocol: Scheme; host: string; base: string;
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

proc validate_EventSourcesGet_594130(path: JsonNode; query: JsonNode;
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
  var valid_594132 = path.getOrDefault("resourceGroupName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "resourceGroupName", valid_594132
  var valid_594133 = path.getOrDefault("eventSourceName")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "eventSourceName", valid_594133
  var valid_594134 = path.getOrDefault("subscriptionId")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "subscriptionId", valid_594134
  var valid_594135 = path.getOrDefault("environmentName")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "environmentName", valid_594135
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594136 = query.getOrDefault("api-version")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "api-version", valid_594136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594137: Call_EventSourcesGet_594129; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the event source with the specified name in the specified environment.
  ## 
  let valid = call_594137.validator(path, query, header, formData, body)
  let scheme = call_594137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594137.url(scheme.get, call_594137.host, call_594137.base,
                         call_594137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594137, url, valid)

proc call*(call_594138: Call_EventSourcesGet_594129; resourceGroupName: string;
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
  var path_594139 = newJObject()
  var query_594140 = newJObject()
  add(path_594139, "resourceGroupName", newJString(resourceGroupName))
  add(query_594140, "api-version", newJString(apiVersion))
  add(path_594139, "eventSourceName", newJString(eventSourceName))
  add(path_594139, "subscriptionId", newJString(subscriptionId))
  add(path_594139, "environmentName", newJString(environmentName))
  result = call_594138.call(path_594139, query_594140, nil, nil, nil)

var eventSourcesGet* = Call_EventSourcesGet_594129(name: "eventSourcesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesGet_594130, base: "", url: url_EventSourcesGet_594131,
    schemes: {Scheme.Https})
type
  Call_EventSourcesUpdate_594167 = ref object of OpenApiRestCall_593437
proc url_EventSourcesUpdate_594169(protocol: Scheme; host: string; base: string;
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

proc validate_EventSourcesUpdate_594168(path: JsonNode; query: JsonNode;
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
  var valid_594170 = path.getOrDefault("resourceGroupName")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "resourceGroupName", valid_594170
  var valid_594171 = path.getOrDefault("eventSourceName")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "eventSourceName", valid_594171
  var valid_594172 = path.getOrDefault("subscriptionId")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "subscriptionId", valid_594172
  var valid_594173 = path.getOrDefault("environmentName")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "environmentName", valid_594173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594174 = query.getOrDefault("api-version")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "api-version", valid_594174
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

proc call*(call_594176: Call_EventSourcesUpdate_594167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the event source with the specified name in the specified subscription, resource group, and environment.
  ## 
  let valid = call_594176.validator(path, query, header, formData, body)
  let scheme = call_594176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594176.url(scheme.get, call_594176.host, call_594176.base,
                         call_594176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594176, url, valid)

proc call*(call_594177: Call_EventSourcesUpdate_594167; resourceGroupName: string;
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
  var path_594178 = newJObject()
  var query_594179 = newJObject()
  var body_594180 = newJObject()
  add(path_594178, "resourceGroupName", newJString(resourceGroupName))
  add(query_594179, "api-version", newJString(apiVersion))
  add(path_594178, "eventSourceName", newJString(eventSourceName))
  add(path_594178, "subscriptionId", newJString(subscriptionId))
  if eventSourceUpdateParameters != nil:
    body_594180 = eventSourceUpdateParameters
  add(path_594178, "environmentName", newJString(environmentName))
  result = call_594177.call(path_594178, query_594179, nil, nil, body_594180)

var eventSourcesUpdate* = Call_EventSourcesUpdate_594167(
    name: "eventSourcesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesUpdate_594168, base: "",
    url: url_EventSourcesUpdate_594169, schemes: {Scheme.Https})
type
  Call_EventSourcesDelete_594155 = ref object of OpenApiRestCall_593437
proc url_EventSourcesDelete_594157(protocol: Scheme; host: string; base: string;
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

proc validate_EventSourcesDelete_594156(path: JsonNode; query: JsonNode;
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
  var valid_594158 = path.getOrDefault("resourceGroupName")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "resourceGroupName", valid_594158
  var valid_594159 = path.getOrDefault("eventSourceName")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "eventSourceName", valid_594159
  var valid_594160 = path.getOrDefault("subscriptionId")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "subscriptionId", valid_594160
  var valid_594161 = path.getOrDefault("environmentName")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "environmentName", valid_594161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594162 = query.getOrDefault("api-version")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "api-version", valid_594162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594163: Call_EventSourcesDelete_594155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the event source with the specified name in the specified subscription, resource group, and environment
  ## 
  let valid = call_594163.validator(path, query, header, formData, body)
  let scheme = call_594163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594163.url(scheme.get, call_594163.host, call_594163.base,
                         call_594163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594163, url, valid)

proc call*(call_594164: Call_EventSourcesDelete_594155; resourceGroupName: string;
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
  var path_594165 = newJObject()
  var query_594166 = newJObject()
  add(path_594165, "resourceGroupName", newJString(resourceGroupName))
  add(query_594166, "api-version", newJString(apiVersion))
  add(path_594165, "eventSourceName", newJString(eventSourceName))
  add(path_594165, "subscriptionId", newJString(subscriptionId))
  add(path_594165, "environmentName", newJString(environmentName))
  result = call_594164.call(path_594165, query_594166, nil, nil, nil)

var eventSourcesDelete* = Call_EventSourcesDelete_594155(
    name: "eventSourcesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/eventSources/{eventSourceName}",
    validator: validate_EventSourcesDelete_594156, base: "",
    url: url_EventSourcesDelete_594157, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsListByEnvironment_594181 = ref object of OpenApiRestCall_593437
proc url_ReferenceDataSetsListByEnvironment_594183(protocol: Scheme; host: string;
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

proc validate_ReferenceDataSetsListByEnvironment_594182(path: JsonNode;
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
  var valid_594184 = path.getOrDefault("resourceGroupName")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "resourceGroupName", valid_594184
  var valid_594185 = path.getOrDefault("subscriptionId")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "subscriptionId", valid_594185
  var valid_594186 = path.getOrDefault("environmentName")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "environmentName", valid_594186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594187 = query.getOrDefault("api-version")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "api-version", valid_594187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594188: Call_ReferenceDataSetsListByEnvironment_594181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the available reference data sets associated with the subscription and within the specified resource group and environment.
  ## 
  let valid = call_594188.validator(path, query, header, formData, body)
  let scheme = call_594188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594188.url(scheme.get, call_594188.host, call_594188.base,
                         call_594188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594188, url, valid)

proc call*(call_594189: Call_ReferenceDataSetsListByEnvironment_594181;
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
  var path_594190 = newJObject()
  var query_594191 = newJObject()
  add(path_594190, "resourceGroupName", newJString(resourceGroupName))
  add(query_594191, "api-version", newJString(apiVersion))
  add(path_594190, "subscriptionId", newJString(subscriptionId))
  add(path_594190, "environmentName", newJString(environmentName))
  result = call_594189.call(path_594190, query_594191, nil, nil, nil)

var referenceDataSetsListByEnvironment* = Call_ReferenceDataSetsListByEnvironment_594181(
    name: "referenceDataSetsListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets",
    validator: validate_ReferenceDataSetsListByEnvironment_594182, base: "",
    url: url_ReferenceDataSetsListByEnvironment_594183, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsCreateOrUpdate_594204 = ref object of OpenApiRestCall_593437
proc url_ReferenceDataSetsCreateOrUpdate_594206(protocol: Scheme; host: string;
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

proc validate_ReferenceDataSetsCreateOrUpdate_594205(path: JsonNode;
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
  var valid_594207 = path.getOrDefault("resourceGroupName")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "resourceGroupName", valid_594207
  var valid_594208 = path.getOrDefault("subscriptionId")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "subscriptionId", valid_594208
  var valid_594209 = path.getOrDefault("referenceDataSetName")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "referenceDataSetName", valid_594209
  var valid_594210 = path.getOrDefault("environmentName")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "environmentName", valid_594210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594211 = query.getOrDefault("api-version")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "api-version", valid_594211
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

proc call*(call_594213: Call_ReferenceDataSetsCreateOrUpdate_594204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a reference data set in the specified environment.
  ## 
  let valid = call_594213.validator(path, query, header, formData, body)
  let scheme = call_594213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594213.url(scheme.get, call_594213.host, call_594213.base,
                         call_594213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594213, url, valid)

proc call*(call_594214: Call_ReferenceDataSetsCreateOrUpdate_594204;
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
  var path_594215 = newJObject()
  var query_594216 = newJObject()
  var body_594217 = newJObject()
  add(path_594215, "resourceGroupName", newJString(resourceGroupName))
  add(query_594216, "api-version", newJString(apiVersion))
  add(path_594215, "subscriptionId", newJString(subscriptionId))
  add(path_594215, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_594215, "environmentName", newJString(environmentName))
  if parameters != nil:
    body_594217 = parameters
  result = call_594214.call(path_594215, query_594216, nil, nil, body_594217)

var referenceDataSetsCreateOrUpdate* = Call_ReferenceDataSetsCreateOrUpdate_594204(
    name: "referenceDataSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsCreateOrUpdate_594205, base: "",
    url: url_ReferenceDataSetsCreateOrUpdate_594206, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsGet_594192 = ref object of OpenApiRestCall_593437
proc url_ReferenceDataSetsGet_594194(protocol: Scheme; host: string; base: string;
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

proc validate_ReferenceDataSetsGet_594193(path: JsonNode; query: JsonNode;
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
  var valid_594195 = path.getOrDefault("resourceGroupName")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "resourceGroupName", valid_594195
  var valid_594196 = path.getOrDefault("subscriptionId")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "subscriptionId", valid_594196
  var valid_594197 = path.getOrDefault("referenceDataSetName")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "referenceDataSetName", valid_594197
  var valid_594198 = path.getOrDefault("environmentName")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "environmentName", valid_594198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594199 = query.getOrDefault("api-version")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "api-version", valid_594199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594200: Call_ReferenceDataSetsGet_594192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the reference data set with the specified name in the specified environment.
  ## 
  let valid = call_594200.validator(path, query, header, formData, body)
  let scheme = call_594200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594200.url(scheme.get, call_594200.host, call_594200.base,
                         call_594200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594200, url, valid)

proc call*(call_594201: Call_ReferenceDataSetsGet_594192;
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
  var path_594202 = newJObject()
  var query_594203 = newJObject()
  add(path_594202, "resourceGroupName", newJString(resourceGroupName))
  add(query_594203, "api-version", newJString(apiVersion))
  add(path_594202, "subscriptionId", newJString(subscriptionId))
  add(path_594202, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_594202, "environmentName", newJString(environmentName))
  result = call_594201.call(path_594202, query_594203, nil, nil, nil)

var referenceDataSetsGet* = Call_ReferenceDataSetsGet_594192(
    name: "referenceDataSetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsGet_594193, base: "",
    url: url_ReferenceDataSetsGet_594194, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsUpdate_594230 = ref object of OpenApiRestCall_593437
proc url_ReferenceDataSetsUpdate_594232(protocol: Scheme; host: string; base: string;
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

proc validate_ReferenceDataSetsUpdate_594231(path: JsonNode; query: JsonNode;
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
  var valid_594233 = path.getOrDefault("resourceGroupName")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "resourceGroupName", valid_594233
  var valid_594234 = path.getOrDefault("subscriptionId")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "subscriptionId", valid_594234
  var valid_594235 = path.getOrDefault("referenceDataSetName")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "referenceDataSetName", valid_594235
  var valid_594236 = path.getOrDefault("environmentName")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "environmentName", valid_594236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594237 = query.getOrDefault("api-version")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "api-version", valid_594237
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

proc call*(call_594239: Call_ReferenceDataSetsUpdate_594230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the reference data set with the specified name in the specified subscription, resource group, and environment.
  ## 
  let valid = call_594239.validator(path, query, header, formData, body)
  let scheme = call_594239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594239.url(scheme.get, call_594239.host, call_594239.base,
                         call_594239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594239, url, valid)

proc call*(call_594240: Call_ReferenceDataSetsUpdate_594230;
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
  var path_594241 = newJObject()
  var query_594242 = newJObject()
  var body_594243 = newJObject()
  add(path_594241, "resourceGroupName", newJString(resourceGroupName))
  add(query_594242, "api-version", newJString(apiVersion))
  add(path_594241, "subscriptionId", newJString(subscriptionId))
  add(path_594241, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_594241, "environmentName", newJString(environmentName))
  if referenceDataSetUpdateParameters != nil:
    body_594243 = referenceDataSetUpdateParameters
  result = call_594240.call(path_594241, query_594242, nil, nil, body_594243)

var referenceDataSetsUpdate* = Call_ReferenceDataSetsUpdate_594230(
    name: "referenceDataSetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsUpdate_594231, base: "",
    url: url_ReferenceDataSetsUpdate_594232, schemes: {Scheme.Https})
type
  Call_ReferenceDataSetsDelete_594218 = ref object of OpenApiRestCall_593437
proc url_ReferenceDataSetsDelete_594220(protocol: Scheme; host: string; base: string;
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

proc validate_ReferenceDataSetsDelete_594219(path: JsonNode; query: JsonNode;
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
  var valid_594221 = path.getOrDefault("resourceGroupName")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "resourceGroupName", valid_594221
  var valid_594222 = path.getOrDefault("subscriptionId")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "subscriptionId", valid_594222
  var valid_594223 = path.getOrDefault("referenceDataSetName")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "referenceDataSetName", valid_594223
  var valid_594224 = path.getOrDefault("environmentName")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "environmentName", valid_594224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594225 = query.getOrDefault("api-version")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "api-version", valid_594225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594226: Call_ReferenceDataSetsDelete_594218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the reference data set with the specified name in the specified subscription, resource group, and environment
  ## 
  let valid = call_594226.validator(path, query, header, formData, body)
  let scheme = call_594226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594226.url(scheme.get, call_594226.host, call_594226.base,
                         call_594226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594226, url, valid)

proc call*(call_594227: Call_ReferenceDataSetsDelete_594218;
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
  var path_594228 = newJObject()
  var query_594229 = newJObject()
  add(path_594228, "resourceGroupName", newJString(resourceGroupName))
  add(query_594229, "api-version", newJString(apiVersion))
  add(path_594228, "subscriptionId", newJString(subscriptionId))
  add(path_594228, "referenceDataSetName", newJString(referenceDataSetName))
  add(path_594228, "environmentName", newJString(environmentName))
  result = call_594227.call(path_594228, query_594229, nil, nil, nil)

var referenceDataSetsDelete* = Call_ReferenceDataSetsDelete_594218(
    name: "referenceDataSetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TimeSeriesInsights/environments/{environmentName}/referenceDataSets/{referenceDataSetName}",
    validator: validate_ReferenceDataSetsDelete_594219, base: "",
    url: url_ReferenceDataSetsDelete_594220, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
