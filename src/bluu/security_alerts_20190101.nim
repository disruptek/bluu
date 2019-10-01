
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2019-01-01
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

  OpenApiRestCall_567659 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567659](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567659): Option[Scheme] {.used.} =
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
  macServiceName = "security-alerts"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AlertsList_567881 = ref object of OpenApiRestCall_567659
proc url_AlertsList_567883(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsList_567882(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the alerts that are associated with the subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568057 = path.getOrDefault("subscriptionId")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "subscriptionId", valid_568057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $expand: JString
  ##          : OData expand. Optional.
  ##   $select: JString
  ##          : OData select. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568058 = query.getOrDefault("api-version")
  valid_568058 = validateParameter(valid_568058, JString, required = true,
                                 default = nil)
  if valid_568058 != nil:
    section.add "api-version", valid_568058
  var valid_568059 = query.getOrDefault("$expand")
  valid_568059 = validateParameter(valid_568059, JString, required = false,
                                 default = nil)
  if valid_568059 != nil:
    section.add "$expand", valid_568059
  var valid_568060 = query.getOrDefault("$select")
  valid_568060 = validateParameter(valid_568060, JString, required = false,
                                 default = nil)
  if valid_568060 != nil:
    section.add "$select", valid_568060
  var valid_568061 = query.getOrDefault("$filter")
  valid_568061 = validateParameter(valid_568061, JString, required = false,
                                 default = nil)
  if valid_568061 != nil:
    section.add "$filter", valid_568061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568084: Call_AlertsList_567881; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the alerts that are associated with the subscription
  ## 
  let valid = call_568084.validator(path, query, header, formData, body)
  let scheme = call_568084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568084.url(scheme.get, call_568084.host, call_568084.base,
                         call_568084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568084, url, valid)

proc call*(call_568155: Call_AlertsList_567881; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Select: string = "";
          Filter: string = ""): Recallable =
  ## alertsList
  ## List all the alerts that are associated with the subscription
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   Expand: string
  ##         : OData expand. Optional.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Select: string
  ##         : OData select. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568156 = newJObject()
  var query_568158 = newJObject()
  add(query_568158, "api-version", newJString(apiVersion))
  add(query_568158, "$expand", newJString(Expand))
  add(path_568156, "subscriptionId", newJString(subscriptionId))
  add(query_568158, "$select", newJString(Select))
  add(query_568158, "$filter", newJString(Filter))
  result = call_568155.call(path_568156, query_568158, nil, nil, nil)

var alertsList* = Call_AlertsList_567881(name: "alertsList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/alerts",
                                      validator: validate_AlertsList_567882,
                                      base: "", url: url_AlertsList_567883,
                                      schemes: {Scheme.Https})
type
  Call_AlertsListSubscriptionLevelAlertsByRegion_568197 = ref object of OpenApiRestCall_567659
proc url_AlertsListSubscriptionLevelAlertsByRegion_568199(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsListSubscriptionLevelAlertsByRegion_568198(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the alerts that are associated with the subscription that are stored in a specific location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_568200 = path.getOrDefault("ascLocation")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "ascLocation", valid_568200
  var valid_568201 = path.getOrDefault("subscriptionId")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "subscriptionId", valid_568201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $expand: JString
  ##          : OData expand. Optional.
  ##   $select: JString
  ##          : OData select. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568202 = query.getOrDefault("api-version")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "api-version", valid_568202
  var valid_568203 = query.getOrDefault("$expand")
  valid_568203 = validateParameter(valid_568203, JString, required = false,
                                 default = nil)
  if valid_568203 != nil:
    section.add "$expand", valid_568203
  var valid_568204 = query.getOrDefault("$select")
  valid_568204 = validateParameter(valid_568204, JString, required = false,
                                 default = nil)
  if valid_568204 != nil:
    section.add "$select", valid_568204
  var valid_568205 = query.getOrDefault("$filter")
  valid_568205 = validateParameter(valid_568205, JString, required = false,
                                 default = nil)
  if valid_568205 != nil:
    section.add "$filter", valid_568205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568206: Call_AlertsListSubscriptionLevelAlertsByRegion_568197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the alerts that are associated with the subscription that are stored in a specific location
  ## 
  let valid = call_568206.validator(path, query, header, formData, body)
  let scheme = call_568206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568206.url(scheme.get, call_568206.host, call_568206.base,
                         call_568206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568206, url, valid)

proc call*(call_568207: Call_AlertsListSubscriptionLevelAlertsByRegion_568197;
          apiVersion: string; ascLocation: string; subscriptionId: string;
          Expand: string = ""; Select: string = ""; Filter: string = ""): Recallable =
  ## alertsListSubscriptionLevelAlertsByRegion
  ## List all the alerts that are associated with the subscription that are stored in a specific location
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   Expand: string
  ##         : OData expand. Optional.
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Select: string
  ##         : OData select. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568208 = newJObject()
  var query_568209 = newJObject()
  add(query_568209, "api-version", newJString(apiVersion))
  add(query_568209, "$expand", newJString(Expand))
  add(path_568208, "ascLocation", newJString(ascLocation))
  add(path_568208, "subscriptionId", newJString(subscriptionId))
  add(query_568209, "$select", newJString(Select))
  add(query_568209, "$filter", newJString(Filter))
  result = call_568207.call(path_568208, query_568209, nil, nil, nil)

var alertsListSubscriptionLevelAlertsByRegion* = Call_AlertsListSubscriptionLevelAlertsByRegion_568197(
    name: "alertsListSubscriptionLevelAlertsByRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/alerts",
    validator: validate_AlertsListSubscriptionLevelAlertsByRegion_568198,
    base: "", url: url_AlertsListSubscriptionLevelAlertsByRegion_568199,
    schemes: {Scheme.Https})
type
  Call_AlertsGetSubscriptionLevelAlert_568210 = ref object of OpenApiRestCall_567659
proc url_AlertsGetSubscriptionLevelAlert_568212(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "alertName" in path, "`alertName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/alerts/"),
               (kind: VariableSegment, value: "alertName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGetSubscriptionLevelAlert_568211(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an alert that is associated with a subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   alertName: JString (required)
  ##            : Name of the alert object
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_568213 = path.getOrDefault("ascLocation")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "ascLocation", valid_568213
  var valid_568214 = path.getOrDefault("subscriptionId")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "subscriptionId", valid_568214
  var valid_568215 = path.getOrDefault("alertName")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "alertName", valid_568215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568216 = query.getOrDefault("api-version")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "api-version", valid_568216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568217: Call_AlertsGetSubscriptionLevelAlert_568210;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an alert that is associated with a subscription
  ## 
  let valid = call_568217.validator(path, query, header, formData, body)
  let scheme = call_568217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568217.url(scheme.get, call_568217.host, call_568217.base,
                         call_568217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568217, url, valid)

proc call*(call_568218: Call_AlertsGetSubscriptionLevelAlert_568210;
          apiVersion: string; ascLocation: string; subscriptionId: string;
          alertName: string): Recallable =
  ## alertsGetSubscriptionLevelAlert
  ## Get an alert that is associated with a subscription
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   alertName: string (required)
  ##            : Name of the alert object
  var path_568219 = newJObject()
  var query_568220 = newJObject()
  add(query_568220, "api-version", newJString(apiVersion))
  add(path_568219, "ascLocation", newJString(ascLocation))
  add(path_568219, "subscriptionId", newJString(subscriptionId))
  add(path_568219, "alertName", newJString(alertName))
  result = call_568218.call(path_568219, query_568220, nil, nil, nil)

var alertsGetSubscriptionLevelAlert* = Call_AlertsGetSubscriptionLevelAlert_568210(
    name: "alertsGetSubscriptionLevelAlert", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/alerts/{alertName}",
    validator: validate_AlertsGetSubscriptionLevelAlert_568211, base: "",
    url: url_AlertsGetSubscriptionLevelAlert_568212, schemes: {Scheme.Https})
type
  Call_AlertsUpdateSubscriptionLevelAlertState_568221 = ref object of OpenApiRestCall_567659
proc url_AlertsUpdateSubscriptionLevelAlertState_568223(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "alertName" in path, "`alertName` is a required path parameter"
  assert "alertUpdateActionType" in path,
        "`alertUpdateActionType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/alerts/"),
               (kind: VariableSegment, value: "alertName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "alertUpdateActionType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsUpdateSubscriptionLevelAlertState_568222(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the alert's state
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   alertUpdateActionType: JString (required)
  ##                        : Type of the action to do on the alert
  ##   alertName: JString (required)
  ##            : Name of the alert object
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_568224 = path.getOrDefault("ascLocation")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "ascLocation", valid_568224
  var valid_568225 = path.getOrDefault("subscriptionId")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "subscriptionId", valid_568225
  var valid_568239 = path.getOrDefault("alertUpdateActionType")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = newJString("Dismiss"))
  if valid_568239 != nil:
    section.add "alertUpdateActionType", valid_568239
  var valid_568240 = path.getOrDefault("alertName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "alertName", valid_568240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568241 = query.getOrDefault("api-version")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "api-version", valid_568241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568242: Call_AlertsUpdateSubscriptionLevelAlertState_568221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the alert's state
  ## 
  let valid = call_568242.validator(path, query, header, formData, body)
  let scheme = call_568242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568242.url(scheme.get, call_568242.host, call_568242.base,
                         call_568242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568242, url, valid)

proc call*(call_568243: Call_AlertsUpdateSubscriptionLevelAlertState_568221;
          apiVersion: string; ascLocation: string; subscriptionId: string;
          alertName: string; alertUpdateActionType: string = "Dismiss"): Recallable =
  ## alertsUpdateSubscriptionLevelAlertState
  ## Update the alert's state
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   alertUpdateActionType: string (required)
  ##                        : Type of the action to do on the alert
  ##   alertName: string (required)
  ##            : Name of the alert object
  var path_568244 = newJObject()
  var query_568245 = newJObject()
  add(query_568245, "api-version", newJString(apiVersion))
  add(path_568244, "ascLocation", newJString(ascLocation))
  add(path_568244, "subscriptionId", newJString(subscriptionId))
  add(path_568244, "alertUpdateActionType", newJString(alertUpdateActionType))
  add(path_568244, "alertName", newJString(alertName))
  result = call_568243.call(path_568244, query_568245, nil, nil, nil)

var alertsUpdateSubscriptionLevelAlertState* = Call_AlertsUpdateSubscriptionLevelAlertState_568221(
    name: "alertsUpdateSubscriptionLevelAlertState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/alerts/{alertName}/{alertUpdateActionType}",
    validator: validate_AlertsUpdateSubscriptionLevelAlertState_568222, base: "",
    url: url_AlertsUpdateSubscriptionLevelAlertState_568223,
    schemes: {Scheme.Https})
type
  Call_AlertsListByResourceGroup_568246 = ref object of OpenApiRestCall_567659
proc url_AlertsListByResourceGroup_568248(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Security/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsListByResourceGroup_568247(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the alerts that are associated with the resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568249 = path.getOrDefault("resourceGroupName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "resourceGroupName", valid_568249
  var valid_568250 = path.getOrDefault("subscriptionId")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "subscriptionId", valid_568250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $expand: JString
  ##          : OData expand. Optional.
  ##   $select: JString
  ##          : OData select. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568251 = query.getOrDefault("api-version")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "api-version", valid_568251
  var valid_568252 = query.getOrDefault("$expand")
  valid_568252 = validateParameter(valid_568252, JString, required = false,
                                 default = nil)
  if valid_568252 != nil:
    section.add "$expand", valid_568252
  var valid_568253 = query.getOrDefault("$select")
  valid_568253 = validateParameter(valid_568253, JString, required = false,
                                 default = nil)
  if valid_568253 != nil:
    section.add "$select", valid_568253
  var valid_568254 = query.getOrDefault("$filter")
  valid_568254 = validateParameter(valid_568254, JString, required = false,
                                 default = nil)
  if valid_568254 != nil:
    section.add "$filter", valid_568254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568255: Call_AlertsListByResourceGroup_568246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the alerts that are associated with the resource group
  ## 
  let valid = call_568255.validator(path, query, header, formData, body)
  let scheme = call_568255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568255.url(scheme.get, call_568255.host, call_568255.base,
                         call_568255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568255, url, valid)

proc call*(call_568256: Call_AlertsListByResourceGroup_568246;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Expand: string = ""; Select: string = ""; Filter: string = ""): Recallable =
  ## alertsListByResourceGroup
  ## List all the alerts that are associated with the resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   Expand: string
  ##         : OData expand. Optional.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Select: string
  ##         : OData select. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568257 = newJObject()
  var query_568258 = newJObject()
  add(path_568257, "resourceGroupName", newJString(resourceGroupName))
  add(query_568258, "api-version", newJString(apiVersion))
  add(query_568258, "$expand", newJString(Expand))
  add(path_568257, "subscriptionId", newJString(subscriptionId))
  add(query_568258, "$select", newJString(Select))
  add(query_568258, "$filter", newJString(Filter))
  result = call_568256.call(path_568257, query_568258, nil, nil, nil)

var alertsListByResourceGroup* = Call_AlertsListByResourceGroup_568246(
    name: "alertsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/alerts",
    validator: validate_AlertsListByResourceGroup_568247, base: "",
    url: url_AlertsListByResourceGroup_568248, schemes: {Scheme.Https})
type
  Call_AlertsListResourceGroupLevelAlertsByRegion_568259 = ref object of OpenApiRestCall_567659
proc url_AlertsListResourceGroupLevelAlertsByRegion_568261(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsListResourceGroupLevelAlertsByRegion_568260(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the alerts that are associated with the resource group that are stored in a specific location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568262 = path.getOrDefault("resourceGroupName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "resourceGroupName", valid_568262
  var valid_568263 = path.getOrDefault("ascLocation")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "ascLocation", valid_568263
  var valid_568264 = path.getOrDefault("subscriptionId")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "subscriptionId", valid_568264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $expand: JString
  ##          : OData expand. Optional.
  ##   $select: JString
  ##          : OData select. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568265 = query.getOrDefault("api-version")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "api-version", valid_568265
  var valid_568266 = query.getOrDefault("$expand")
  valid_568266 = validateParameter(valid_568266, JString, required = false,
                                 default = nil)
  if valid_568266 != nil:
    section.add "$expand", valid_568266
  var valid_568267 = query.getOrDefault("$select")
  valid_568267 = validateParameter(valid_568267, JString, required = false,
                                 default = nil)
  if valid_568267 != nil:
    section.add "$select", valid_568267
  var valid_568268 = query.getOrDefault("$filter")
  valid_568268 = validateParameter(valid_568268, JString, required = false,
                                 default = nil)
  if valid_568268 != nil:
    section.add "$filter", valid_568268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568269: Call_AlertsListResourceGroupLevelAlertsByRegion_568259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the alerts that are associated with the resource group that are stored in a specific location
  ## 
  let valid = call_568269.validator(path, query, header, formData, body)
  let scheme = call_568269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568269.url(scheme.get, call_568269.host, call_568269.base,
                         call_568269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568269, url, valid)

proc call*(call_568270: Call_AlertsListResourceGroupLevelAlertsByRegion_568259;
          resourceGroupName: string; apiVersion: string; ascLocation: string;
          subscriptionId: string; Expand: string = ""; Select: string = "";
          Filter: string = ""): Recallable =
  ## alertsListResourceGroupLevelAlertsByRegion
  ## List all the alerts that are associated with the resource group that are stored in a specific location
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   Expand: string
  ##         : OData expand. Optional.
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Select: string
  ##         : OData select. Optional.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568271 = newJObject()
  var query_568272 = newJObject()
  add(path_568271, "resourceGroupName", newJString(resourceGroupName))
  add(query_568272, "api-version", newJString(apiVersion))
  add(query_568272, "$expand", newJString(Expand))
  add(path_568271, "ascLocation", newJString(ascLocation))
  add(path_568271, "subscriptionId", newJString(subscriptionId))
  add(query_568272, "$select", newJString(Select))
  add(query_568272, "$filter", newJString(Filter))
  result = call_568270.call(path_568271, query_568272, nil, nil, nil)

var alertsListResourceGroupLevelAlertsByRegion* = Call_AlertsListResourceGroupLevelAlertsByRegion_568259(
    name: "alertsListResourceGroupLevelAlertsByRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/alerts",
    validator: validate_AlertsListResourceGroupLevelAlertsByRegion_568260,
    base: "", url: url_AlertsListResourceGroupLevelAlertsByRegion_568261,
    schemes: {Scheme.Https})
type
  Call_AlertsGetResourceGroupLevelAlerts_568273 = ref object of OpenApiRestCall_567659
proc url_AlertsGetResourceGroupLevelAlerts_568275(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "alertName" in path, "`alertName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/alerts/"),
               (kind: VariableSegment, value: "alertName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGetResourceGroupLevelAlerts_568274(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an alert that is associated a resource group or a resource in a resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   alertName: JString (required)
  ##            : Name of the alert object
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568276 = path.getOrDefault("resourceGroupName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "resourceGroupName", valid_568276
  var valid_568277 = path.getOrDefault("ascLocation")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "ascLocation", valid_568277
  var valid_568278 = path.getOrDefault("subscriptionId")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "subscriptionId", valid_568278
  var valid_568279 = path.getOrDefault("alertName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "alertName", valid_568279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568280 = query.getOrDefault("api-version")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "api-version", valid_568280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568281: Call_AlertsGetResourceGroupLevelAlerts_568273;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an alert that is associated a resource group or a resource in a resource group
  ## 
  let valid = call_568281.validator(path, query, header, formData, body)
  let scheme = call_568281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568281.url(scheme.get, call_568281.host, call_568281.base,
                         call_568281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568281, url, valid)

proc call*(call_568282: Call_AlertsGetResourceGroupLevelAlerts_568273;
          resourceGroupName: string; apiVersion: string; ascLocation: string;
          subscriptionId: string; alertName: string): Recallable =
  ## alertsGetResourceGroupLevelAlerts
  ## Get an alert that is associated a resource group or a resource in a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   alertName: string (required)
  ##            : Name of the alert object
  var path_568283 = newJObject()
  var query_568284 = newJObject()
  add(path_568283, "resourceGroupName", newJString(resourceGroupName))
  add(query_568284, "api-version", newJString(apiVersion))
  add(path_568283, "ascLocation", newJString(ascLocation))
  add(path_568283, "subscriptionId", newJString(subscriptionId))
  add(path_568283, "alertName", newJString(alertName))
  result = call_568282.call(path_568283, query_568284, nil, nil, nil)

var alertsGetResourceGroupLevelAlerts* = Call_AlertsGetResourceGroupLevelAlerts_568273(
    name: "alertsGetResourceGroupLevelAlerts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/alerts/{alertName}",
    validator: validate_AlertsGetResourceGroupLevelAlerts_568274, base: "",
    url: url_AlertsGetResourceGroupLevelAlerts_568275, schemes: {Scheme.Https})
type
  Call_AlertsUpdateResourceGroupLevelAlertState_568285 = ref object of OpenApiRestCall_567659
proc url_AlertsUpdateResourceGroupLevelAlertState_568287(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "alertName" in path, "`alertName` is a required path parameter"
  assert "alertUpdateActionType" in path,
        "`alertUpdateActionType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/alerts/"),
               (kind: VariableSegment, value: "alertName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "alertUpdateActionType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsUpdateResourceGroupLevelAlertState_568286(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the alert's state
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   alertUpdateActionType: JString (required)
  ##                        : Type of the action to do on the alert
  ##   alertName: JString (required)
  ##            : Name of the alert object
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568288 = path.getOrDefault("resourceGroupName")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "resourceGroupName", valid_568288
  var valid_568289 = path.getOrDefault("ascLocation")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "ascLocation", valid_568289
  var valid_568290 = path.getOrDefault("subscriptionId")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "subscriptionId", valid_568290
  var valid_568291 = path.getOrDefault("alertUpdateActionType")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = newJString("Dismiss"))
  if valid_568291 != nil:
    section.add "alertUpdateActionType", valid_568291
  var valid_568292 = path.getOrDefault("alertName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "alertName", valid_568292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568293 = query.getOrDefault("api-version")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "api-version", valid_568293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568294: Call_AlertsUpdateResourceGroupLevelAlertState_568285;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the alert's state
  ## 
  let valid = call_568294.validator(path, query, header, formData, body)
  let scheme = call_568294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568294.url(scheme.get, call_568294.host, call_568294.base,
                         call_568294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568294, url, valid)

proc call*(call_568295: Call_AlertsUpdateResourceGroupLevelAlertState_568285;
          resourceGroupName: string; apiVersion: string; ascLocation: string;
          subscriptionId: string; alertName: string;
          alertUpdateActionType: string = "Dismiss"): Recallable =
  ## alertsUpdateResourceGroupLevelAlertState
  ## Update the alert's state
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   alertUpdateActionType: string (required)
  ##                        : Type of the action to do on the alert
  ##   alertName: string (required)
  ##            : Name of the alert object
  var path_568296 = newJObject()
  var query_568297 = newJObject()
  add(path_568296, "resourceGroupName", newJString(resourceGroupName))
  add(query_568297, "api-version", newJString(apiVersion))
  add(path_568296, "ascLocation", newJString(ascLocation))
  add(path_568296, "subscriptionId", newJString(subscriptionId))
  add(path_568296, "alertUpdateActionType", newJString(alertUpdateActionType))
  add(path_568296, "alertName", newJString(alertName))
  result = call_568295.call(path_568296, query_568297, nil, nil, nil)

var alertsUpdateResourceGroupLevelAlertState* = Call_AlertsUpdateResourceGroupLevelAlertState_568285(
    name: "alertsUpdateResourceGroupLevelAlertState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/alerts/{alertName}/{alertUpdateActionType}",
    validator: validate_AlertsUpdateResourceGroupLevelAlertState_568286, base: "",
    url: url_AlertsUpdateResourceGroupLevelAlertState_568287,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
