
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: InfrastructureInsightsManagementClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Alert operation endpoints and objects.
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

  OpenApiRestCall_582442 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_582442](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_582442): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-Alert"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AlertsList_582664 = ref object of OpenApiRestCall_582442
proc url_AlertsList_582666(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.InfrastructureInsights.Admin/regionHealths/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsList_582665(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of all alerts in a given region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Name of the region
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_582827 = path.getOrDefault("resourceGroupName")
  valid_582827 = validateParameter(valid_582827, JString, required = true,
                                 default = nil)
  if valid_582827 != nil:
    section.add "resourceGroupName", valid_582827
  var valid_582828 = path.getOrDefault("subscriptionId")
  valid_582828 = validateParameter(valid_582828, JString, required = true,
                                 default = nil)
  if valid_582828 != nil:
    section.add "subscriptionId", valid_582828
  var valid_582829 = path.getOrDefault("location")
  valid_582829 = validateParameter(valid_582829, JString, required = true,
                                 default = nil)
  if valid_582829 != nil:
    section.add "location", valid_582829
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582843 = query.getOrDefault("api-version")
  valid_582843 = validateParameter(valid_582843, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_582843 != nil:
    section.add "api-version", valid_582843
  var valid_582844 = query.getOrDefault("$filter")
  valid_582844 = validateParameter(valid_582844, JString, required = false,
                                 default = nil)
  if valid_582844 != nil:
    section.add "$filter", valid_582844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582871: Call_AlertsList_582664; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of all alerts in a given region.
  ## 
  let valid = call_582871.validator(path, query, header, formData, body)
  let scheme = call_582871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582871.url(scheme.get, call_582871.host, call_582871.base,
                         call_582871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582871, url, valid)

proc call*(call_582942: Call_AlertsList_582664; resourceGroupName: string;
          subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"; Filter: string = ""): Recallable =
  ## alertsList
  ## Returns the list of all alerts in a given region.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Name of the region
  ##   Filter: string
  ##         : OData filter parameter.
  var path_582943 = newJObject()
  var query_582945 = newJObject()
  add(path_582943, "resourceGroupName", newJString(resourceGroupName))
  add(query_582945, "api-version", newJString(apiVersion))
  add(path_582943, "subscriptionId", newJString(subscriptionId))
  add(path_582943, "location", newJString(location))
  add(query_582945, "$filter", newJString(Filter))
  result = call_582942.call(path_582943, query_582945, nil, nil, nil)

var alertsList* = Call_AlertsList_582664(name: "alertsList",
                                      meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.InfrastructureInsights.Admin/regionHealths/{location}/alerts",
                                      validator: validate_AlertsList_582665,
                                      base: "", url: url_AlertsList_582666,
                                      schemes: {Scheme.Https})
type
  Call_AlertsClose_583005 = ref object of OpenApiRestCall_582442
proc url_AlertsClose_583007(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "alertName" in path, "`alertName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.InfrastructureInsights.Admin/regionHealths/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/alerts/"),
               (kind: VariableSegment, value: "alertName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsClose_583006(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Closes the given alert.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alertName: JString (required)
  ##            : Name of the alert.
  ##   location: JString (required)
  ##           : Name of the region
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_583008 = path.getOrDefault("resourceGroupName")
  valid_583008 = validateParameter(valid_583008, JString, required = true,
                                 default = nil)
  if valid_583008 != nil:
    section.add "resourceGroupName", valid_583008
  var valid_583009 = path.getOrDefault("subscriptionId")
  valid_583009 = validateParameter(valid_583009, JString, required = true,
                                 default = nil)
  if valid_583009 != nil:
    section.add "subscriptionId", valid_583009
  var valid_583010 = path.getOrDefault("alertName")
  valid_583010 = validateParameter(valid_583010, JString, required = true,
                                 default = nil)
  if valid_583010 != nil:
    section.add "alertName", valid_583010
  var valid_583011 = path.getOrDefault("location")
  valid_583011 = validateParameter(valid_583011, JString, required = true,
                                 default = nil)
  if valid_583011 != nil:
    section.add "location", valid_583011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   user: JString (required)
  ##       : The username used to perform the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_583012 = query.getOrDefault("api-version")
  valid_583012 = validateParameter(valid_583012, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_583012 != nil:
    section.add "api-version", valid_583012
  var valid_583013 = query.getOrDefault("user")
  valid_583013 = validateParameter(valid_583013, JString, required = true,
                                 default = nil)
  if valid_583013 != nil:
    section.add "user", valid_583013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   alert: JObject (required)
  ##        : Updated alert parameter.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_583015: Call_AlertsClose_583005; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Closes the given alert.
  ## 
  let valid = call_583015.validator(path, query, header, formData, body)
  let scheme = call_583015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583015.url(scheme.get, call_583015.host, call_583015.base,
                         call_583015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583015, url, valid)

proc call*(call_583016: Call_AlertsClose_583005; resourceGroupName: string;
          subscriptionId: string; alert: JsonNode; alertName: string; user: string;
          location: string; apiVersion: string = "2016-05-01"): Recallable =
  ## alertsClose
  ## Closes the given alert.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alert: JObject (required)
  ##        : Updated alert parameter.
  ##   alertName: string (required)
  ##            : Name of the alert.
  ##   user: string (required)
  ##       : The username used to perform the operation.
  ##   location: string (required)
  ##           : Name of the region
  var path_583017 = newJObject()
  var query_583018 = newJObject()
  var body_583019 = newJObject()
  add(path_583017, "resourceGroupName", newJString(resourceGroupName))
  add(query_583018, "api-version", newJString(apiVersion))
  add(path_583017, "subscriptionId", newJString(subscriptionId))
  if alert != nil:
    body_583019 = alert
  add(path_583017, "alertName", newJString(alertName))
  add(query_583018, "user", newJString(user))
  add(path_583017, "location", newJString(location))
  result = call_583016.call(path_583017, query_583018, nil, nil, body_583019)

var alertsClose* = Call_AlertsClose_583005(name: "alertsClose",
                                        meth: HttpMethod.HttpPut, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.InfrastructureInsights.Admin/regionHealths/{location}/alerts/{alertName}",
                                        validator: validate_AlertsClose_583006,
                                        base: "", url: url_AlertsClose_583007,
                                        schemes: {Scheme.Https})
type
  Call_AlertsGet_582984 = ref object of OpenApiRestCall_582442
proc url_AlertsGet_582986(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "alertName" in path, "`alertName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.InfrastructureInsights.Admin/regionHealths/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/alerts/"),
               (kind: VariableSegment, value: "alertName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGet_582985(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the requested an alert.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alertName: JString (required)
  ##            : Name of the alert.
  ##   location: JString (required)
  ##           : Name of the region
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_582996 = path.getOrDefault("resourceGroupName")
  valid_582996 = validateParameter(valid_582996, JString, required = true,
                                 default = nil)
  if valid_582996 != nil:
    section.add "resourceGroupName", valid_582996
  var valid_582997 = path.getOrDefault("subscriptionId")
  valid_582997 = validateParameter(valid_582997, JString, required = true,
                                 default = nil)
  if valid_582997 != nil:
    section.add "subscriptionId", valid_582997
  var valid_582998 = path.getOrDefault("alertName")
  valid_582998 = validateParameter(valid_582998, JString, required = true,
                                 default = nil)
  if valid_582998 != nil:
    section.add "alertName", valid_582998
  var valid_582999 = path.getOrDefault("location")
  valid_582999 = validateParameter(valid_582999, JString, required = true,
                                 default = nil)
  if valid_582999 != nil:
    section.add "location", valid_582999
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_583000 = query.getOrDefault("api-version")
  valid_583000 = validateParameter(valid_583000, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_583000 != nil:
    section.add "api-version", valid_583000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_583001: Call_AlertsGet_582984; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the requested an alert.
  ## 
  let valid = call_583001.validator(path, query, header, formData, body)
  let scheme = call_583001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583001.url(scheme.get, call_583001.host, call_583001.base,
                         call_583001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583001, url, valid)

proc call*(call_583002: Call_AlertsGet_582984; resourceGroupName: string;
          subscriptionId: string; alertName: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## alertsGet
  ## Returns the requested an alert.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alertName: string (required)
  ##            : Name of the alert.
  ##   location: string (required)
  ##           : Name of the region
  var path_583003 = newJObject()
  var query_583004 = newJObject()
  add(path_583003, "resourceGroupName", newJString(resourceGroupName))
  add(query_583004, "api-version", newJString(apiVersion))
  add(path_583003, "subscriptionId", newJString(subscriptionId))
  add(path_583003, "alertName", newJString(alertName))
  add(path_583003, "location", newJString(location))
  result = call_583002.call(path_583003, query_583004, nil, nil, nil)

var alertsGet* = Call_AlertsGet_582984(name: "alertsGet", meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.InfrastructureInsights.Admin/regionHealths/{location}/alerts/{alertName}",
                                    validator: validate_AlertsGet_582985,
                                    base: "", url: url_AlertsGet_582986,
                                    schemes: {Scheme.Https})
type
  Call_AlertsRepair_583020 = ref object of OpenApiRestCall_582442
proc url_AlertsRepair_583022(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "alertName" in path, "`alertName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.InfrastructureInsights.Admin/regionHealths/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/alerts/"),
               (kind: VariableSegment, value: "alertName"),
               (kind: ConstantSegment, value: "/repair")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsRepair_583021(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Repairs an alert.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alertName: JString (required)
  ##            : Name of the alert.
  ##   location: JString (required)
  ##           : Name of the region
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_583023 = path.getOrDefault("resourceGroupName")
  valid_583023 = validateParameter(valid_583023, JString, required = true,
                                 default = nil)
  if valid_583023 != nil:
    section.add "resourceGroupName", valid_583023
  var valid_583024 = path.getOrDefault("subscriptionId")
  valid_583024 = validateParameter(valid_583024, JString, required = true,
                                 default = nil)
  if valid_583024 != nil:
    section.add "subscriptionId", valid_583024
  var valid_583025 = path.getOrDefault("alertName")
  valid_583025 = validateParameter(valid_583025, JString, required = true,
                                 default = nil)
  if valid_583025 != nil:
    section.add "alertName", valid_583025
  var valid_583026 = path.getOrDefault("location")
  valid_583026 = validateParameter(valid_583026, JString, required = true,
                                 default = nil)
  if valid_583026 != nil:
    section.add "location", valid_583026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_583027 = query.getOrDefault("api-version")
  valid_583027 = validateParameter(valid_583027, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_583027 != nil:
    section.add "api-version", valid_583027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_583028: Call_AlertsRepair_583020; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Repairs an alert.
  ## 
  let valid = call_583028.validator(path, query, header, formData, body)
  let scheme = call_583028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583028.url(scheme.get, call_583028.host, call_583028.base,
                         call_583028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583028, url, valid)

proc call*(call_583029: Call_AlertsRepair_583020; resourceGroupName: string;
          subscriptionId: string; alertName: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## alertsRepair
  ## Repairs an alert.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alertName: string (required)
  ##            : Name of the alert.
  ##   location: string (required)
  ##           : Name of the region
  var path_583030 = newJObject()
  var query_583031 = newJObject()
  add(path_583030, "resourceGroupName", newJString(resourceGroupName))
  add(query_583031, "api-version", newJString(apiVersion))
  add(path_583030, "subscriptionId", newJString(subscriptionId))
  add(path_583030, "alertName", newJString(alertName))
  add(path_583030, "location", newJString(location))
  result = call_583029.call(path_583030, query_583031, nil, nil, nil)

var alertsRepair* = Call_AlertsRepair_583020(name: "alertsRepair",
    meth: HttpMethod.HttpPost, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.InfrastructureInsights.Admin/regionHealths/{location}/alerts/{alertName}/repair",
    validator: validate_AlertsRepair_583021, base: "", url: url_AlertsRepair_583022,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
