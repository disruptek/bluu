
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: FabricAdminClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Infrastructure role operation endpoints and objects.
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

  OpenApiRestCall_574441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574441): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-InfraRole"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_InfraRolesList_574663 = ref object of OpenApiRestCall_574441
proc url_InfraRolesList_574665(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/infraRoles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InfraRolesList_574664(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns a list of all infrastructure roles at a location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
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
  var valid_574828 = path.getOrDefault("location")
  valid_574828 = validateParameter(valid_574828, JString, required = true,
                                 default = nil)
  if valid_574828 != nil:
    section.add "location", valid_574828
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574842 = query.getOrDefault("api-version")
  valid_574842 = validateParameter(valid_574842, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574842 != nil:
    section.add "api-version", valid_574842
  var valid_574843 = query.getOrDefault("$filter")
  valid_574843 = validateParameter(valid_574843, JString, required = false,
                                 default = nil)
  if valid_574843 != nil:
    section.add "$filter", valid_574843
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574870: Call_InfraRolesList_574663; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all infrastructure roles at a location.
  ## 
  let valid = call_574870.validator(path, query, header, formData, body)
  let scheme = call_574870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574870.url(scheme.get, call_574870.host, call_574870.base,
                         call_574870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574870, url, valid)

proc call*(call_574941: Call_InfraRolesList_574663; resourceGroupName: string;
          subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"; Filter: string = ""): Recallable =
  ## infraRolesList
  ## Returns a list of all infrastructure roles at a location.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   Filter: string
  ##         : OData filter parameter.
  var path_574942 = newJObject()
  var query_574944 = newJObject()
  add(path_574942, "resourceGroupName", newJString(resourceGroupName))
  add(query_574944, "api-version", newJString(apiVersion))
  add(path_574942, "subscriptionId", newJString(subscriptionId))
  add(path_574942, "location", newJString(location))
  add(query_574944, "$filter", newJString(Filter))
  result = call_574941.call(path_574942, query_574944, nil, nil, nil)

var infraRolesList* = Call_InfraRolesList_574663(name: "infraRolesList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/infraRoles",
    validator: validate_InfraRolesList_574664, base: "", url: url_InfraRolesList_574665,
    schemes: {Scheme.Https})
type
  Call_InfraRolesGet_574983 = ref object of OpenApiRestCall_574441
proc url_InfraRolesGet_574985(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "infraRole" in path, "`infraRole` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/infraRoles/"),
               (kind: VariableSegment, value: "infraRole")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InfraRolesGet_574984(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the requested infrastructure role description.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   infraRole: JString (required)
  ##            : Infrastructure role name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `infraRole` field"
  var valid_574995 = path.getOrDefault("infraRole")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = nil)
  if valid_574995 != nil:
    section.add "infraRole", valid_574995
  var valid_574996 = path.getOrDefault("resourceGroupName")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = nil)
  if valid_574996 != nil:
    section.add "resourceGroupName", valid_574996
  var valid_574997 = path.getOrDefault("subscriptionId")
  valid_574997 = validateParameter(valid_574997, JString, required = true,
                                 default = nil)
  if valid_574997 != nil:
    section.add "subscriptionId", valid_574997
  var valid_574998 = path.getOrDefault("location")
  valid_574998 = validateParameter(valid_574998, JString, required = true,
                                 default = nil)
  if valid_574998 != nil:
    section.add "location", valid_574998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574999 = query.getOrDefault("api-version")
  valid_574999 = validateParameter(valid_574999, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574999 != nil:
    section.add "api-version", valid_574999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575000: Call_InfraRolesGet_574983; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the requested infrastructure role description.
  ## 
  let valid = call_575000.validator(path, query, header, formData, body)
  let scheme = call_575000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575000.url(scheme.get, call_575000.host, call_575000.base,
                         call_575000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575000, url, valid)

proc call*(call_575001: Call_InfraRolesGet_574983; infraRole: string;
          resourceGroupName: string; subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## infraRolesGet
  ## Returns the requested infrastructure role description.
  ##   infraRole: string (required)
  ##            : Infrastructure role name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575002 = newJObject()
  var query_575003 = newJObject()
  add(path_575002, "infraRole", newJString(infraRole))
  add(path_575002, "resourceGroupName", newJString(resourceGroupName))
  add(query_575003, "api-version", newJString(apiVersion))
  add(path_575002, "subscriptionId", newJString(subscriptionId))
  add(path_575002, "location", newJString(location))
  result = call_575001.call(path_575002, query_575003, nil, nil, nil)

var infraRolesGet* = Call_InfraRolesGet_574983(name: "infraRolesGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/infraRoles/{infraRole}",
    validator: validate_InfraRolesGet_574984, base: "", url: url_InfraRolesGet_574985,
    schemes: {Scheme.Https})
type
  Call_InfraRolesRestart_575004 = ref object of OpenApiRestCall_574441
proc url_InfraRolesRestart_575006(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "infraRole" in path, "`infraRole` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/infraRoles/"),
               (kind: VariableSegment, value: "infraRole"),
               (kind: ConstantSegment, value: "/Restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InfraRolesRestart_575005(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Restarts the requested infrastructure role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   infraRole: JString (required)
  ##            : Infrastructure role name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `infraRole` field"
  var valid_575007 = path.getOrDefault("infraRole")
  valid_575007 = validateParameter(valid_575007, JString, required = true,
                                 default = nil)
  if valid_575007 != nil:
    section.add "infraRole", valid_575007
  var valid_575008 = path.getOrDefault("resourceGroupName")
  valid_575008 = validateParameter(valid_575008, JString, required = true,
                                 default = nil)
  if valid_575008 != nil:
    section.add "resourceGroupName", valid_575008
  var valid_575009 = path.getOrDefault("subscriptionId")
  valid_575009 = validateParameter(valid_575009, JString, required = true,
                                 default = nil)
  if valid_575009 != nil:
    section.add "subscriptionId", valid_575009
  var valid_575010 = path.getOrDefault("location")
  valid_575010 = validateParameter(valid_575010, JString, required = true,
                                 default = nil)
  if valid_575010 != nil:
    section.add "location", valid_575010
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575011 = query.getOrDefault("api-version")
  valid_575011 = validateParameter(valid_575011, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575011 != nil:
    section.add "api-version", valid_575011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575012: Call_InfraRolesRestart_575004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts the requested infrastructure role.
  ## 
  let valid = call_575012.validator(path, query, header, formData, body)
  let scheme = call_575012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575012.url(scheme.get, call_575012.host, call_575012.base,
                         call_575012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575012, url, valid)

proc call*(call_575013: Call_InfraRolesRestart_575004; infraRole: string;
          resourceGroupName: string; subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## infraRolesRestart
  ## Restarts the requested infrastructure role.
  ##   infraRole: string (required)
  ##            : Infrastructure role name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575014 = newJObject()
  var query_575015 = newJObject()
  add(path_575014, "infraRole", newJString(infraRole))
  add(path_575014, "resourceGroupName", newJString(resourceGroupName))
  add(query_575015, "api-version", newJString(apiVersion))
  add(path_575014, "subscriptionId", newJString(subscriptionId))
  add(path_575014, "location", newJString(location))
  result = call_575013.call(path_575014, query_575015, nil, nil, nil)

var infraRolesRestart* = Call_InfraRolesRestart_575004(name: "infraRolesRestart",
    meth: HttpMethod.HttpPost, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/infraRoles/{infraRole}/Restart",
    validator: validate_InfraRolesRestart_575005, base: "",
    url: url_InfraRolesRestart_575006, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
