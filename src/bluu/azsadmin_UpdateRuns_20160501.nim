
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593409 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593409](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593409): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-UpdateRuns"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_UpdateRunsListTopLevel_593631 = ref object of OpenApiRestCall_593409
proc url_UpdateRunsListTopLevel_593633(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateRunsListTopLevel_593632(path: JsonNode; query: JsonNode;
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
  var valid_593793 = path.getOrDefault("resourceGroupName")
  valid_593793 = validateParameter(valid_593793, JString, required = true,
                                 default = nil)
  if valid_593793 != nil:
    section.add "resourceGroupName", valid_593793
  var valid_593794 = path.getOrDefault("subscriptionId")
  valid_593794 = validateParameter(valid_593794, JString, required = true,
                                 default = nil)
  if valid_593794 != nil:
    section.add "subscriptionId", valid_593794
  var valid_593795 = path.getOrDefault("updateLocation")
  valid_593795 = validateParameter(valid_593795, JString, required = true,
                                 default = nil)
  if valid_593795 != nil:
    section.add "updateLocation", valid_593795
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593809 = query.getOrDefault("api-version")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_593809 != nil:
    section.add "api-version", valid_593809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593836: Call_UpdateRunsListTopLevel_593631; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of update runs.
  ## 
  let valid = call_593836.validator(path, query, header, formData, body)
  let scheme = call_593836.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593836.url(scheme.get, call_593836.host, call_593836.base,
                         call_593836.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593836, url, valid)

proc call*(call_593907: Call_UpdateRunsListTopLevel_593631;
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
  var path_593908 = newJObject()
  var query_593910 = newJObject()
  add(path_593908, "resourceGroupName", newJString(resourceGroupName))
  add(query_593910, "api-version", newJString(apiVersion))
  add(path_593908, "subscriptionId", newJString(subscriptionId))
  add(path_593908, "updateLocation", newJString(updateLocation))
  result = call_593907.call(path_593908, query_593910, nil, nil, nil)

var updateRunsListTopLevel* = Call_UpdateRunsListTopLevel_593631(
    name: "updateRunsListTopLevel", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Update.Admin/updateLocations/{updateLocation}/updateRuns",
    validator: validate_UpdateRunsListTopLevel_593632, base: "",
    url: url_UpdateRunsListTopLevel_593633, schemes: {Scheme.Https})
type
  Call_UpdateRunsGetTopLevel_593949 = ref object of OpenApiRestCall_593409
proc url_UpdateRunsGetTopLevel_593951(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateRunsGetTopLevel_593950(path: JsonNode; query: JsonNode;
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
  var valid_593961 = path.getOrDefault("resourceGroupName")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "resourceGroupName", valid_593961
  var valid_593962 = path.getOrDefault("runName")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "runName", valid_593962
  var valid_593963 = path.getOrDefault("subscriptionId")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "subscriptionId", valid_593963
  var valid_593964 = path.getOrDefault("updateLocation")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "updateLocation", valid_593964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593965 = query.getOrDefault("api-version")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_593965 != nil:
    section.add "api-version", valid_593965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_UpdateRunsGetTopLevel_593949; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an instance of update run using the ID.
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_UpdateRunsGetTopLevel_593949;
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
  var path_593968 = newJObject()
  var query_593969 = newJObject()
  add(path_593968, "resourceGroupName", newJString(resourceGroupName))
  add(path_593968, "runName", newJString(runName))
  add(query_593969, "api-version", newJString(apiVersion))
  add(path_593968, "subscriptionId", newJString(subscriptionId))
  add(path_593968, "updateLocation", newJString(updateLocation))
  result = call_593967.call(path_593968, query_593969, nil, nil, nil)

var updateRunsGetTopLevel* = Call_UpdateRunsGetTopLevel_593949(
    name: "updateRunsGetTopLevel", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Update.Admin/updateLocations/{updateLocation}/updateRuns/{runName}",
    validator: validate_UpdateRunsGetTopLevel_593950, base: "",
    url: url_UpdateRunsGetTopLevel_593951, schemes: {Scheme.Https})
type
  Call_UpdateRunsList_593970 = ref object of OpenApiRestCall_593409
proc url_UpdateRunsList_593972(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateRunsList_593971(path: JsonNode; query: JsonNode;
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
  var valid_593973 = path.getOrDefault("updateName")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "updateName", valid_593973
  var valid_593974 = path.getOrDefault("resourceGroupName")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "resourceGroupName", valid_593974
  var valid_593975 = path.getOrDefault("subscriptionId")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "subscriptionId", valid_593975
  var valid_593976 = path.getOrDefault("updateLocation")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "updateLocation", valid_593976
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593977 = query.getOrDefault("api-version")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_593977 != nil:
    section.add "api-version", valid_593977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593978: Call_UpdateRunsList_593970; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of update runs.
  ## 
  let valid = call_593978.validator(path, query, header, formData, body)
  let scheme = call_593978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593978.url(scheme.get, call_593978.host, call_593978.base,
                         call_593978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593978, url, valid)

proc call*(call_593979: Call_UpdateRunsList_593970; updateName: string;
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
  var path_593980 = newJObject()
  var query_593981 = newJObject()
  add(path_593980, "updateName", newJString(updateName))
  add(path_593980, "resourceGroupName", newJString(resourceGroupName))
  add(query_593981, "api-version", newJString(apiVersion))
  add(path_593980, "subscriptionId", newJString(subscriptionId))
  add(path_593980, "updateLocation", newJString(updateLocation))
  result = call_593979.call(path_593980, query_593981, nil, nil, nil)

var updateRunsList* = Call_UpdateRunsList_593970(name: "updateRunsList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Update.Admin/updateLocations/{updateLocation}/updates/{updateName}/updateRuns",
    validator: validate_UpdateRunsList_593971, base: "", url: url_UpdateRunsList_593972,
    schemes: {Scheme.Https})
type
  Call_UpdateRunsGet_593982 = ref object of OpenApiRestCall_593409
proc url_UpdateRunsGet_593984(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateRunsGet_593983(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593985 = path.getOrDefault("updateName")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "updateName", valid_593985
  var valid_593986 = path.getOrDefault("resourceGroupName")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "resourceGroupName", valid_593986
  var valid_593987 = path.getOrDefault("runName")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "runName", valid_593987
  var valid_593988 = path.getOrDefault("subscriptionId")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "subscriptionId", valid_593988
  var valid_593989 = path.getOrDefault("updateLocation")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "updateLocation", valid_593989
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593990 = query.getOrDefault("api-version")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_593990 != nil:
    section.add "api-version", valid_593990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593991: Call_UpdateRunsGet_593982; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an instance of update run using the ID.
  ## 
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_UpdateRunsGet_593982; updateName: string;
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
  var path_593993 = newJObject()
  var query_593994 = newJObject()
  add(path_593993, "updateName", newJString(updateName))
  add(path_593993, "resourceGroupName", newJString(resourceGroupName))
  add(path_593993, "runName", newJString(runName))
  add(query_593994, "api-version", newJString(apiVersion))
  add(path_593993, "subscriptionId", newJString(subscriptionId))
  add(path_593993, "updateLocation", newJString(updateLocation))
  result = call_593992.call(path_593993, query_593994, nil, nil, nil)

var updateRunsGet* = Call_UpdateRunsGet_593982(name: "updateRunsGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Update.Admin/updateLocations/{updateLocation}/updates/{updateName}/updateRuns/{runName}",
    validator: validate_UpdateRunsGet_593983, base: "", url: url_UpdateRunsGet_593984,
    schemes: {Scheme.Https})
type
  Call_UpdateRunsRerun_593995 = ref object of OpenApiRestCall_593409
proc url_UpdateRunsRerun_593997(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateRunsRerun_593996(path: JsonNode; query: JsonNode;
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
  var valid_593998 = path.getOrDefault("updateName")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "updateName", valid_593998
  var valid_593999 = path.getOrDefault("resourceGroupName")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "resourceGroupName", valid_593999
  var valid_594000 = path.getOrDefault("runName")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "runName", valid_594000
  var valid_594001 = path.getOrDefault("subscriptionId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "subscriptionId", valid_594001
  var valid_594002 = path.getOrDefault("updateLocation")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "updateLocation", valid_594002
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594003 = query.getOrDefault("api-version")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_594003 != nil:
    section.add "api-version", valid_594003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594004: Call_UpdateRunsRerun_593995; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume a failed update.
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_UpdateRunsRerun_593995; updateName: string;
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
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  add(path_594006, "updateName", newJString(updateName))
  add(path_594006, "resourceGroupName", newJString(resourceGroupName))
  add(path_594006, "runName", newJString(runName))
  add(query_594007, "api-version", newJString(apiVersion))
  add(path_594006, "subscriptionId", newJString(subscriptionId))
  add(path_594006, "updateLocation", newJString(updateLocation))
  result = call_594005.call(path_594006, query_594007, nil, nil, nil)

var updateRunsRerun* = Call_UpdateRunsRerun_593995(name: "updateRunsRerun",
    meth: HttpMethod.HttpPost, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Update.Admin/updateLocations/{updateLocation}/updates/{updateName}/updateRuns/{runName}/rerun",
    validator: validate_UpdateRunsRerun_593996, base: "", url: url_UpdateRunsRerun_593997,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
