
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Service Map
## version: 2015-11-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Service Map API Reference
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
  macServiceName = "service-map-arm-service-map"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClientGroupsGet_567888 = ref object of OpenApiRestCall_567666
proc url_ClientGroupsGet_567890(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "clientGroupName" in path, "`clientGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/clientGroups/"),
               (kind: VariableSegment, value: "clientGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClientGroupsGet_567889(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Retrieves the specified client group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  ##   clientGroupName: JString (required)
  ##                  : Client Group resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568063 = path.getOrDefault("resourceGroupName")
  valid_568063 = validateParameter(valid_568063, JString, required = true,
                                 default = nil)
  if valid_568063 != nil:
    section.add "resourceGroupName", valid_568063
  var valid_568064 = path.getOrDefault("subscriptionId")
  valid_568064 = validateParameter(valid_568064, JString, required = true,
                                 default = nil)
  if valid_568064 != nil:
    section.add "subscriptionId", valid_568064
  var valid_568065 = path.getOrDefault("workspaceName")
  valid_568065 = validateParameter(valid_568065, JString, required = true,
                                 default = nil)
  if valid_568065 != nil:
    section.add "workspaceName", valid_568065
  var valid_568066 = path.getOrDefault("clientGroupName")
  valid_568066 = validateParameter(valid_568066, JString, required = true,
                                 default = nil)
  if valid_568066 != nil:
    section.add "clientGroupName", valid_568066
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568067 = query.getOrDefault("api-version")
  valid_568067 = validateParameter(valid_568067, JString, required = true,
                                 default = nil)
  if valid_568067 != nil:
    section.add "api-version", valid_568067
  var valid_568068 = query.getOrDefault("endTime")
  valid_568068 = validateParameter(valid_568068, JString, required = false,
                                 default = nil)
  if valid_568068 != nil:
    section.add "endTime", valid_568068
  var valid_568069 = query.getOrDefault("startTime")
  valid_568069 = validateParameter(valid_568069, JString, required = false,
                                 default = nil)
  if valid_568069 != nil:
    section.add "startTime", valid_568069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568092: Call_ClientGroupsGet_567888; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified client group
  ## 
  let valid = call_568092.validator(path, query, header, formData, body)
  let scheme = call_568092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568092.url(scheme.get, call_568092.host, call_568092.base,
                         call_568092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568092, url, valid)

proc call*(call_568163: Call_ClientGroupsGet_567888; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string;
          clientGroupName: string; endTime: string = ""; startTime: string = ""): Recallable =
  ## clientGroupsGet
  ## Retrieves the specified client group
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   clientGroupName: string (required)
  ##                  : Client Group resource name.
  var path_568164 = newJObject()
  var query_568166 = newJObject()
  add(path_568164, "resourceGroupName", newJString(resourceGroupName))
  add(query_568166, "api-version", newJString(apiVersion))
  add(path_568164, "subscriptionId", newJString(subscriptionId))
  add(query_568166, "endTime", newJString(endTime))
  add(query_568166, "startTime", newJString(startTime))
  add(path_568164, "workspaceName", newJString(workspaceName))
  add(path_568164, "clientGroupName", newJString(clientGroupName))
  result = call_568163.call(path_568164, query_568166, nil, nil, nil)

var clientGroupsGet* = Call_ClientGroupsGet_567888(name: "clientGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/clientGroups/{clientGroupName}",
    validator: validate_ClientGroupsGet_567889, base: "", url: url_ClientGroupsGet_567890,
    schemes: {Scheme.Https})
type
  Call_ClientGroupsListMembers_568205 = ref object of OpenApiRestCall_567666
proc url_ClientGroupsListMembers_568207(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "clientGroupName" in path, "`clientGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/clientGroups/"),
               (kind: VariableSegment, value: "clientGroupName"),
               (kind: ConstantSegment, value: "/members")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClientGroupsListMembers_568206(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the members of the client group during the specified time interval.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  ##   clientGroupName: JString (required)
  ##                  : Client Group resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568209 = path.getOrDefault("resourceGroupName")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "resourceGroupName", valid_568209
  var valid_568210 = path.getOrDefault("subscriptionId")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "subscriptionId", valid_568210
  var valid_568211 = path.getOrDefault("workspaceName")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "workspaceName", valid_568211
  var valid_568212 = path.getOrDefault("clientGroupName")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "clientGroupName", valid_568212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   $top: JInt
  ##       : Page size to use. When not specified, the default page size is 100 records.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568213 = query.getOrDefault("api-version")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "api-version", valid_568213
  var valid_568214 = query.getOrDefault("endTime")
  valid_568214 = validateParameter(valid_568214, JString, required = false,
                                 default = nil)
  if valid_568214 != nil:
    section.add "endTime", valid_568214
  var valid_568215 = query.getOrDefault("$top")
  valid_568215 = validateParameter(valid_568215, JInt, required = false, default = nil)
  if valid_568215 != nil:
    section.add "$top", valid_568215
  var valid_568216 = query.getOrDefault("startTime")
  valid_568216 = validateParameter(valid_568216, JString, required = false,
                                 default = nil)
  if valid_568216 != nil:
    section.add "startTime", valid_568216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568217: Call_ClientGroupsListMembers_568205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the members of the client group during the specified time interval.
  ## 
  let valid = call_568217.validator(path, query, header, formData, body)
  let scheme = call_568217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568217.url(scheme.get, call_568217.host, call_568217.base,
                         call_568217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568217, url, valid)

proc call*(call_568218: Call_ClientGroupsListMembers_568205;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string; clientGroupName: string; endTime: string = "";
          Top: int = 0; startTime: string = ""): Recallable =
  ## clientGroupsListMembers
  ## Returns the members of the client group during the specified time interval.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   Top: int
  ##      : Page size to use. When not specified, the default page size is 100 records.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   clientGroupName: string (required)
  ##                  : Client Group resource name.
  var path_568219 = newJObject()
  var query_568220 = newJObject()
  add(path_568219, "resourceGroupName", newJString(resourceGroupName))
  add(query_568220, "api-version", newJString(apiVersion))
  add(path_568219, "subscriptionId", newJString(subscriptionId))
  add(query_568220, "endTime", newJString(endTime))
  add(query_568220, "$top", newJInt(Top))
  add(query_568220, "startTime", newJString(startTime))
  add(path_568219, "workspaceName", newJString(workspaceName))
  add(path_568219, "clientGroupName", newJString(clientGroupName))
  result = call_568218.call(path_568219, query_568220, nil, nil, nil)

var clientGroupsListMembers* = Call_ClientGroupsListMembers_568205(
    name: "clientGroupsListMembers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/clientGroups/{clientGroupName}/members",
    validator: validate_ClientGroupsListMembers_568206, base: "",
    url: url_ClientGroupsListMembers_568207, schemes: {Scheme.Https})
type
  Call_ClientGroupsGetMembersCount_568221 = ref object of OpenApiRestCall_567666
proc url_ClientGroupsGetMembersCount_568223(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "clientGroupName" in path, "`clientGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/clientGroups/"),
               (kind: VariableSegment, value: "clientGroupName"),
               (kind: ConstantSegment, value: "/membersCount")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClientGroupsGetMembersCount_568222(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the approximate number of members in the client group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  ##   clientGroupName: JString (required)
  ##                  : Client Group resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568224 = path.getOrDefault("resourceGroupName")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "resourceGroupName", valid_568224
  var valid_568225 = path.getOrDefault("subscriptionId")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "subscriptionId", valid_568225
  var valid_568226 = path.getOrDefault("workspaceName")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "workspaceName", valid_568226
  var valid_568227 = path.getOrDefault("clientGroupName")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "clientGroupName", valid_568227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568228 = query.getOrDefault("api-version")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "api-version", valid_568228
  var valid_568229 = query.getOrDefault("endTime")
  valid_568229 = validateParameter(valid_568229, JString, required = false,
                                 default = nil)
  if valid_568229 != nil:
    section.add "endTime", valid_568229
  var valid_568230 = query.getOrDefault("startTime")
  valid_568230 = validateParameter(valid_568230, JString, required = false,
                                 default = nil)
  if valid_568230 != nil:
    section.add "startTime", valid_568230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568231: Call_ClientGroupsGetMembersCount_568221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the approximate number of members in the client group.
  ## 
  let valid = call_568231.validator(path, query, header, formData, body)
  let scheme = call_568231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568231.url(scheme.get, call_568231.host, call_568231.base,
                         call_568231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568231, url, valid)

proc call*(call_568232: Call_ClientGroupsGetMembersCount_568221;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string; clientGroupName: string; endTime: string = "";
          startTime: string = ""): Recallable =
  ## clientGroupsGetMembersCount
  ## Returns the approximate number of members in the client group.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   clientGroupName: string (required)
  ##                  : Client Group resource name.
  var path_568233 = newJObject()
  var query_568234 = newJObject()
  add(path_568233, "resourceGroupName", newJString(resourceGroupName))
  add(query_568234, "api-version", newJString(apiVersion))
  add(path_568233, "subscriptionId", newJString(subscriptionId))
  add(query_568234, "endTime", newJString(endTime))
  add(query_568234, "startTime", newJString(startTime))
  add(path_568233, "workspaceName", newJString(workspaceName))
  add(path_568233, "clientGroupName", newJString(clientGroupName))
  result = call_568232.call(path_568233, query_568234, nil, nil, nil)

var clientGroupsGetMembersCount* = Call_ClientGroupsGetMembersCount_568221(
    name: "clientGroupsGetMembersCount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/clientGroups/{clientGroupName}/membersCount",
    validator: validate_ClientGroupsGetMembersCount_568222, base: "",
    url: url_ClientGroupsGetMembersCount_568223, schemes: {Scheme.Https})
type
  Call_MapsGenerate_568235 = ref object of OpenApiRestCall_567666
proc url_MapsGenerate_568237(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/generateMap")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MapsGenerate_568236(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates the specified map.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568238 = path.getOrDefault("resourceGroupName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "resourceGroupName", valid_568238
  var valid_568239 = path.getOrDefault("subscriptionId")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "subscriptionId", valid_568239
  var valid_568240 = path.getOrDefault("workspaceName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "workspaceName", valid_568240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
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
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : Request options.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568243: Call_MapsGenerate_568235; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates the specified map.
  ## 
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_MapsGenerate_568235; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; request: JsonNode;
          workspaceName: string): Recallable =
  ## mapsGenerate
  ## Generates the specified map.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   request: JObject (required)
  ##          : Request options.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568245 = newJObject()
  var query_568246 = newJObject()
  var body_568247 = newJObject()
  add(path_568245, "resourceGroupName", newJString(resourceGroupName))
  add(query_568246, "api-version", newJString(apiVersion))
  add(path_568245, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_568247 = request
  add(path_568245, "workspaceName", newJString(workspaceName))
  result = call_568244.call(path_568245, query_568246, nil, nil, body_568247)

var mapsGenerate* = Call_MapsGenerate_568235(name: "mapsGenerate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/generateMap",
    validator: validate_MapsGenerate_568236, base: "", url: url_MapsGenerate_568237,
    schemes: {Scheme.Https})
type
  Call_MachineGroupsCreate_568261 = ref object of OpenApiRestCall_567666
proc url_MachineGroupsCreate_568263(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machineGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineGroupsCreate_568262(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new machine group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568291 = path.getOrDefault("resourceGroupName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "resourceGroupName", valid_568291
  var valid_568292 = path.getOrDefault("subscriptionId")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "subscriptionId", valid_568292
  var valid_568293 = path.getOrDefault("workspaceName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "workspaceName", valid_568293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568294 = query.getOrDefault("api-version")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "api-version", valid_568294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   machineGroup: JObject (required)
  ##               : Machine Group resource to create.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568296: Call_MachineGroupsCreate_568261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new machine group.
  ## 
  let valid = call_568296.validator(path, query, header, formData, body)
  let scheme = call_568296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568296.url(scheme.get, call_568296.host, call_568296.base,
                         call_568296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568296, url, valid)

proc call*(call_568297: Call_MachineGroupsCreate_568261; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string;
          machineGroup: JsonNode): Recallable =
  ## machineGroupsCreate
  ## Creates a new machine group.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   machineGroup: JObject (required)
  ##               : Machine Group resource to create.
  var path_568298 = newJObject()
  var query_568299 = newJObject()
  var body_568300 = newJObject()
  add(path_568298, "resourceGroupName", newJString(resourceGroupName))
  add(query_568299, "api-version", newJString(apiVersion))
  add(path_568298, "subscriptionId", newJString(subscriptionId))
  add(path_568298, "workspaceName", newJString(workspaceName))
  if machineGroup != nil:
    body_568300 = machineGroup
  result = call_568297.call(path_568298, query_568299, nil, nil, body_568300)

var machineGroupsCreate* = Call_MachineGroupsCreate_568261(
    name: "machineGroupsCreate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machineGroups",
    validator: validate_MachineGroupsCreate_568262, base: "",
    url: url_MachineGroupsCreate_568263, schemes: {Scheme.Https})
type
  Call_MachineGroupsListByWorkspace_568248 = ref object of OpenApiRestCall_567666
proc url_MachineGroupsListByWorkspace_568250(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machineGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineGroupsListByWorkspace_568249(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all machine groups during the specified time interval.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568251 = path.getOrDefault("resourceGroupName")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "resourceGroupName", valid_568251
  var valid_568252 = path.getOrDefault("subscriptionId")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "subscriptionId", valid_568252
  var valid_568253 = path.getOrDefault("workspaceName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "workspaceName", valid_568253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568254 = query.getOrDefault("api-version")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "api-version", valid_568254
  var valid_568255 = query.getOrDefault("endTime")
  valid_568255 = validateParameter(valid_568255, JString, required = false,
                                 default = nil)
  if valid_568255 != nil:
    section.add "endTime", valid_568255
  var valid_568256 = query.getOrDefault("startTime")
  valid_568256 = validateParameter(valid_568256, JString, required = false,
                                 default = nil)
  if valid_568256 != nil:
    section.add "startTime", valid_568256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568257: Call_MachineGroupsListByWorkspace_568248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all machine groups during the specified time interval.
  ## 
  let valid = call_568257.validator(path, query, header, formData, body)
  let scheme = call_568257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568257.url(scheme.get, call_568257.host, call_568257.base,
                         call_568257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568257, url, valid)

proc call*(call_568258: Call_MachineGroupsListByWorkspace_568248;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string; endTime: string = ""; startTime: string = ""): Recallable =
  ## machineGroupsListByWorkspace
  ## Returns all machine groups during the specified time interval.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568259 = newJObject()
  var query_568260 = newJObject()
  add(path_568259, "resourceGroupName", newJString(resourceGroupName))
  add(query_568260, "api-version", newJString(apiVersion))
  add(path_568259, "subscriptionId", newJString(subscriptionId))
  add(query_568260, "endTime", newJString(endTime))
  add(query_568260, "startTime", newJString(startTime))
  add(path_568259, "workspaceName", newJString(workspaceName))
  result = call_568258.call(path_568259, query_568260, nil, nil, nil)

var machineGroupsListByWorkspace* = Call_MachineGroupsListByWorkspace_568248(
    name: "machineGroupsListByWorkspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machineGroups",
    validator: validate_MachineGroupsListByWorkspace_568249, base: "",
    url: url_MachineGroupsListByWorkspace_568250, schemes: {Scheme.Https})
type
  Call_MachineGroupsUpdate_568315 = ref object of OpenApiRestCall_567666
proc url_MachineGroupsUpdate_568317(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "machineGroupName" in path,
        "`machineGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machineGroups/"),
               (kind: VariableSegment, value: "machineGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineGroupsUpdate_568316(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a machine group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   machineGroupName: JString (required)
  ##                   : Machine Group resource name.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568318 = path.getOrDefault("resourceGroupName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "resourceGroupName", valid_568318
  var valid_568319 = path.getOrDefault("subscriptionId")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "subscriptionId", valid_568319
  var valid_568320 = path.getOrDefault("machineGroupName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "machineGroupName", valid_568320
  var valid_568321 = path.getOrDefault("workspaceName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "workspaceName", valid_568321
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568322 = query.getOrDefault("api-version")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "api-version", valid_568322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   machineGroup: JObject (required)
  ##               : Machine Group resource to update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568324: Call_MachineGroupsUpdate_568315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a machine group.
  ## 
  let valid = call_568324.validator(path, query, header, formData, body)
  let scheme = call_568324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568324.url(scheme.get, call_568324.host, call_568324.base,
                         call_568324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568324, url, valid)

proc call*(call_568325: Call_MachineGroupsUpdate_568315; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; machineGroupName: string;
          workspaceName: string; machineGroup: JsonNode): Recallable =
  ## machineGroupsUpdate
  ## Updates a machine group.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   machineGroupName: string (required)
  ##                   : Machine Group resource name.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   machineGroup: JObject (required)
  ##               : Machine Group resource to update.
  var path_568326 = newJObject()
  var query_568327 = newJObject()
  var body_568328 = newJObject()
  add(path_568326, "resourceGroupName", newJString(resourceGroupName))
  add(query_568327, "api-version", newJString(apiVersion))
  add(path_568326, "subscriptionId", newJString(subscriptionId))
  add(path_568326, "machineGroupName", newJString(machineGroupName))
  add(path_568326, "workspaceName", newJString(workspaceName))
  if machineGroup != nil:
    body_568328 = machineGroup
  result = call_568325.call(path_568326, query_568327, nil, nil, body_568328)

var machineGroupsUpdate* = Call_MachineGroupsUpdate_568315(
    name: "machineGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machineGroups/{machineGroupName}",
    validator: validate_MachineGroupsUpdate_568316, base: "",
    url: url_MachineGroupsUpdate_568317, schemes: {Scheme.Https})
type
  Call_MachineGroupsGet_568301 = ref object of OpenApiRestCall_567666
proc url_MachineGroupsGet_568303(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "machineGroupName" in path,
        "`machineGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machineGroups/"),
               (kind: VariableSegment, value: "machineGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineGroupsGet_568302(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns the specified machine group as it existed during the specified time interval.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   machineGroupName: JString (required)
  ##                   : Machine Group resource name.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568304 = path.getOrDefault("resourceGroupName")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "resourceGroupName", valid_568304
  var valid_568305 = path.getOrDefault("subscriptionId")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "subscriptionId", valid_568305
  var valid_568306 = path.getOrDefault("machineGroupName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "machineGroupName", valid_568306
  var valid_568307 = path.getOrDefault("workspaceName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "workspaceName", valid_568307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568308 = query.getOrDefault("api-version")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "api-version", valid_568308
  var valid_568309 = query.getOrDefault("endTime")
  valid_568309 = validateParameter(valid_568309, JString, required = false,
                                 default = nil)
  if valid_568309 != nil:
    section.add "endTime", valid_568309
  var valid_568310 = query.getOrDefault("startTime")
  valid_568310 = validateParameter(valid_568310, JString, required = false,
                                 default = nil)
  if valid_568310 != nil:
    section.add "startTime", valid_568310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568311: Call_MachineGroupsGet_568301; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified machine group as it existed during the specified time interval.
  ## 
  let valid = call_568311.validator(path, query, header, formData, body)
  let scheme = call_568311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568311.url(scheme.get, call_568311.host, call_568311.base,
                         call_568311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568311, url, valid)

proc call*(call_568312: Call_MachineGroupsGet_568301; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; machineGroupName: string;
          workspaceName: string; endTime: string = ""; startTime: string = ""): Recallable =
  ## machineGroupsGet
  ## Returns the specified machine group as it existed during the specified time interval.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   machineGroupName: string (required)
  ##                   : Machine Group resource name.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568313 = newJObject()
  var query_568314 = newJObject()
  add(path_568313, "resourceGroupName", newJString(resourceGroupName))
  add(query_568314, "api-version", newJString(apiVersion))
  add(path_568313, "subscriptionId", newJString(subscriptionId))
  add(query_568314, "endTime", newJString(endTime))
  add(path_568313, "machineGroupName", newJString(machineGroupName))
  add(query_568314, "startTime", newJString(startTime))
  add(path_568313, "workspaceName", newJString(workspaceName))
  result = call_568312.call(path_568313, query_568314, nil, nil, nil)

var machineGroupsGet* = Call_MachineGroupsGet_568301(name: "machineGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machineGroups/{machineGroupName}",
    validator: validate_MachineGroupsGet_568302, base: "",
    url: url_MachineGroupsGet_568303, schemes: {Scheme.Https})
type
  Call_MachineGroupsDelete_568329 = ref object of OpenApiRestCall_567666
proc url_MachineGroupsDelete_568331(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "machineGroupName" in path,
        "`machineGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machineGroups/"),
               (kind: VariableSegment, value: "machineGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachineGroupsDelete_568330(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified Machine Group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   machineGroupName: JString (required)
  ##                   : Machine Group resource name.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568332 = path.getOrDefault("resourceGroupName")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "resourceGroupName", valid_568332
  var valid_568333 = path.getOrDefault("subscriptionId")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "subscriptionId", valid_568333
  var valid_568334 = path.getOrDefault("machineGroupName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "machineGroupName", valid_568334
  var valid_568335 = path.getOrDefault("workspaceName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "workspaceName", valid_568335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568336 = query.getOrDefault("api-version")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "api-version", valid_568336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568337: Call_MachineGroupsDelete_568329; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Machine Group.
  ## 
  let valid = call_568337.validator(path, query, header, formData, body)
  let scheme = call_568337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568337.url(scheme.get, call_568337.host, call_568337.base,
                         call_568337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568337, url, valid)

proc call*(call_568338: Call_MachineGroupsDelete_568329; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; machineGroupName: string;
          workspaceName: string): Recallable =
  ## machineGroupsDelete
  ## Deletes the specified Machine Group.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   machineGroupName: string (required)
  ##                   : Machine Group resource name.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568339 = newJObject()
  var query_568340 = newJObject()
  add(path_568339, "resourceGroupName", newJString(resourceGroupName))
  add(query_568340, "api-version", newJString(apiVersion))
  add(path_568339, "subscriptionId", newJString(subscriptionId))
  add(path_568339, "machineGroupName", newJString(machineGroupName))
  add(path_568339, "workspaceName", newJString(workspaceName))
  result = call_568338.call(path_568339, query_568340, nil, nil, nil)

var machineGroupsDelete* = Call_MachineGroupsDelete_568329(
    name: "machineGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machineGroups/{machineGroupName}",
    validator: validate_MachineGroupsDelete_568330, base: "",
    url: url_MachineGroupsDelete_568331, schemes: {Scheme.Https})
type
  Call_MachinesListByWorkspace_568341 = ref object of OpenApiRestCall_567666
proc url_MachinesListByWorkspace_568343(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/features/serviceMap/machines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesListByWorkspace_568342(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of machines matching the specified conditions.  The returned collection represents either machines that are active/live during the specified interval  of time (`live=true` and `startTime`/`endTime` are specified) or that are known to have existed at or  some time prior to the specified point in time (`live=false` and `timestamp` is specified).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568344 = path.getOrDefault("resourceGroupName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "resourceGroupName", valid_568344
  var valid_568345 = path.getOrDefault("subscriptionId")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "subscriptionId", valid_568345
  var valid_568346 = path.getOrDefault("workspaceName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "workspaceName", valid_568346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   live: JBool
  ##       : Specifies whether to return live resources (true) or inventory resources (false). Defaults to **true**. When retrieving live resources, the start time (`startTime`) and end time (`endTime`) of the desired interval should be included. When retrieving inventory resources, an optional timestamp (`timestamp`) parameter can be specified to return the version of each resource closest (not-after) that timestamp.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   $top: JInt
  ##       : Page size to use. When not specified, the default page size is 100 records.
  ##   timestamp: JString
  ##            : UTC date and time specifying a time instance relative to which to evaluate each machine resource. Only applies when `live=false`. When not specified, the service uses DateTime.UtcNow.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568347 = query.getOrDefault("api-version")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "api-version", valid_568347
  var valid_568361 = query.getOrDefault("live")
  valid_568361 = validateParameter(valid_568361, JBool, required = false,
                                 default = newJBool(true))
  if valid_568361 != nil:
    section.add "live", valid_568361
  var valid_568362 = query.getOrDefault("endTime")
  valid_568362 = validateParameter(valid_568362, JString, required = false,
                                 default = nil)
  if valid_568362 != nil:
    section.add "endTime", valid_568362
  var valid_568363 = query.getOrDefault("$top")
  valid_568363 = validateParameter(valid_568363, JInt, required = false, default = nil)
  if valid_568363 != nil:
    section.add "$top", valid_568363
  var valid_568364 = query.getOrDefault("timestamp")
  valid_568364 = validateParameter(valid_568364, JString, required = false,
                                 default = nil)
  if valid_568364 != nil:
    section.add "timestamp", valid_568364
  var valid_568365 = query.getOrDefault("startTime")
  valid_568365 = validateParameter(valid_568365, JString, required = false,
                                 default = nil)
  if valid_568365 != nil:
    section.add "startTime", valid_568365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568366: Call_MachinesListByWorkspace_568341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of machines matching the specified conditions.  The returned collection represents either machines that are active/live during the specified interval  of time (`live=true` and `startTime`/`endTime` are specified) or that are known to have existed at or  some time prior to the specified point in time (`live=false` and `timestamp` is specified).
  ## 
  let valid = call_568366.validator(path, query, header, formData, body)
  let scheme = call_568366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568366.url(scheme.get, call_568366.host, call_568366.base,
                         call_568366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568366, url, valid)

proc call*(call_568367: Call_MachinesListByWorkspace_568341;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string; live: bool = true; endTime: string = ""; Top: int = 0;
          timestamp: string = ""; startTime: string = ""): Recallable =
  ## machinesListByWorkspace
  ## Returns a collection of machines matching the specified conditions.  The returned collection represents either machines that are active/live during the specified interval  of time (`live=true` and `startTime`/`endTime` are specified) or that are known to have existed at or  some time prior to the specified point in time (`live=false` and `timestamp` is specified).
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   live: bool
  ##       : Specifies whether to return live resources (true) or inventory resources (false). Defaults to **true**. When retrieving live resources, the start time (`startTime`) and end time (`endTime`) of the desired interval should be included. When retrieving inventory resources, an optional timestamp (`timestamp`) parameter can be specified to return the version of each resource closest (not-after) that timestamp.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   Top: int
  ##      : Page size to use. When not specified, the default page size is 100 records.
  ##   timestamp: string
  ##            : UTC date and time specifying a time instance relative to which to evaluate each machine resource. Only applies when `live=false`. When not specified, the service uses DateTime.UtcNow.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568368 = newJObject()
  var query_568369 = newJObject()
  add(path_568368, "resourceGroupName", newJString(resourceGroupName))
  add(query_568369, "api-version", newJString(apiVersion))
  add(path_568368, "subscriptionId", newJString(subscriptionId))
  add(query_568369, "live", newJBool(live))
  add(query_568369, "endTime", newJString(endTime))
  add(query_568369, "$top", newJInt(Top))
  add(query_568369, "timestamp", newJString(timestamp))
  add(query_568369, "startTime", newJString(startTime))
  add(path_568368, "workspaceName", newJString(workspaceName))
  result = call_568367.call(path_568368, query_568369, nil, nil, nil)

var machinesListByWorkspace* = Call_MachinesListByWorkspace_568341(
    name: "machinesListByWorkspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines",
    validator: validate_MachinesListByWorkspace_568342, base: "",
    url: url_MachinesListByWorkspace_568343, schemes: {Scheme.Https})
type
  Call_MachinesGet_568370 = ref object of OpenApiRestCall_567666
proc url_MachinesGet_568372(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machines/"),
               (kind: VariableSegment, value: "machineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesGet_568371(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568373 = path.getOrDefault("resourceGroupName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "resourceGroupName", valid_568373
  var valid_568374 = path.getOrDefault("machineName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "machineName", valid_568374
  var valid_568375 = path.getOrDefault("subscriptionId")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "subscriptionId", valid_568375
  var valid_568376 = path.getOrDefault("workspaceName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "workspaceName", valid_568376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   timestamp: JString
  ##            : UTC date and time specifying a time instance relative to which to evaluate the machine resource. When not specified, the service uses DateTime.UtcNow.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568377 = query.getOrDefault("api-version")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "api-version", valid_568377
  var valid_568378 = query.getOrDefault("timestamp")
  valid_568378 = validateParameter(valid_568378, JString, required = false,
                                 default = nil)
  if valid_568378 != nil:
    section.add "timestamp", valid_568378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568379: Call_MachinesGet_568370; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified machine.
  ## 
  let valid = call_568379.validator(path, query, header, formData, body)
  let scheme = call_568379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568379.url(scheme.get, call_568379.host, call_568379.base,
                         call_568379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568379, url, valid)

proc call*(call_568380: Call_MachinesGet_568370; resourceGroupName: string;
          apiVersion: string; machineName: string; subscriptionId: string;
          workspaceName: string; timestamp: string = ""): Recallable =
  ## machinesGet
  ## Returns the specified machine.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   timestamp: string
  ##            : UTC date and time specifying a time instance relative to which to evaluate the machine resource. When not specified, the service uses DateTime.UtcNow.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568381 = newJObject()
  var query_568382 = newJObject()
  add(path_568381, "resourceGroupName", newJString(resourceGroupName))
  add(query_568382, "api-version", newJString(apiVersion))
  add(path_568381, "machineName", newJString(machineName))
  add(path_568381, "subscriptionId", newJString(subscriptionId))
  add(query_568382, "timestamp", newJString(timestamp))
  add(path_568381, "workspaceName", newJString(workspaceName))
  result = call_568380.call(path_568381, query_568382, nil, nil, nil)

var machinesGet* = Call_MachinesGet_568370(name: "machinesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}",
                                        validator: validate_MachinesGet_568371,
                                        base: "", url: url_MachinesGet_568372,
                                        schemes: {Scheme.Https})
type
  Call_MachinesListConnections_568383 = ref object of OpenApiRestCall_567666
proc url_MachinesListConnections_568385(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machines/"),
               (kind: VariableSegment, value: "machineName"),
               (kind: ConstantSegment, value: "/connections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesListConnections_568384(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of connections terminating or originating at the specified machine
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568386 = path.getOrDefault("resourceGroupName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "resourceGroupName", valid_568386
  var valid_568387 = path.getOrDefault("machineName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "machineName", valid_568387
  var valid_568388 = path.getOrDefault("subscriptionId")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "subscriptionId", valid_568388
  var valid_568389 = path.getOrDefault("workspaceName")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "workspaceName", valid_568389
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568390 = query.getOrDefault("api-version")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "api-version", valid_568390
  var valid_568391 = query.getOrDefault("endTime")
  valid_568391 = validateParameter(valid_568391, JString, required = false,
                                 default = nil)
  if valid_568391 != nil:
    section.add "endTime", valid_568391
  var valid_568392 = query.getOrDefault("startTime")
  valid_568392 = validateParameter(valid_568392, JString, required = false,
                                 default = nil)
  if valid_568392 != nil:
    section.add "startTime", valid_568392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568393: Call_MachinesListConnections_568383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of connections terminating or originating at the specified machine
  ## 
  let valid = call_568393.validator(path, query, header, formData, body)
  let scheme = call_568393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568393.url(scheme.get, call_568393.host, call_568393.base,
                         call_568393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568393, url, valid)

proc call*(call_568394: Call_MachinesListConnections_568383;
          resourceGroupName: string; apiVersion: string; machineName: string;
          subscriptionId: string; workspaceName: string; endTime: string = "";
          startTime: string = ""): Recallable =
  ## machinesListConnections
  ## Returns a collection of connections terminating or originating at the specified machine
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568395 = newJObject()
  var query_568396 = newJObject()
  add(path_568395, "resourceGroupName", newJString(resourceGroupName))
  add(query_568396, "api-version", newJString(apiVersion))
  add(path_568395, "machineName", newJString(machineName))
  add(path_568395, "subscriptionId", newJString(subscriptionId))
  add(query_568396, "endTime", newJString(endTime))
  add(query_568396, "startTime", newJString(startTime))
  add(path_568395, "workspaceName", newJString(workspaceName))
  result = call_568394.call(path_568395, query_568396, nil, nil, nil)

var machinesListConnections* = Call_MachinesListConnections_568383(
    name: "machinesListConnections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/connections",
    validator: validate_MachinesListConnections_568384, base: "",
    url: url_MachinesListConnections_568385, schemes: {Scheme.Https})
type
  Call_MachinesGetLiveness_568397 = ref object of OpenApiRestCall_567666
proc url_MachinesGetLiveness_568399(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machines/"),
               (kind: VariableSegment, value: "machineName"),
               (kind: ConstantSegment, value: "/liveness")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesGetLiveness_568398(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Obtains the liveness status of the machine during the specified time interval.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568400 = path.getOrDefault("resourceGroupName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "resourceGroupName", valid_568400
  var valid_568401 = path.getOrDefault("machineName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "machineName", valid_568401
  var valid_568402 = path.getOrDefault("subscriptionId")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "subscriptionId", valid_568402
  var valid_568403 = path.getOrDefault("workspaceName")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "workspaceName", valid_568403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568404 = query.getOrDefault("api-version")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "api-version", valid_568404
  var valid_568405 = query.getOrDefault("endTime")
  valid_568405 = validateParameter(valid_568405, JString, required = false,
                                 default = nil)
  if valid_568405 != nil:
    section.add "endTime", valid_568405
  var valid_568406 = query.getOrDefault("startTime")
  valid_568406 = validateParameter(valid_568406, JString, required = false,
                                 default = nil)
  if valid_568406 != nil:
    section.add "startTime", valid_568406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568407: Call_MachinesGetLiveness_568397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Obtains the liveness status of the machine during the specified time interval.
  ## 
  let valid = call_568407.validator(path, query, header, formData, body)
  let scheme = call_568407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568407.url(scheme.get, call_568407.host, call_568407.base,
                         call_568407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568407, url, valid)

proc call*(call_568408: Call_MachinesGetLiveness_568397; resourceGroupName: string;
          apiVersion: string; machineName: string; subscriptionId: string;
          workspaceName: string; endTime: string = ""; startTime: string = ""): Recallable =
  ## machinesGetLiveness
  ## Obtains the liveness status of the machine during the specified time interval.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568409 = newJObject()
  var query_568410 = newJObject()
  add(path_568409, "resourceGroupName", newJString(resourceGroupName))
  add(query_568410, "api-version", newJString(apiVersion))
  add(path_568409, "machineName", newJString(machineName))
  add(path_568409, "subscriptionId", newJString(subscriptionId))
  add(query_568410, "endTime", newJString(endTime))
  add(query_568410, "startTime", newJString(startTime))
  add(path_568409, "workspaceName", newJString(workspaceName))
  result = call_568408.call(path_568409, query_568410, nil, nil, nil)

var machinesGetLiveness* = Call_MachinesGetLiveness_568397(
    name: "machinesGetLiveness", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/liveness",
    validator: validate_MachinesGetLiveness_568398, base: "",
    url: url_MachinesGetLiveness_568399, schemes: {Scheme.Https})
type
  Call_MachinesListMachineGroupMembership_568411 = ref object of OpenApiRestCall_567666
proc url_MachinesListMachineGroupMembership_568413(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machines/"),
               (kind: VariableSegment, value: "machineName"),
               (kind: ConstantSegment, value: "/machineGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesListMachineGroupMembership_568412(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of machine groups this machine belongs to during the specified time interval.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568414 = path.getOrDefault("resourceGroupName")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "resourceGroupName", valid_568414
  var valid_568415 = path.getOrDefault("machineName")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "machineName", valid_568415
  var valid_568416 = path.getOrDefault("subscriptionId")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "subscriptionId", valid_568416
  var valid_568417 = path.getOrDefault("workspaceName")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "workspaceName", valid_568417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568418 = query.getOrDefault("api-version")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "api-version", valid_568418
  var valid_568419 = query.getOrDefault("endTime")
  valid_568419 = validateParameter(valid_568419, JString, required = false,
                                 default = nil)
  if valid_568419 != nil:
    section.add "endTime", valid_568419
  var valid_568420 = query.getOrDefault("startTime")
  valid_568420 = validateParameter(valid_568420, JString, required = false,
                                 default = nil)
  if valid_568420 != nil:
    section.add "startTime", valid_568420
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568421: Call_MachinesListMachineGroupMembership_568411;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a collection of machine groups this machine belongs to during the specified time interval.
  ## 
  let valid = call_568421.validator(path, query, header, formData, body)
  let scheme = call_568421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568421.url(scheme.get, call_568421.host, call_568421.base,
                         call_568421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568421, url, valid)

proc call*(call_568422: Call_MachinesListMachineGroupMembership_568411;
          resourceGroupName: string; apiVersion: string; machineName: string;
          subscriptionId: string; workspaceName: string; endTime: string = "";
          startTime: string = ""): Recallable =
  ## machinesListMachineGroupMembership
  ## Returns a collection of machine groups this machine belongs to during the specified time interval.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568423 = newJObject()
  var query_568424 = newJObject()
  add(path_568423, "resourceGroupName", newJString(resourceGroupName))
  add(query_568424, "api-version", newJString(apiVersion))
  add(path_568423, "machineName", newJString(machineName))
  add(path_568423, "subscriptionId", newJString(subscriptionId))
  add(query_568424, "endTime", newJString(endTime))
  add(query_568424, "startTime", newJString(startTime))
  add(path_568423, "workspaceName", newJString(workspaceName))
  result = call_568422.call(path_568423, query_568424, nil, nil, nil)

var machinesListMachineGroupMembership* = Call_MachinesListMachineGroupMembership_568411(
    name: "machinesListMachineGroupMembership", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/machineGroups",
    validator: validate_MachinesListMachineGroupMembership_568412, base: "",
    url: url_MachinesListMachineGroupMembership_568413, schemes: {Scheme.Https})
type
  Call_MachinesListPorts_568425 = ref object of OpenApiRestCall_567666
proc url_MachinesListPorts_568427(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machines/"),
               (kind: VariableSegment, value: "machineName"),
               (kind: ConstantSegment, value: "/ports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesListPorts_568426(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns a collection of live ports on the specified machine during the specified time interval.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568428 = path.getOrDefault("resourceGroupName")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "resourceGroupName", valid_568428
  var valid_568429 = path.getOrDefault("machineName")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "machineName", valid_568429
  var valid_568430 = path.getOrDefault("subscriptionId")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "subscriptionId", valid_568430
  var valid_568431 = path.getOrDefault("workspaceName")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "workspaceName", valid_568431
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568432 = query.getOrDefault("api-version")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "api-version", valid_568432
  var valid_568433 = query.getOrDefault("endTime")
  valid_568433 = validateParameter(valid_568433, JString, required = false,
                                 default = nil)
  if valid_568433 != nil:
    section.add "endTime", valid_568433
  var valid_568434 = query.getOrDefault("startTime")
  valid_568434 = validateParameter(valid_568434, JString, required = false,
                                 default = nil)
  if valid_568434 != nil:
    section.add "startTime", valid_568434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568435: Call_MachinesListPorts_568425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of live ports on the specified machine during the specified time interval.
  ## 
  let valid = call_568435.validator(path, query, header, formData, body)
  let scheme = call_568435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568435.url(scheme.get, call_568435.host, call_568435.base,
                         call_568435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568435, url, valid)

proc call*(call_568436: Call_MachinesListPorts_568425; resourceGroupName: string;
          apiVersion: string; machineName: string; subscriptionId: string;
          workspaceName: string; endTime: string = ""; startTime: string = ""): Recallable =
  ## machinesListPorts
  ## Returns a collection of live ports on the specified machine during the specified time interval.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568437 = newJObject()
  var query_568438 = newJObject()
  add(path_568437, "resourceGroupName", newJString(resourceGroupName))
  add(query_568438, "api-version", newJString(apiVersion))
  add(path_568437, "machineName", newJString(machineName))
  add(path_568437, "subscriptionId", newJString(subscriptionId))
  add(query_568438, "endTime", newJString(endTime))
  add(query_568438, "startTime", newJString(startTime))
  add(path_568437, "workspaceName", newJString(workspaceName))
  result = call_568436.call(path_568437, query_568438, nil, nil, nil)

var machinesListPorts* = Call_MachinesListPorts_568425(name: "machinesListPorts",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/ports",
    validator: validate_MachinesListPorts_568426, base: "",
    url: url_MachinesListPorts_568427, schemes: {Scheme.Https})
type
  Call_PortsGet_568439 = ref object of OpenApiRestCall_567666
proc url_PortsGet_568441(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  assert "portName" in path, "`portName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machines/"),
               (kind: VariableSegment, value: "machineName"),
               (kind: ConstantSegment, value: "/ports/"),
               (kind: VariableSegment, value: "portName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PortsGet_568440(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified port. The port must be live during the specified time interval. If the port is not live during the interval, status 404 (Not Found) is returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   portName: JString (required)
  ##           : Port resource name.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568442 = path.getOrDefault("resourceGroupName")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "resourceGroupName", valid_568442
  var valid_568443 = path.getOrDefault("machineName")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "machineName", valid_568443
  var valid_568444 = path.getOrDefault("subscriptionId")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "subscriptionId", valid_568444
  var valid_568445 = path.getOrDefault("portName")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "portName", valid_568445
  var valid_568446 = path.getOrDefault("workspaceName")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "workspaceName", valid_568446
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568447 = query.getOrDefault("api-version")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "api-version", valid_568447
  var valid_568448 = query.getOrDefault("endTime")
  valid_568448 = validateParameter(valid_568448, JString, required = false,
                                 default = nil)
  if valid_568448 != nil:
    section.add "endTime", valid_568448
  var valid_568449 = query.getOrDefault("startTime")
  valid_568449 = validateParameter(valid_568449, JString, required = false,
                                 default = nil)
  if valid_568449 != nil:
    section.add "startTime", valid_568449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568450: Call_PortsGet_568439; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified port. The port must be live during the specified time interval. If the port is not live during the interval, status 404 (Not Found) is returned.
  ## 
  let valid = call_568450.validator(path, query, header, formData, body)
  let scheme = call_568450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568450.url(scheme.get, call_568450.host, call_568450.base,
                         call_568450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568450, url, valid)

proc call*(call_568451: Call_PortsGet_568439; resourceGroupName: string;
          apiVersion: string; machineName: string; subscriptionId: string;
          portName: string; workspaceName: string; endTime: string = "";
          startTime: string = ""): Recallable =
  ## portsGet
  ## Returns the specified port. The port must be live during the specified time interval. If the port is not live during the interval, status 404 (Not Found) is returned.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   portName: string (required)
  ##           : Port resource name.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568452 = newJObject()
  var query_568453 = newJObject()
  add(path_568452, "resourceGroupName", newJString(resourceGroupName))
  add(query_568453, "api-version", newJString(apiVersion))
  add(path_568452, "machineName", newJString(machineName))
  add(path_568452, "subscriptionId", newJString(subscriptionId))
  add(query_568453, "endTime", newJString(endTime))
  add(path_568452, "portName", newJString(portName))
  add(query_568453, "startTime", newJString(startTime))
  add(path_568452, "workspaceName", newJString(workspaceName))
  result = call_568451.call(path_568452, query_568453, nil, nil, nil)

var portsGet* = Call_PortsGet_568439(name: "portsGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/ports/{portName}",
                                  validator: validate_PortsGet_568440, base: "",
                                  url: url_PortsGet_568441,
                                  schemes: {Scheme.Https})
type
  Call_PortsListAcceptingProcesses_568454 = ref object of OpenApiRestCall_567666
proc url_PortsListAcceptingProcesses_568456(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  assert "portName" in path, "`portName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machines/"),
               (kind: VariableSegment, value: "machineName"),
               (kind: ConstantSegment, value: "/ports/"),
               (kind: VariableSegment, value: "portName"),
               (kind: ConstantSegment, value: "/acceptingProcesses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PortsListAcceptingProcesses_568455(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of processes accepting on the specified port
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   portName: JString (required)
  ##           : Port resource name.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568457 = path.getOrDefault("resourceGroupName")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "resourceGroupName", valid_568457
  var valid_568458 = path.getOrDefault("machineName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "machineName", valid_568458
  var valid_568459 = path.getOrDefault("subscriptionId")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "subscriptionId", valid_568459
  var valid_568460 = path.getOrDefault("portName")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "portName", valid_568460
  var valid_568461 = path.getOrDefault("workspaceName")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "workspaceName", valid_568461
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568462 = query.getOrDefault("api-version")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "api-version", valid_568462
  var valid_568463 = query.getOrDefault("endTime")
  valid_568463 = validateParameter(valid_568463, JString, required = false,
                                 default = nil)
  if valid_568463 != nil:
    section.add "endTime", valid_568463
  var valid_568464 = query.getOrDefault("startTime")
  valid_568464 = validateParameter(valid_568464, JString, required = false,
                                 default = nil)
  if valid_568464 != nil:
    section.add "startTime", valid_568464
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568465: Call_PortsListAcceptingProcesses_568454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of processes accepting on the specified port
  ## 
  let valid = call_568465.validator(path, query, header, formData, body)
  let scheme = call_568465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568465.url(scheme.get, call_568465.host, call_568465.base,
                         call_568465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568465, url, valid)

proc call*(call_568466: Call_PortsListAcceptingProcesses_568454;
          resourceGroupName: string; apiVersion: string; machineName: string;
          subscriptionId: string; portName: string; workspaceName: string;
          endTime: string = ""; startTime: string = ""): Recallable =
  ## portsListAcceptingProcesses
  ## Returns a collection of processes accepting on the specified port
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   portName: string (required)
  ##           : Port resource name.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568467 = newJObject()
  var query_568468 = newJObject()
  add(path_568467, "resourceGroupName", newJString(resourceGroupName))
  add(query_568468, "api-version", newJString(apiVersion))
  add(path_568467, "machineName", newJString(machineName))
  add(path_568467, "subscriptionId", newJString(subscriptionId))
  add(query_568468, "endTime", newJString(endTime))
  add(path_568467, "portName", newJString(portName))
  add(query_568468, "startTime", newJString(startTime))
  add(path_568467, "workspaceName", newJString(workspaceName))
  result = call_568466.call(path_568467, query_568468, nil, nil, nil)

var portsListAcceptingProcesses* = Call_PortsListAcceptingProcesses_568454(
    name: "portsListAcceptingProcesses", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/ports/{portName}/acceptingProcesses",
    validator: validate_PortsListAcceptingProcesses_568455, base: "",
    url: url_PortsListAcceptingProcesses_568456, schemes: {Scheme.Https})
type
  Call_PortsListConnections_568469 = ref object of OpenApiRestCall_567666
proc url_PortsListConnections_568471(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  assert "portName" in path, "`portName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machines/"),
               (kind: VariableSegment, value: "machineName"),
               (kind: ConstantSegment, value: "/ports/"),
               (kind: VariableSegment, value: "portName"),
               (kind: ConstantSegment, value: "/connections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PortsListConnections_568470(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of connections established via the specified port.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   portName: JString (required)
  ##           : Port resource name.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568472 = path.getOrDefault("resourceGroupName")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "resourceGroupName", valid_568472
  var valid_568473 = path.getOrDefault("machineName")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "machineName", valid_568473
  var valid_568474 = path.getOrDefault("subscriptionId")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "subscriptionId", valid_568474
  var valid_568475 = path.getOrDefault("portName")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "portName", valid_568475
  var valid_568476 = path.getOrDefault("workspaceName")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "workspaceName", valid_568476
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568477 = query.getOrDefault("api-version")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "api-version", valid_568477
  var valid_568478 = query.getOrDefault("endTime")
  valid_568478 = validateParameter(valid_568478, JString, required = false,
                                 default = nil)
  if valid_568478 != nil:
    section.add "endTime", valid_568478
  var valid_568479 = query.getOrDefault("startTime")
  valid_568479 = validateParameter(valid_568479, JString, required = false,
                                 default = nil)
  if valid_568479 != nil:
    section.add "startTime", valid_568479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568480: Call_PortsListConnections_568469; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of connections established via the specified port.
  ## 
  let valid = call_568480.validator(path, query, header, formData, body)
  let scheme = call_568480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568480.url(scheme.get, call_568480.host, call_568480.base,
                         call_568480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568480, url, valid)

proc call*(call_568481: Call_PortsListConnections_568469;
          resourceGroupName: string; apiVersion: string; machineName: string;
          subscriptionId: string; portName: string; workspaceName: string;
          endTime: string = ""; startTime: string = ""): Recallable =
  ## portsListConnections
  ## Returns a collection of connections established via the specified port.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   portName: string (required)
  ##           : Port resource name.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568482 = newJObject()
  var query_568483 = newJObject()
  add(path_568482, "resourceGroupName", newJString(resourceGroupName))
  add(query_568483, "api-version", newJString(apiVersion))
  add(path_568482, "machineName", newJString(machineName))
  add(path_568482, "subscriptionId", newJString(subscriptionId))
  add(query_568483, "endTime", newJString(endTime))
  add(path_568482, "portName", newJString(portName))
  add(query_568483, "startTime", newJString(startTime))
  add(path_568482, "workspaceName", newJString(workspaceName))
  result = call_568481.call(path_568482, query_568483, nil, nil, nil)

var portsListConnections* = Call_PortsListConnections_568469(
    name: "portsListConnections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/ports/{portName}/connections",
    validator: validate_PortsListConnections_568470, base: "",
    url: url_PortsListConnections_568471, schemes: {Scheme.Https})
type
  Call_PortsGetLiveness_568484 = ref object of OpenApiRestCall_567666
proc url_PortsGetLiveness_568486(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  assert "portName" in path, "`portName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machines/"),
               (kind: VariableSegment, value: "machineName"),
               (kind: ConstantSegment, value: "/ports/"),
               (kind: VariableSegment, value: "portName"),
               (kind: ConstantSegment, value: "/liveness")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PortsGetLiveness_568485(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Obtains the liveness status of the port during the specified time interval.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   portName: JString (required)
  ##           : Port resource name.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568487 = path.getOrDefault("resourceGroupName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "resourceGroupName", valid_568487
  var valid_568488 = path.getOrDefault("machineName")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "machineName", valid_568488
  var valid_568489 = path.getOrDefault("subscriptionId")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "subscriptionId", valid_568489
  var valid_568490 = path.getOrDefault("portName")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "portName", valid_568490
  var valid_568491 = path.getOrDefault("workspaceName")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "workspaceName", valid_568491
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568492 = query.getOrDefault("api-version")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "api-version", valid_568492
  var valid_568493 = query.getOrDefault("endTime")
  valid_568493 = validateParameter(valid_568493, JString, required = false,
                                 default = nil)
  if valid_568493 != nil:
    section.add "endTime", valid_568493
  var valid_568494 = query.getOrDefault("startTime")
  valid_568494 = validateParameter(valid_568494, JString, required = false,
                                 default = nil)
  if valid_568494 != nil:
    section.add "startTime", valid_568494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568495: Call_PortsGetLiveness_568484; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Obtains the liveness status of the port during the specified time interval.
  ## 
  let valid = call_568495.validator(path, query, header, formData, body)
  let scheme = call_568495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568495.url(scheme.get, call_568495.host, call_568495.base,
                         call_568495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568495, url, valid)

proc call*(call_568496: Call_PortsGetLiveness_568484; resourceGroupName: string;
          apiVersion: string; machineName: string; subscriptionId: string;
          portName: string; workspaceName: string; endTime: string = "";
          startTime: string = ""): Recallable =
  ## portsGetLiveness
  ## Obtains the liveness status of the port during the specified time interval.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   portName: string (required)
  ##           : Port resource name.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568497 = newJObject()
  var query_568498 = newJObject()
  add(path_568497, "resourceGroupName", newJString(resourceGroupName))
  add(query_568498, "api-version", newJString(apiVersion))
  add(path_568497, "machineName", newJString(machineName))
  add(path_568497, "subscriptionId", newJString(subscriptionId))
  add(query_568498, "endTime", newJString(endTime))
  add(path_568497, "portName", newJString(portName))
  add(query_568498, "startTime", newJString(startTime))
  add(path_568497, "workspaceName", newJString(workspaceName))
  result = call_568496.call(path_568497, query_568498, nil, nil, nil)

var portsGetLiveness* = Call_PortsGetLiveness_568484(name: "portsGetLiveness",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/ports/{portName}/liveness",
    validator: validate_PortsGetLiveness_568485, base: "",
    url: url_PortsGetLiveness_568486, schemes: {Scheme.Https})
type
  Call_MachinesListProcesses_568499 = ref object of OpenApiRestCall_567666
proc url_MachinesListProcesses_568501(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machines/"),
               (kind: VariableSegment, value: "machineName"),
               (kind: ConstantSegment, value: "/processes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesListProcesses_568500(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of processes on the specified machine matching the specified conditions. The returned collection represents either processes that are active/live during the specified interval  of time (`live=true` and `startTime`/`endTime` are specified) or that are known to have existed at or  some time prior to the specified point in time (`live=false` and `timestamp` is specified).        
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568502 = path.getOrDefault("resourceGroupName")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "resourceGroupName", valid_568502
  var valid_568503 = path.getOrDefault("machineName")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "machineName", valid_568503
  var valid_568504 = path.getOrDefault("subscriptionId")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "subscriptionId", valid_568504
  var valid_568505 = path.getOrDefault("workspaceName")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "workspaceName", valid_568505
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   live: JBool
  ##       : Specifies whether to return live resources (true) or inventory resources (false). Defaults to **true**. When retrieving live resources, the start time (`startTime`) and end time (`endTime`) of the desired interval should be included. When retrieving inventory resources, an optional timestamp (`timestamp`) parameter can be specified to return the version of each resource closest (not-after) that timestamp.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   timestamp: JString
  ##            : UTC date and time specifying a time instance relative to which to evaluate all process resource. Only applies when `live=false`. When not specified, the service uses DateTime.UtcNow.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568506 = query.getOrDefault("api-version")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "api-version", valid_568506
  var valid_568507 = query.getOrDefault("live")
  valid_568507 = validateParameter(valid_568507, JBool, required = false,
                                 default = newJBool(true))
  if valid_568507 != nil:
    section.add "live", valid_568507
  var valid_568508 = query.getOrDefault("endTime")
  valid_568508 = validateParameter(valid_568508, JString, required = false,
                                 default = nil)
  if valid_568508 != nil:
    section.add "endTime", valid_568508
  var valid_568509 = query.getOrDefault("timestamp")
  valid_568509 = validateParameter(valid_568509, JString, required = false,
                                 default = nil)
  if valid_568509 != nil:
    section.add "timestamp", valid_568509
  var valid_568510 = query.getOrDefault("startTime")
  valid_568510 = validateParameter(valid_568510, JString, required = false,
                                 default = nil)
  if valid_568510 != nil:
    section.add "startTime", valid_568510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568511: Call_MachinesListProcesses_568499; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of processes on the specified machine matching the specified conditions. The returned collection represents either processes that are active/live during the specified interval  of time (`live=true` and `startTime`/`endTime` are specified) or that are known to have existed at or  some time prior to the specified point in time (`live=false` and `timestamp` is specified).        
  ## 
  let valid = call_568511.validator(path, query, header, formData, body)
  let scheme = call_568511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568511.url(scheme.get, call_568511.host, call_568511.base,
                         call_568511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568511, url, valid)

proc call*(call_568512: Call_MachinesListProcesses_568499;
          resourceGroupName: string; apiVersion: string; machineName: string;
          subscriptionId: string; workspaceName: string; live: bool = true;
          endTime: string = ""; timestamp: string = ""; startTime: string = ""): Recallable =
  ## machinesListProcesses
  ## Returns a collection of processes on the specified machine matching the specified conditions. The returned collection represents either processes that are active/live during the specified interval  of time (`live=true` and `startTime`/`endTime` are specified) or that are known to have existed at or  some time prior to the specified point in time (`live=false` and `timestamp` is specified).        
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   live: bool
  ##       : Specifies whether to return live resources (true) or inventory resources (false). Defaults to **true**. When retrieving live resources, the start time (`startTime`) and end time (`endTime`) of the desired interval should be included. When retrieving inventory resources, an optional timestamp (`timestamp`) parameter can be specified to return the version of each resource closest (not-after) that timestamp.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   timestamp: string
  ##            : UTC date and time specifying a time instance relative to which to evaluate all process resource. Only applies when `live=false`. When not specified, the service uses DateTime.UtcNow.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568513 = newJObject()
  var query_568514 = newJObject()
  add(path_568513, "resourceGroupName", newJString(resourceGroupName))
  add(query_568514, "api-version", newJString(apiVersion))
  add(path_568513, "machineName", newJString(machineName))
  add(path_568513, "subscriptionId", newJString(subscriptionId))
  add(query_568514, "live", newJBool(live))
  add(query_568514, "endTime", newJString(endTime))
  add(query_568514, "timestamp", newJString(timestamp))
  add(query_568514, "startTime", newJString(startTime))
  add(path_568513, "workspaceName", newJString(workspaceName))
  result = call_568512.call(path_568513, query_568514, nil, nil, nil)

var machinesListProcesses* = Call_MachinesListProcesses_568499(
    name: "machinesListProcesses", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/processes",
    validator: validate_MachinesListProcesses_568500, base: "",
    url: url_MachinesListProcesses_568501, schemes: {Scheme.Https})
type
  Call_ProcessesGet_568515 = ref object of OpenApiRestCall_567666
proc url_ProcessesGet_568517(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  assert "processName" in path, "`processName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machines/"),
               (kind: VariableSegment, value: "machineName"),
               (kind: ConstantSegment, value: "/processes/"),
               (kind: VariableSegment, value: "processName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProcessesGet_568516(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified process.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   processName: JString (required)
  ##              : Process resource name.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568518 = path.getOrDefault("resourceGroupName")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "resourceGroupName", valid_568518
  var valid_568519 = path.getOrDefault("machineName")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "machineName", valid_568519
  var valid_568520 = path.getOrDefault("subscriptionId")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "subscriptionId", valid_568520
  var valid_568521 = path.getOrDefault("processName")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "processName", valid_568521
  var valid_568522 = path.getOrDefault("workspaceName")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "workspaceName", valid_568522
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   timestamp: JString
  ##            : UTC date and time specifying a time instance relative to which to evaluate a resource. When not specified, the service uses DateTime.UtcNow.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568523 = query.getOrDefault("api-version")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "api-version", valid_568523
  var valid_568524 = query.getOrDefault("timestamp")
  valid_568524 = validateParameter(valid_568524, JString, required = false,
                                 default = nil)
  if valid_568524 != nil:
    section.add "timestamp", valid_568524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568525: Call_ProcessesGet_568515; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified process.
  ## 
  let valid = call_568525.validator(path, query, header, formData, body)
  let scheme = call_568525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568525.url(scheme.get, call_568525.host, call_568525.base,
                         call_568525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568525, url, valid)

proc call*(call_568526: Call_ProcessesGet_568515; resourceGroupName: string;
          apiVersion: string; machineName: string; subscriptionId: string;
          processName: string; workspaceName: string; timestamp: string = ""): Recallable =
  ## processesGet
  ## Returns the specified process.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   processName: string (required)
  ##              : Process resource name.
  ##   timestamp: string
  ##            : UTC date and time specifying a time instance relative to which to evaluate a resource. When not specified, the service uses DateTime.UtcNow.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568527 = newJObject()
  var query_568528 = newJObject()
  add(path_568527, "resourceGroupName", newJString(resourceGroupName))
  add(query_568528, "api-version", newJString(apiVersion))
  add(path_568527, "machineName", newJString(machineName))
  add(path_568527, "subscriptionId", newJString(subscriptionId))
  add(path_568527, "processName", newJString(processName))
  add(query_568528, "timestamp", newJString(timestamp))
  add(path_568527, "workspaceName", newJString(workspaceName))
  result = call_568526.call(path_568527, query_568528, nil, nil, nil)

var processesGet* = Call_ProcessesGet_568515(name: "processesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/processes/{processName}",
    validator: validate_ProcessesGet_568516, base: "", url: url_ProcessesGet_568517,
    schemes: {Scheme.Https})
type
  Call_ProcessesListAcceptingPorts_568529 = ref object of OpenApiRestCall_567666
proc url_ProcessesListAcceptingPorts_568531(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  assert "processName" in path, "`processName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machines/"),
               (kind: VariableSegment, value: "machineName"),
               (kind: ConstantSegment, value: "/processes/"),
               (kind: VariableSegment, value: "processName"),
               (kind: ConstantSegment, value: "/acceptingPorts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProcessesListAcceptingPorts_568530(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of ports on which this process is accepting
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   processName: JString (required)
  ##              : Process resource name.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568532 = path.getOrDefault("resourceGroupName")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "resourceGroupName", valid_568532
  var valid_568533 = path.getOrDefault("machineName")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "machineName", valid_568533
  var valid_568534 = path.getOrDefault("subscriptionId")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "subscriptionId", valid_568534
  var valid_568535 = path.getOrDefault("processName")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "processName", valid_568535
  var valid_568536 = path.getOrDefault("workspaceName")
  valid_568536 = validateParameter(valid_568536, JString, required = true,
                                 default = nil)
  if valid_568536 != nil:
    section.add "workspaceName", valid_568536
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568537 = query.getOrDefault("api-version")
  valid_568537 = validateParameter(valid_568537, JString, required = true,
                                 default = nil)
  if valid_568537 != nil:
    section.add "api-version", valid_568537
  var valid_568538 = query.getOrDefault("endTime")
  valid_568538 = validateParameter(valid_568538, JString, required = false,
                                 default = nil)
  if valid_568538 != nil:
    section.add "endTime", valid_568538
  var valid_568539 = query.getOrDefault("startTime")
  valid_568539 = validateParameter(valid_568539, JString, required = false,
                                 default = nil)
  if valid_568539 != nil:
    section.add "startTime", valid_568539
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568540: Call_ProcessesListAcceptingPorts_568529; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of ports on which this process is accepting
  ## 
  let valid = call_568540.validator(path, query, header, formData, body)
  let scheme = call_568540.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568540.url(scheme.get, call_568540.host, call_568540.base,
                         call_568540.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568540, url, valid)

proc call*(call_568541: Call_ProcessesListAcceptingPorts_568529;
          resourceGroupName: string; apiVersion: string; machineName: string;
          subscriptionId: string; processName: string; workspaceName: string;
          endTime: string = ""; startTime: string = ""): Recallable =
  ## processesListAcceptingPorts
  ## Returns a collection of ports on which this process is accepting
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   processName: string (required)
  ##              : Process resource name.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568542 = newJObject()
  var query_568543 = newJObject()
  add(path_568542, "resourceGroupName", newJString(resourceGroupName))
  add(query_568543, "api-version", newJString(apiVersion))
  add(path_568542, "machineName", newJString(machineName))
  add(path_568542, "subscriptionId", newJString(subscriptionId))
  add(query_568543, "endTime", newJString(endTime))
  add(path_568542, "processName", newJString(processName))
  add(query_568543, "startTime", newJString(startTime))
  add(path_568542, "workspaceName", newJString(workspaceName))
  result = call_568541.call(path_568542, query_568543, nil, nil, nil)

var processesListAcceptingPorts* = Call_ProcessesListAcceptingPorts_568529(
    name: "processesListAcceptingPorts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/processes/{processName}/acceptingPorts",
    validator: validate_ProcessesListAcceptingPorts_568530, base: "",
    url: url_ProcessesListAcceptingPorts_568531, schemes: {Scheme.Https})
type
  Call_ProcessesListConnections_568544 = ref object of OpenApiRestCall_567666
proc url_ProcessesListConnections_568546(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  assert "processName" in path, "`processName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machines/"),
               (kind: VariableSegment, value: "machineName"),
               (kind: ConstantSegment, value: "/processes/"),
               (kind: VariableSegment, value: "processName"),
               (kind: ConstantSegment, value: "/connections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProcessesListConnections_568545(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of connections terminating or originating at the specified process
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   processName: JString (required)
  ##              : Process resource name.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568547 = path.getOrDefault("resourceGroupName")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "resourceGroupName", valid_568547
  var valid_568548 = path.getOrDefault("machineName")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "machineName", valid_568548
  var valid_568549 = path.getOrDefault("subscriptionId")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "subscriptionId", valid_568549
  var valid_568550 = path.getOrDefault("processName")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "processName", valid_568550
  var valid_568551 = path.getOrDefault("workspaceName")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "workspaceName", valid_568551
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568552 = query.getOrDefault("api-version")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "api-version", valid_568552
  var valid_568553 = query.getOrDefault("endTime")
  valid_568553 = validateParameter(valid_568553, JString, required = false,
                                 default = nil)
  if valid_568553 != nil:
    section.add "endTime", valid_568553
  var valid_568554 = query.getOrDefault("startTime")
  valid_568554 = validateParameter(valid_568554, JString, required = false,
                                 default = nil)
  if valid_568554 != nil:
    section.add "startTime", valid_568554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568555: Call_ProcessesListConnections_568544; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of connections terminating or originating at the specified process
  ## 
  let valid = call_568555.validator(path, query, header, formData, body)
  let scheme = call_568555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568555.url(scheme.get, call_568555.host, call_568555.base,
                         call_568555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568555, url, valid)

proc call*(call_568556: Call_ProcessesListConnections_568544;
          resourceGroupName: string; apiVersion: string; machineName: string;
          subscriptionId: string; processName: string; workspaceName: string;
          endTime: string = ""; startTime: string = ""): Recallable =
  ## processesListConnections
  ## Returns a collection of connections terminating or originating at the specified process
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   processName: string (required)
  ##              : Process resource name.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568557 = newJObject()
  var query_568558 = newJObject()
  add(path_568557, "resourceGroupName", newJString(resourceGroupName))
  add(query_568558, "api-version", newJString(apiVersion))
  add(path_568557, "machineName", newJString(machineName))
  add(path_568557, "subscriptionId", newJString(subscriptionId))
  add(query_568558, "endTime", newJString(endTime))
  add(path_568557, "processName", newJString(processName))
  add(query_568558, "startTime", newJString(startTime))
  add(path_568557, "workspaceName", newJString(workspaceName))
  result = call_568556.call(path_568557, query_568558, nil, nil, nil)

var processesListConnections* = Call_ProcessesListConnections_568544(
    name: "processesListConnections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/processes/{processName}/connections",
    validator: validate_ProcessesListConnections_568545, base: "",
    url: url_ProcessesListConnections_568546, schemes: {Scheme.Https})
type
  Call_ProcessesGetLiveness_568559 = ref object of OpenApiRestCall_567666
proc url_ProcessesGetLiveness_568561(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  assert "processName" in path, "`processName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/machines/"),
               (kind: VariableSegment, value: "machineName"),
               (kind: ConstantSegment, value: "/processes/"),
               (kind: VariableSegment, value: "processName"),
               (kind: ConstantSegment, value: "/liveness")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProcessesGetLiveness_568560(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Obtains the liveness status of the process during the specified time interval.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   processName: JString (required)
  ##              : Process resource name.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568562 = path.getOrDefault("resourceGroupName")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "resourceGroupName", valid_568562
  var valid_568563 = path.getOrDefault("machineName")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "machineName", valid_568563
  var valid_568564 = path.getOrDefault("subscriptionId")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "subscriptionId", valid_568564
  var valid_568565 = path.getOrDefault("processName")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "processName", valid_568565
  var valid_568566 = path.getOrDefault("workspaceName")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "workspaceName", valid_568566
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568567 = query.getOrDefault("api-version")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "api-version", valid_568567
  var valid_568568 = query.getOrDefault("endTime")
  valid_568568 = validateParameter(valid_568568, JString, required = false,
                                 default = nil)
  if valid_568568 != nil:
    section.add "endTime", valid_568568
  var valid_568569 = query.getOrDefault("startTime")
  valid_568569 = validateParameter(valid_568569, JString, required = false,
                                 default = nil)
  if valid_568569 != nil:
    section.add "startTime", valid_568569
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568570: Call_ProcessesGetLiveness_568559; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Obtains the liveness status of the process during the specified time interval.
  ## 
  let valid = call_568570.validator(path, query, header, formData, body)
  let scheme = call_568570.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568570.url(scheme.get, call_568570.host, call_568570.base,
                         call_568570.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568570, url, valid)

proc call*(call_568571: Call_ProcessesGetLiveness_568559;
          resourceGroupName: string; apiVersion: string; machineName: string;
          subscriptionId: string; processName: string; workspaceName: string;
          endTime: string = ""; startTime: string = ""): Recallable =
  ## processesGetLiveness
  ## Obtains the liveness status of the process during the specified time interval.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   processName: string (required)
  ##              : Process resource name.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568572 = newJObject()
  var query_568573 = newJObject()
  add(path_568572, "resourceGroupName", newJString(resourceGroupName))
  add(query_568573, "api-version", newJString(apiVersion))
  add(path_568572, "machineName", newJString(machineName))
  add(path_568572, "subscriptionId", newJString(subscriptionId))
  add(query_568573, "endTime", newJString(endTime))
  add(path_568572, "processName", newJString(processName))
  add(query_568573, "startTime", newJString(startTime))
  add(path_568572, "workspaceName", newJString(workspaceName))
  result = call_568571.call(path_568572, query_568573, nil, nil, nil)

var processesGetLiveness* = Call_ProcessesGetLiveness_568559(
    name: "processesGetLiveness", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/processes/{processName}/liveness",
    validator: validate_ProcessesGetLiveness_568560, base: "",
    url: url_ProcessesGetLiveness_568561, schemes: {Scheme.Https})
type
  Call_SummariesGetMachines_568574 = ref object of OpenApiRestCall_567666
proc url_SummariesGetMachines_568576(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/features/serviceMap/summaries/machines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SummariesGetMachines_568575(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns summary information about the machines in the workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568577 = path.getOrDefault("resourceGroupName")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "resourceGroupName", valid_568577
  var valid_568578 = path.getOrDefault("subscriptionId")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "subscriptionId", valid_568578
  var valid_568579 = path.getOrDefault("workspaceName")
  valid_568579 = validateParameter(valid_568579, JString, required = true,
                                 default = nil)
  if valid_568579 != nil:
    section.add "workspaceName", valid_568579
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568580 = query.getOrDefault("api-version")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "api-version", valid_568580
  var valid_568581 = query.getOrDefault("endTime")
  valid_568581 = validateParameter(valid_568581, JString, required = false,
                                 default = nil)
  if valid_568581 != nil:
    section.add "endTime", valid_568581
  var valid_568582 = query.getOrDefault("startTime")
  valid_568582 = validateParameter(valid_568582, JString, required = false,
                                 default = nil)
  if valid_568582 != nil:
    section.add "startTime", valid_568582
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568583: Call_SummariesGetMachines_568574; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns summary information about the machines in the workspace.
  ## 
  let valid = call_568583.validator(path, query, header, formData, body)
  let scheme = call_568583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568583.url(scheme.get, call_568583.host, call_568583.base,
                         call_568583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568583, url, valid)

proc call*(call_568584: Call_SummariesGetMachines_568574;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string; endTime: string = ""; startTime: string = ""): Recallable =
  ## summariesGetMachines
  ## Returns summary information about the machines in the workspace.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_568585 = newJObject()
  var query_568586 = newJObject()
  add(path_568585, "resourceGroupName", newJString(resourceGroupName))
  add(query_568586, "api-version", newJString(apiVersion))
  add(path_568585, "subscriptionId", newJString(subscriptionId))
  add(query_568586, "endTime", newJString(endTime))
  add(query_568586, "startTime", newJString(startTime))
  add(path_568585, "workspaceName", newJString(workspaceName))
  result = call_568584.call(path_568585, query_568586, nil, nil, nil)

var summariesGetMachines* = Call_SummariesGetMachines_568574(
    name: "summariesGetMachines", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/summaries/machines",
    validator: validate_SummariesGetMachines_568575, base: "",
    url: url_SummariesGetMachines_568576, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
