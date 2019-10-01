
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: UpdateAdminClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Update run operation endpoints and objects.
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

  OpenApiRestCall_574442 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574442](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574442): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-UpdateRuns"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_UpdateRunsListTopLevel_574664 = ref object of OpenApiRestCall_574442
proc url_UpdateRunsListTopLevel_574666(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "updateLocation" in path, "`updateLocation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Update.Admin/updateLocations/"),
               (kind: VariableSegment, value: "updateLocation"),
               (kind: ConstantSegment, value: "/updateRuns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateRunsListTopLevel_574665(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of update runs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.  The subscription ID forms part of the URI for every service call.
  ##   updateLocation: JString (required)
  ##                 : The name of the update location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574826 = path.getOrDefault("resourceGroupName")
  valid_574826 = validateParameter(valid_574826, JString, required = true,
                                 default = nil)
  if valid_574826 != nil:
    section.add "resourceGroupName", valid_574826
  var valid_574827 = path.getOrDefault("subscriptionId")
  valid_574827 = validateParameter(valid_574827, JString, required = true,
                                 default = nil)
  if valid_574827 != nil:
    section.add "subscriptionId", valid_574827
  var valid_574828 = path.getOrDefault("updateLocation")
  valid_574828 = validateParameter(valid_574828, JString, required = true,
                                 default = nil)
  if valid_574828 != nil:
    section.add "updateLocation", valid_574828
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574842 = query.getOrDefault("api-version")
  valid_574842 = validateParameter(valid_574842, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574842 != nil:
    section.add "api-version", valid_574842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574869: Call_UpdateRunsListTopLevel_574664; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of update runs.
  ## 
  let valid = call_574869.validator(path, query, header, formData, body)
  let scheme = call_574869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574869.url(scheme.get, call_574869.host, call_574869.base,
                         call_574869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574869, url, valid)

proc call*(call_574940: Call_UpdateRunsListTopLevel_574664;
          resourceGroupName: string; subscriptionId: string; updateLocation: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## updateRunsListTopLevel
  ## Get the list of update runs.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.  The subscription ID forms part of the URI for every service call.
  ##   updateLocation: string (required)
  ##                 : The name of the update location.
  var path_574941 = newJObject()
  var query_574943 = newJObject()
  add(path_574941, "resourceGroupName", newJString(resourceGroupName))
  add(query_574943, "api-version", newJString(apiVersion))
  add(path_574941, "subscriptionId", newJString(subscriptionId))
  add(path_574941, "updateLocation", newJString(updateLocation))
  result = call_574940.call(path_574941, query_574943, nil, nil, nil)

var updateRunsListTopLevel* = Call_UpdateRunsListTopLevel_574664(
    name: "updateRunsListTopLevel", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Update.Admin/updateLocations/{updateLocation}/updateRuns",
    validator: validate_UpdateRunsListTopLevel_574665, base: "",
    url: url_UpdateRunsListTopLevel_574666, schemes: {Scheme.Https})
type
  Call_UpdateRunsGetTopLevel_574982 = ref object of OpenApiRestCall_574442
proc url_UpdateRunsGetTopLevel_574984(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "updateLocation" in path, "`updateLocation` is a required path parameter"
  assert "runName" in path, "`runName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Update.Admin/updateLocations/"),
               (kind: VariableSegment, value: "updateLocation"),
               (kind: ConstantSegment, value: "/updateRuns/"),
               (kind: VariableSegment, value: "runName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateRunsGetTopLevel_574983(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an instance of update run using the ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   runName: JString (required)
  ##          : Update run identifier.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.  The subscription ID forms part of the URI for every service call.
  ##   updateLocation: JString (required)
  ##                 : The name of the update location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574994 = path.getOrDefault("resourceGroupName")
  valid_574994 = validateParameter(valid_574994, JString, required = true,
                                 default = nil)
  if valid_574994 != nil:
    section.add "resourceGroupName", valid_574994
  var valid_574995 = path.getOrDefault("runName")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = nil)
  if valid_574995 != nil:
    section.add "runName", valid_574995
  var valid_574996 = path.getOrDefault("subscriptionId")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = nil)
  if valid_574996 != nil:
    section.add "subscriptionId", valid_574996
  var valid_574997 = path.getOrDefault("updateLocation")
  valid_574997 = validateParameter(valid_574997, JString, required = true,
                                 default = nil)
  if valid_574997 != nil:
    section.add "updateLocation", valid_574997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574998 = query.getOrDefault("api-version")
  valid_574998 = validateParameter(valid_574998, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574998 != nil:
    section.add "api-version", valid_574998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574999: Call_UpdateRunsGetTopLevel_574982; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an instance of update run using the ID.
  ## 
  let valid = call_574999.validator(path, query, header, formData, body)
  let scheme = call_574999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574999.url(scheme.get, call_574999.host, call_574999.base,
                         call_574999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574999, url, valid)

proc call*(call_575000: Call_UpdateRunsGetTopLevel_574982;
          resourceGroupName: string; runName: string; subscriptionId: string;
          updateLocation: string; apiVersion: string = "2016-05-01"): Recallable =
  ## updateRunsGetTopLevel
  ## Get an instance of update run using the ID.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   runName: string (required)
  ##          : Update run identifier.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.  The subscription ID forms part of the URI for every service call.
  ##   updateLocation: string (required)
  ##                 : The name of the update location.
  var path_575001 = newJObject()
  var query_575002 = newJObject()
  add(path_575001, "resourceGroupName", newJString(resourceGroupName))
  add(path_575001, "runName", newJString(runName))
  add(query_575002, "api-version", newJString(apiVersion))
  add(path_575001, "subscriptionId", newJString(subscriptionId))
  add(path_575001, "updateLocation", newJString(updateLocation))
  result = call_575000.call(path_575001, query_575002, nil, nil, nil)

var updateRunsGetTopLevel* = Call_UpdateRunsGetTopLevel_574982(
    name: "updateRunsGetTopLevel", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Update.Admin/updateLocations/{updateLocation}/updateRuns/{runName}",
    validator: validate_UpdateRunsGetTopLevel_574983, base: "",
    url: url_UpdateRunsGetTopLevel_574984, schemes: {Scheme.Https})
type
  Call_UpdateRunsList_575003 = ref object of OpenApiRestCall_574442
proc url_UpdateRunsList_575005(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "updateLocation" in path, "`updateLocation` is a required path parameter"
  assert "updateName" in path, "`updateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Update.Admin/updateLocations/"),
               (kind: VariableSegment, value: "updateLocation"),
               (kind: ConstantSegment, value: "/updates/"),
               (kind: VariableSegment, value: "updateName"),
               (kind: ConstantSegment, value: "/updateRuns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateRunsList_575004(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get the list of update runs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   updateName: JString (required)
  ##             : Name of the update.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.  The subscription ID forms part of the URI for every service call.
  ##   updateLocation: JString (required)
  ##                 : The name of the update location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `updateName` field"
  var valid_575006 = path.getOrDefault("updateName")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = nil)
  if valid_575006 != nil:
    section.add "updateName", valid_575006
  var valid_575007 = path.getOrDefault("resourceGroupName")
  valid_575007 = validateParameter(valid_575007, JString, required = true,
                                 default = nil)
  if valid_575007 != nil:
    section.add "resourceGroupName", valid_575007
  var valid_575008 = path.getOrDefault("subscriptionId")
  valid_575008 = validateParameter(valid_575008, JString, required = true,
                                 default = nil)
  if valid_575008 != nil:
    section.add "subscriptionId", valid_575008
  var valid_575009 = path.getOrDefault("updateLocation")
  valid_575009 = validateParameter(valid_575009, JString, required = true,
                                 default = nil)
  if valid_575009 != nil:
    section.add "updateLocation", valid_575009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575010 = query.getOrDefault("api-version")
  valid_575010 = validateParameter(valid_575010, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575010 != nil:
    section.add "api-version", valid_575010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575011: Call_UpdateRunsList_575003; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of update runs.
  ## 
  let valid = call_575011.validator(path, query, header, formData, body)
  let scheme = call_575011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575011.url(scheme.get, call_575011.host, call_575011.base,
                         call_575011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575011, url, valid)

proc call*(call_575012: Call_UpdateRunsList_575003; updateName: string;
          resourceGroupName: string; subscriptionId: string; updateLocation: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## updateRunsList
  ## Get the list of update runs.
  ##   updateName: string (required)
  ##             : Name of the update.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.  The subscription ID forms part of the URI for every service call.
  ##   updateLocation: string (required)
  ##                 : The name of the update location.
  var path_575013 = newJObject()
  var query_575014 = newJObject()
  add(path_575013, "updateName", newJString(updateName))
  add(path_575013, "resourceGroupName", newJString(resourceGroupName))
  add(query_575014, "api-version", newJString(apiVersion))
  add(path_575013, "subscriptionId", newJString(subscriptionId))
  add(path_575013, "updateLocation", newJString(updateLocation))
  result = call_575012.call(path_575013, query_575014, nil, nil, nil)

var updateRunsList* = Call_UpdateRunsList_575003(name: "updateRunsList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Update.Admin/updateLocations/{updateLocation}/updates/{updateName}/updateRuns",
    validator: validate_UpdateRunsList_575004, base: "", url: url_UpdateRunsList_575005,
    schemes: {Scheme.Https})
type
  Call_UpdateRunsGet_575015 = ref object of OpenApiRestCall_574442
proc url_UpdateRunsGet_575017(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "updateLocation" in path, "`updateLocation` is a required path parameter"
  assert "updateName" in path, "`updateName` is a required path parameter"
  assert "runName" in path, "`runName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Update.Admin/updateLocations/"),
               (kind: VariableSegment, value: "updateLocation"),
               (kind: ConstantSegment, value: "/updates/"),
               (kind: VariableSegment, value: "updateName"),
               (kind: ConstantSegment, value: "/updateRuns/"),
               (kind: VariableSegment, value: "runName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateRunsGet_575016(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an instance of update run using the ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   updateName: JString (required)
  ##             : Name of the update.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   runName: JString (required)
  ##          : Update run identifier.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.  The subscription ID forms part of the URI for every service call.
  ##   updateLocation: JString (required)
  ##                 : The name of the update location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `updateName` field"
  var valid_575018 = path.getOrDefault("updateName")
  valid_575018 = validateParameter(valid_575018, JString, required = true,
                                 default = nil)
  if valid_575018 != nil:
    section.add "updateName", valid_575018
  var valid_575019 = path.getOrDefault("resourceGroupName")
  valid_575019 = validateParameter(valid_575019, JString, required = true,
                                 default = nil)
  if valid_575019 != nil:
    section.add "resourceGroupName", valid_575019
  var valid_575020 = path.getOrDefault("runName")
  valid_575020 = validateParameter(valid_575020, JString, required = true,
                                 default = nil)
  if valid_575020 != nil:
    section.add "runName", valid_575020
  var valid_575021 = path.getOrDefault("subscriptionId")
  valid_575021 = validateParameter(valid_575021, JString, required = true,
                                 default = nil)
  if valid_575021 != nil:
    section.add "subscriptionId", valid_575021
  var valid_575022 = path.getOrDefault("updateLocation")
  valid_575022 = validateParameter(valid_575022, JString, required = true,
                                 default = nil)
  if valid_575022 != nil:
    section.add "updateLocation", valid_575022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575023 = query.getOrDefault("api-version")
  valid_575023 = validateParameter(valid_575023, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575023 != nil:
    section.add "api-version", valid_575023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575024: Call_UpdateRunsGet_575015; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an instance of update run using the ID.
  ## 
  let valid = call_575024.validator(path, query, header, formData, body)
  let scheme = call_575024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575024.url(scheme.get, call_575024.host, call_575024.base,
                         call_575024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575024, url, valid)

proc call*(call_575025: Call_UpdateRunsGet_575015; updateName: string;
          resourceGroupName: string; runName: string; subscriptionId: string;
          updateLocation: string; apiVersion: string = "2016-05-01"): Recallable =
  ## updateRunsGet
  ## Get an instance of update run using the ID.
  ##   updateName: string (required)
  ##             : Name of the update.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   runName: string (required)
  ##          : Update run identifier.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.  The subscription ID forms part of the URI for every service call.
  ##   updateLocation: string (required)
  ##                 : The name of the update location.
  var path_575026 = newJObject()
  var query_575027 = newJObject()
  add(path_575026, "updateName", newJString(updateName))
  add(path_575026, "resourceGroupName", newJString(resourceGroupName))
  add(path_575026, "runName", newJString(runName))
  add(query_575027, "api-version", newJString(apiVersion))
  add(path_575026, "subscriptionId", newJString(subscriptionId))
  add(path_575026, "updateLocation", newJString(updateLocation))
  result = call_575025.call(path_575026, query_575027, nil, nil, nil)

var updateRunsGet* = Call_UpdateRunsGet_575015(name: "updateRunsGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Update.Admin/updateLocations/{updateLocation}/updates/{updateName}/updateRuns/{runName}",
    validator: validate_UpdateRunsGet_575016, base: "", url: url_UpdateRunsGet_575017,
    schemes: {Scheme.Https})
type
  Call_UpdateRunsRerun_575028 = ref object of OpenApiRestCall_574442
proc url_UpdateRunsRerun_575030(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "updateLocation" in path, "`updateLocation` is a required path parameter"
  assert "updateName" in path, "`updateName` is a required path parameter"
  assert "runName" in path, "`runName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Update.Admin/updateLocations/"),
               (kind: VariableSegment, value: "updateLocation"),
               (kind: ConstantSegment, value: "/updates/"),
               (kind: VariableSegment, value: "updateName"),
               (kind: ConstantSegment, value: "/updateRuns/"),
               (kind: VariableSegment, value: "runName"),
               (kind: ConstantSegment, value: "/rerun")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateRunsRerun_575029(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Resume a failed update.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   updateName: JString (required)
  ##             : Name of the update.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   runName: JString (required)
  ##          : Update run identifier.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.  The subscription ID forms part of the URI for every service call.
  ##   updateLocation: JString (required)
  ##                 : The name of the update location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `updateName` field"
  var valid_575031 = path.getOrDefault("updateName")
  valid_575031 = validateParameter(valid_575031, JString, required = true,
                                 default = nil)
  if valid_575031 != nil:
    section.add "updateName", valid_575031
  var valid_575032 = path.getOrDefault("resourceGroupName")
  valid_575032 = validateParameter(valid_575032, JString, required = true,
                                 default = nil)
  if valid_575032 != nil:
    section.add "resourceGroupName", valid_575032
  var valid_575033 = path.getOrDefault("runName")
  valid_575033 = validateParameter(valid_575033, JString, required = true,
                                 default = nil)
  if valid_575033 != nil:
    section.add "runName", valid_575033
  var valid_575034 = path.getOrDefault("subscriptionId")
  valid_575034 = validateParameter(valid_575034, JString, required = true,
                                 default = nil)
  if valid_575034 != nil:
    section.add "subscriptionId", valid_575034
  var valid_575035 = path.getOrDefault("updateLocation")
  valid_575035 = validateParameter(valid_575035, JString, required = true,
                                 default = nil)
  if valid_575035 != nil:
    section.add "updateLocation", valid_575035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575036 = query.getOrDefault("api-version")
  valid_575036 = validateParameter(valid_575036, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575036 != nil:
    section.add "api-version", valid_575036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575037: Call_UpdateRunsRerun_575028; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume a failed update.
  ## 
  let valid = call_575037.validator(path, query, header, formData, body)
  let scheme = call_575037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575037.url(scheme.get, call_575037.host, call_575037.base,
                         call_575037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575037, url, valid)

proc call*(call_575038: Call_UpdateRunsRerun_575028; updateName: string;
          resourceGroupName: string; runName: string; subscriptionId: string;
          updateLocation: string; apiVersion: string = "2016-05-01"): Recallable =
  ## updateRunsRerun
  ## Resume a failed update.
  ##   updateName: string (required)
  ##             : Name of the update.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   runName: string (required)
  ##          : Update run identifier.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.  The subscription ID forms part of the URI for every service call.
  ##   updateLocation: string (required)
  ##                 : The name of the update location.
  var path_575039 = newJObject()
  var query_575040 = newJObject()
  add(path_575039, "updateName", newJString(updateName))
  add(path_575039, "resourceGroupName", newJString(resourceGroupName))
  add(path_575039, "runName", newJString(runName))
  add(query_575040, "api-version", newJString(apiVersion))
  add(path_575039, "subscriptionId", newJString(subscriptionId))
  add(path_575039, "updateLocation", newJString(updateLocation))
  result = call_575038.call(path_575039, query_575040, nil, nil, nil)

var updateRunsRerun* = Call_UpdateRunsRerun_575028(name: "updateRunsRerun",
    meth: HttpMethod.HttpPost, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Update.Admin/updateLocations/{updateLocation}/updates/{updateName}/updateRuns/{runName}/rerun",
    validator: validate_UpdateRunsRerun_575029, base: "", url: url_UpdateRunsRerun_575030,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
