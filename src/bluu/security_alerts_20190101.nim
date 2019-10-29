
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563557 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563557](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563557): Option[Scheme] {.used.} =
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
  macServiceName = "security-alerts"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AlertsList_563779 = ref object of OpenApiRestCall_563557
proc url_AlertsList_563781(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AlertsList_563780(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_563957 = path.getOrDefault("subscriptionId")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "subscriptionId", valid_563957
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $select: JString
  ##          : OData select. Optional.
  ##   $expand: JString
  ##          : OData expand. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563958 = query.getOrDefault("api-version")
  valid_563958 = validateParameter(valid_563958, JString, required = true,
                                 default = nil)
  if valid_563958 != nil:
    section.add "api-version", valid_563958
  var valid_563959 = query.getOrDefault("$select")
  valid_563959 = validateParameter(valid_563959, JString, required = false,
                                 default = nil)
  if valid_563959 != nil:
    section.add "$select", valid_563959
  var valid_563960 = query.getOrDefault("$expand")
  valid_563960 = validateParameter(valid_563960, JString, required = false,
                                 default = nil)
  if valid_563960 != nil:
    section.add "$expand", valid_563960
  var valid_563961 = query.getOrDefault("$filter")
  valid_563961 = validateParameter(valid_563961, JString, required = false,
                                 default = nil)
  if valid_563961 != nil:
    section.add "$filter", valid_563961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563984: Call_AlertsList_563779; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the alerts that are associated with the subscription
  ## 
  let valid = call_563984.validator(path, query, header, formData, body)
  let scheme = call_563984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563984.url(scheme.get, call_563984.host, call_563984.base,
                         call_563984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563984, url, valid)

proc call*(call_564055: Call_AlertsList_563779; apiVersion: string;
          subscriptionId: string; Select: string = ""; Expand: string = "";
          Filter: string = ""): Recallable =
  ## alertsList
  ## List all the alerts that are associated with the subscription
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   Select: string
  ##         : OData select. Optional.
  ##   Expand: string
  ##         : OData expand. Optional.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_564056 = newJObject()
  var query_564058 = newJObject()
  add(query_564058, "api-version", newJString(apiVersion))
  add(query_564058, "$select", newJString(Select))
  add(query_564058, "$expand", newJString(Expand))
  add(path_564056, "subscriptionId", newJString(subscriptionId))
  add(query_564058, "$filter", newJString(Filter))
  result = call_564055.call(path_564056, query_564058, nil, nil, nil)

var alertsList* = Call_AlertsList_563779(name: "alertsList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/alerts",
                                      validator: validate_AlertsList_563780,
                                      base: "", url: url_AlertsList_563781,
                                      schemes: {Scheme.Https})
type
  Call_AlertsListSubscriptionLevelAlertsByRegion_564097 = ref object of OpenApiRestCall_563557
proc url_AlertsListSubscriptionLevelAlertsByRegion_564099(protocol: Scheme;
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

proc validate_AlertsListSubscriptionLevelAlertsByRegion_564098(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the alerts that are associated with the subscription that are stored in a specific location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564100 = path.getOrDefault("subscriptionId")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "subscriptionId", valid_564100
  var valid_564101 = path.getOrDefault("ascLocation")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "ascLocation", valid_564101
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $select: JString
  ##          : OData select. Optional.
  ##   $expand: JString
  ##          : OData expand. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564102 = query.getOrDefault("api-version")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "api-version", valid_564102
  var valid_564103 = query.getOrDefault("$select")
  valid_564103 = validateParameter(valid_564103, JString, required = false,
                                 default = nil)
  if valid_564103 != nil:
    section.add "$select", valid_564103
  var valid_564104 = query.getOrDefault("$expand")
  valid_564104 = validateParameter(valid_564104, JString, required = false,
                                 default = nil)
  if valid_564104 != nil:
    section.add "$expand", valid_564104
  var valid_564105 = query.getOrDefault("$filter")
  valid_564105 = validateParameter(valid_564105, JString, required = false,
                                 default = nil)
  if valid_564105 != nil:
    section.add "$filter", valid_564105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564106: Call_AlertsListSubscriptionLevelAlertsByRegion_564097;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the alerts that are associated with the subscription that are stored in a specific location
  ## 
  let valid = call_564106.validator(path, query, header, formData, body)
  let scheme = call_564106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564106.url(scheme.get, call_564106.host, call_564106.base,
                         call_564106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564106, url, valid)

proc call*(call_564107: Call_AlertsListSubscriptionLevelAlertsByRegion_564097;
          apiVersion: string; subscriptionId: string; ascLocation: string;
          Select: string = ""; Expand: string = ""; Filter: string = ""): Recallable =
  ## alertsListSubscriptionLevelAlertsByRegion
  ## List all the alerts that are associated with the subscription that are stored in a specific location
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   Select: string
  ##         : OData select. Optional.
  ##   Expand: string
  ##         : OData expand. Optional.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_564108 = newJObject()
  var query_564109 = newJObject()
  add(query_564109, "api-version", newJString(apiVersion))
  add(query_564109, "$select", newJString(Select))
  add(query_564109, "$expand", newJString(Expand))
  add(path_564108, "subscriptionId", newJString(subscriptionId))
  add(path_564108, "ascLocation", newJString(ascLocation))
  add(query_564109, "$filter", newJString(Filter))
  result = call_564107.call(path_564108, query_564109, nil, nil, nil)

var alertsListSubscriptionLevelAlertsByRegion* = Call_AlertsListSubscriptionLevelAlertsByRegion_564097(
    name: "alertsListSubscriptionLevelAlertsByRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/alerts",
    validator: validate_AlertsListSubscriptionLevelAlertsByRegion_564098,
    base: "", url: url_AlertsListSubscriptionLevelAlertsByRegion_564099,
    schemes: {Scheme.Https})
type
  Call_AlertsGetSubscriptionLevelAlert_564110 = ref object of OpenApiRestCall_563557
proc url_AlertsGetSubscriptionLevelAlert_564112(protocol: Scheme; host: string;
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

proc validate_AlertsGetSubscriptionLevelAlert_564111(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an alert that is associated with a subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertName: JString (required)
  ##            : Name of the alert object
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertName` field"
  var valid_564113 = path.getOrDefault("alertName")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "alertName", valid_564113
  var valid_564114 = path.getOrDefault("subscriptionId")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "subscriptionId", valid_564114
  var valid_564115 = path.getOrDefault("ascLocation")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "ascLocation", valid_564115
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564116 = query.getOrDefault("api-version")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "api-version", valid_564116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564117: Call_AlertsGetSubscriptionLevelAlert_564110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an alert that is associated with a subscription
  ## 
  let valid = call_564117.validator(path, query, header, formData, body)
  let scheme = call_564117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564117.url(scheme.get, call_564117.host, call_564117.base,
                         call_564117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564117, url, valid)

proc call*(call_564118: Call_AlertsGetSubscriptionLevelAlert_564110;
          alertName: string; apiVersion: string; subscriptionId: string;
          ascLocation: string): Recallable =
  ## alertsGetSubscriptionLevelAlert
  ## Get an alert that is associated with a subscription
  ##   alertName: string (required)
  ##            : Name of the alert object
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  var path_564119 = newJObject()
  var query_564120 = newJObject()
  add(path_564119, "alertName", newJString(alertName))
  add(query_564120, "api-version", newJString(apiVersion))
  add(path_564119, "subscriptionId", newJString(subscriptionId))
  add(path_564119, "ascLocation", newJString(ascLocation))
  result = call_564118.call(path_564119, query_564120, nil, nil, nil)

var alertsGetSubscriptionLevelAlert* = Call_AlertsGetSubscriptionLevelAlert_564110(
    name: "alertsGetSubscriptionLevelAlert", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/alerts/{alertName}",
    validator: validate_AlertsGetSubscriptionLevelAlert_564111, base: "",
    url: url_AlertsGetSubscriptionLevelAlert_564112, schemes: {Scheme.Https})
type
  Call_AlertsUpdateSubscriptionLevelAlertState_564121 = ref object of OpenApiRestCall_563557
proc url_AlertsUpdateSubscriptionLevelAlertState_564123(protocol: Scheme;
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

proc validate_AlertsUpdateSubscriptionLevelAlertState_564122(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the alert's state
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertName: JString (required)
  ##            : Name of the alert object
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   alertUpdateActionType: JString (required)
  ##                        : Type of the action to do on the alert
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertName` field"
  var valid_564124 = path.getOrDefault("alertName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "alertName", valid_564124
  var valid_564125 = path.getOrDefault("subscriptionId")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "subscriptionId", valid_564125
  var valid_564126 = path.getOrDefault("ascLocation")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "ascLocation", valid_564126
  var valid_564140 = path.getOrDefault("alertUpdateActionType")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = newJString("Dismiss"))
  if valid_564140 != nil:
    section.add "alertUpdateActionType", valid_564140
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564141 = query.getOrDefault("api-version")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "api-version", valid_564141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564142: Call_AlertsUpdateSubscriptionLevelAlertState_564121;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the alert's state
  ## 
  let valid = call_564142.validator(path, query, header, formData, body)
  let scheme = call_564142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564142.url(scheme.get, call_564142.host, call_564142.base,
                         call_564142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564142, url, valid)

proc call*(call_564143: Call_AlertsUpdateSubscriptionLevelAlertState_564121;
          alertName: string; apiVersion: string; subscriptionId: string;
          ascLocation: string; alertUpdateActionType: string = "Dismiss"): Recallable =
  ## alertsUpdateSubscriptionLevelAlertState
  ## Update the alert's state
  ##   alertName: string (required)
  ##            : Name of the alert object
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   alertUpdateActionType: string (required)
  ##                        : Type of the action to do on the alert
  var path_564144 = newJObject()
  var query_564145 = newJObject()
  add(path_564144, "alertName", newJString(alertName))
  add(query_564145, "api-version", newJString(apiVersion))
  add(path_564144, "subscriptionId", newJString(subscriptionId))
  add(path_564144, "ascLocation", newJString(ascLocation))
  add(path_564144, "alertUpdateActionType", newJString(alertUpdateActionType))
  result = call_564143.call(path_564144, query_564145, nil, nil, nil)

var alertsUpdateSubscriptionLevelAlertState* = Call_AlertsUpdateSubscriptionLevelAlertState_564121(
    name: "alertsUpdateSubscriptionLevelAlertState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/alerts/{alertName}/{alertUpdateActionType}",
    validator: validate_AlertsUpdateSubscriptionLevelAlertState_564122, base: "",
    url: url_AlertsUpdateSubscriptionLevelAlertState_564123,
    schemes: {Scheme.Https})
type
  Call_AlertsListByResourceGroup_564146 = ref object of OpenApiRestCall_563557
proc url_AlertsListByResourceGroup_564148(protocol: Scheme; host: string;
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

proc validate_AlertsListByResourceGroup_564147(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the alerts that are associated with the resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
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
  ##              : API version for the operation
  ##   $select: JString
  ##          : OData select. Optional.
  ##   $expand: JString
  ##          : OData expand. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564151 = query.getOrDefault("api-version")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "api-version", valid_564151
  var valid_564152 = query.getOrDefault("$select")
  valid_564152 = validateParameter(valid_564152, JString, required = false,
                                 default = nil)
  if valid_564152 != nil:
    section.add "$select", valid_564152
  var valid_564153 = query.getOrDefault("$expand")
  valid_564153 = validateParameter(valid_564153, JString, required = false,
                                 default = nil)
  if valid_564153 != nil:
    section.add "$expand", valid_564153
  var valid_564154 = query.getOrDefault("$filter")
  valid_564154 = validateParameter(valid_564154, JString, required = false,
                                 default = nil)
  if valid_564154 != nil:
    section.add "$filter", valid_564154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564155: Call_AlertsListByResourceGroup_564146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the alerts that are associated with the resource group
  ## 
  let valid = call_564155.validator(path, query, header, formData, body)
  let scheme = call_564155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564155.url(scheme.get, call_564155.host, call_564155.base,
                         call_564155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564155, url, valid)

proc call*(call_564156: Call_AlertsListByResourceGroup_564146; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; Select: string = "";
          Expand: string = ""; Filter: string = ""): Recallable =
  ## alertsListByResourceGroup
  ## List all the alerts that are associated with the resource group
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   Select: string
  ##         : OData select. Optional.
  ##   Expand: string
  ##         : OData expand. Optional.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_564157 = newJObject()
  var query_564158 = newJObject()
  add(query_564158, "api-version", newJString(apiVersion))
  add(query_564158, "$select", newJString(Select))
  add(query_564158, "$expand", newJString(Expand))
  add(path_564157, "subscriptionId", newJString(subscriptionId))
  add(path_564157, "resourceGroupName", newJString(resourceGroupName))
  add(query_564158, "$filter", newJString(Filter))
  result = call_564156.call(path_564157, query_564158, nil, nil, nil)

var alertsListByResourceGroup* = Call_AlertsListByResourceGroup_564146(
    name: "alertsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/alerts",
    validator: validate_AlertsListByResourceGroup_564147, base: "",
    url: url_AlertsListByResourceGroup_564148, schemes: {Scheme.Https})
type
  Call_AlertsListResourceGroupLevelAlertsByRegion_564159 = ref object of OpenApiRestCall_563557
proc url_AlertsListResourceGroupLevelAlertsByRegion_564161(protocol: Scheme;
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

proc validate_AlertsListResourceGroupLevelAlertsByRegion_564160(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the alerts that are associated with the resource group that are stored in a specific location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564162 = path.getOrDefault("subscriptionId")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "subscriptionId", valid_564162
  var valid_564163 = path.getOrDefault("ascLocation")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "ascLocation", valid_564163
  var valid_564164 = path.getOrDefault("resourceGroupName")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "resourceGroupName", valid_564164
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $select: JString
  ##          : OData select. Optional.
  ##   $expand: JString
  ##          : OData expand. Optional.
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564165 = query.getOrDefault("api-version")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "api-version", valid_564165
  var valid_564166 = query.getOrDefault("$select")
  valid_564166 = validateParameter(valid_564166, JString, required = false,
                                 default = nil)
  if valid_564166 != nil:
    section.add "$select", valid_564166
  var valid_564167 = query.getOrDefault("$expand")
  valid_564167 = validateParameter(valid_564167, JString, required = false,
                                 default = nil)
  if valid_564167 != nil:
    section.add "$expand", valid_564167
  var valid_564168 = query.getOrDefault("$filter")
  valid_564168 = validateParameter(valid_564168, JString, required = false,
                                 default = nil)
  if valid_564168 != nil:
    section.add "$filter", valid_564168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564169: Call_AlertsListResourceGroupLevelAlertsByRegion_564159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all the alerts that are associated with the resource group that are stored in a specific location
  ## 
  let valid = call_564169.validator(path, query, header, formData, body)
  let scheme = call_564169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564169.url(scheme.get, call_564169.host, call_564169.base,
                         call_564169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564169, url, valid)

proc call*(call_564170: Call_AlertsListResourceGroupLevelAlertsByRegion_564159;
          apiVersion: string; subscriptionId: string; ascLocation: string;
          resourceGroupName: string; Select: string = ""; Expand: string = "";
          Filter: string = ""): Recallable =
  ## alertsListResourceGroupLevelAlertsByRegion
  ## List all the alerts that are associated with the resource group that are stored in a specific location
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   Select: string
  ##         : OData select. Optional.
  ##   Expand: string
  ##         : OData expand. Optional.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_564171 = newJObject()
  var query_564172 = newJObject()
  add(query_564172, "api-version", newJString(apiVersion))
  add(query_564172, "$select", newJString(Select))
  add(query_564172, "$expand", newJString(Expand))
  add(path_564171, "subscriptionId", newJString(subscriptionId))
  add(path_564171, "ascLocation", newJString(ascLocation))
  add(path_564171, "resourceGroupName", newJString(resourceGroupName))
  add(query_564172, "$filter", newJString(Filter))
  result = call_564170.call(path_564171, query_564172, nil, nil, nil)

var alertsListResourceGroupLevelAlertsByRegion* = Call_AlertsListResourceGroupLevelAlertsByRegion_564159(
    name: "alertsListResourceGroupLevelAlertsByRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/alerts",
    validator: validate_AlertsListResourceGroupLevelAlertsByRegion_564160,
    base: "", url: url_AlertsListResourceGroupLevelAlertsByRegion_564161,
    schemes: {Scheme.Https})
type
  Call_AlertsGetResourceGroupLevelAlerts_564173 = ref object of OpenApiRestCall_563557
proc url_AlertsGetResourceGroupLevelAlerts_564175(protocol: Scheme; host: string;
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

proc validate_AlertsGetResourceGroupLevelAlerts_564174(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an alert that is associated a resource group or a resource in a resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertName: JString (required)
  ##            : Name of the alert object
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertName` field"
  var valid_564176 = path.getOrDefault("alertName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "alertName", valid_564176
  var valid_564177 = path.getOrDefault("subscriptionId")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "subscriptionId", valid_564177
  var valid_564178 = path.getOrDefault("ascLocation")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "ascLocation", valid_564178
  var valid_564179 = path.getOrDefault("resourceGroupName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "resourceGroupName", valid_564179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564180 = query.getOrDefault("api-version")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "api-version", valid_564180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564181: Call_AlertsGetResourceGroupLevelAlerts_564173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an alert that is associated a resource group or a resource in a resource group
  ## 
  let valid = call_564181.validator(path, query, header, formData, body)
  let scheme = call_564181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564181.url(scheme.get, call_564181.host, call_564181.base,
                         call_564181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564181, url, valid)

proc call*(call_564182: Call_AlertsGetResourceGroupLevelAlerts_564173;
          alertName: string; apiVersion: string; subscriptionId: string;
          ascLocation: string; resourceGroupName: string): Recallable =
  ## alertsGetResourceGroupLevelAlerts
  ## Get an alert that is associated a resource group or a resource in a resource group
  ##   alertName: string (required)
  ##            : Name of the alert object
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  var path_564183 = newJObject()
  var query_564184 = newJObject()
  add(path_564183, "alertName", newJString(alertName))
  add(query_564184, "api-version", newJString(apiVersion))
  add(path_564183, "subscriptionId", newJString(subscriptionId))
  add(path_564183, "ascLocation", newJString(ascLocation))
  add(path_564183, "resourceGroupName", newJString(resourceGroupName))
  result = call_564182.call(path_564183, query_564184, nil, nil, nil)

var alertsGetResourceGroupLevelAlerts* = Call_AlertsGetResourceGroupLevelAlerts_564173(
    name: "alertsGetResourceGroupLevelAlerts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/alerts/{alertName}",
    validator: validate_AlertsGetResourceGroupLevelAlerts_564174, base: "",
    url: url_AlertsGetResourceGroupLevelAlerts_564175, schemes: {Scheme.Https})
type
  Call_AlertsUpdateResourceGroupLevelAlertState_564185 = ref object of OpenApiRestCall_563557
proc url_AlertsUpdateResourceGroupLevelAlertState_564187(protocol: Scheme;
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

proc validate_AlertsUpdateResourceGroupLevelAlertState_564186(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the alert's state
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertName: JString (required)
  ##            : Name of the alert object
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   alertUpdateActionType: JString (required)
  ##                        : Type of the action to do on the alert
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertName` field"
  var valid_564188 = path.getOrDefault("alertName")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "alertName", valid_564188
  var valid_564189 = path.getOrDefault("subscriptionId")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "subscriptionId", valid_564189
  var valid_564190 = path.getOrDefault("ascLocation")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "ascLocation", valid_564190
  var valid_564191 = path.getOrDefault("resourceGroupName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "resourceGroupName", valid_564191
  var valid_564192 = path.getOrDefault("alertUpdateActionType")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = newJString("Dismiss"))
  if valid_564192 != nil:
    section.add "alertUpdateActionType", valid_564192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564193 = query.getOrDefault("api-version")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "api-version", valid_564193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564194: Call_AlertsUpdateResourceGroupLevelAlertState_564185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the alert's state
  ## 
  let valid = call_564194.validator(path, query, header, formData, body)
  let scheme = call_564194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564194.url(scheme.get, call_564194.host, call_564194.base,
                         call_564194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564194, url, valid)

proc call*(call_564195: Call_AlertsUpdateResourceGroupLevelAlertState_564185;
          alertName: string; apiVersion: string; subscriptionId: string;
          ascLocation: string; resourceGroupName: string;
          alertUpdateActionType: string = "Dismiss"): Recallable =
  ## alertsUpdateResourceGroupLevelAlertState
  ## Update the alert's state
  ##   alertName: string (required)
  ##            : Name of the alert object
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   alertUpdateActionType: string (required)
  ##                        : Type of the action to do on the alert
  var path_564196 = newJObject()
  var query_564197 = newJObject()
  add(path_564196, "alertName", newJString(alertName))
  add(query_564197, "api-version", newJString(apiVersion))
  add(path_564196, "subscriptionId", newJString(subscriptionId))
  add(path_564196, "ascLocation", newJString(ascLocation))
  add(path_564196, "resourceGroupName", newJString(resourceGroupName))
  add(path_564196, "alertUpdateActionType", newJString(alertUpdateActionType))
  result = call_564195.call(path_564196, query_564197, nil, nil, nil)

var alertsUpdateResourceGroupLevelAlertState* = Call_AlertsUpdateResourceGroupLevelAlertState_564185(
    name: "alertsUpdateResourceGroupLevelAlertState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/alerts/{alertName}/{alertUpdateActionType}",
    validator: validate_AlertsUpdateResourceGroupLevelAlertState_564186, base: "",
    url: url_AlertsUpdateResourceGroupLevelAlertState_564187,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
