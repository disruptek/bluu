
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563564 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563564](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563564): Option[Scheme] {.used.} =
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
  macServiceName = "service-map-arm-service-map"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClientGroupsGet_563786 = ref object of OpenApiRestCall_563564
proc url_ClientGroupsGet_563788(protocol: Scheme; host: string; base: string;
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

proc validate_ClientGroupsGet_563787(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Retrieves the specified client group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   clientGroupName: JString (required)
  ##                  : Client Group resource name.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563963 = path.getOrDefault("subscriptionId")
  valid_563963 = validateParameter(valid_563963, JString, required = true,
                                 default = nil)
  if valid_563963 != nil:
    section.add "subscriptionId", valid_563963
  var valid_563964 = path.getOrDefault("clientGroupName")
  valid_563964 = validateParameter(valid_563964, JString, required = true,
                                 default = nil)
  if valid_563964 != nil:
    section.add "clientGroupName", valid_563964
  var valid_563965 = path.getOrDefault("resourceGroupName")
  valid_563965 = validateParameter(valid_563965, JString, required = true,
                                 default = nil)
  if valid_563965 != nil:
    section.add "resourceGroupName", valid_563965
  var valid_563966 = path.getOrDefault("workspaceName")
  valid_563966 = validateParameter(valid_563966, JString, required = true,
                                 default = nil)
  if valid_563966 != nil:
    section.add "workspaceName", valid_563966
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563967 = query.getOrDefault("api-version")
  valid_563967 = validateParameter(valid_563967, JString, required = true,
                                 default = nil)
  if valid_563967 != nil:
    section.add "api-version", valid_563967
  var valid_563968 = query.getOrDefault("startTime")
  valid_563968 = validateParameter(valid_563968, JString, required = false,
                                 default = nil)
  if valid_563968 != nil:
    section.add "startTime", valid_563968
  var valid_563969 = query.getOrDefault("endTime")
  valid_563969 = validateParameter(valid_563969, JString, required = false,
                                 default = nil)
  if valid_563969 != nil:
    section.add "endTime", valid_563969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563992: Call_ClientGroupsGet_563786; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified client group
  ## 
  let valid = call_563992.validator(path, query, header, formData, body)
  let scheme = call_563992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563992.url(scheme.get, call_563992.host, call_563992.base,
                         call_563992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563992, url, valid)

proc call*(call_564063: Call_ClientGroupsGet_563786; apiVersion: string;
          subscriptionId: string; clientGroupName: string;
          resourceGroupName: string; workspaceName: string; startTime: string = "";
          endTime: string = ""): Recallable =
  ## clientGroupsGet
  ## Retrieves the specified client group
  ##   apiVersion: string (required)
  ##             : API version.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   clientGroupName: string (required)
  ##                  : Client Group resource name.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564064 = newJObject()
  var query_564066 = newJObject()
  add(query_564066, "api-version", newJString(apiVersion))
  add(query_564066, "startTime", newJString(startTime))
  add(path_564064, "subscriptionId", newJString(subscriptionId))
  add(path_564064, "clientGroupName", newJString(clientGroupName))
  add(path_564064, "resourceGroupName", newJString(resourceGroupName))
  add(path_564064, "workspaceName", newJString(workspaceName))
  add(query_564066, "endTime", newJString(endTime))
  result = call_564063.call(path_564064, query_564066, nil, nil, nil)

var clientGroupsGet* = Call_ClientGroupsGet_563786(name: "clientGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/clientGroups/{clientGroupName}",
    validator: validate_ClientGroupsGet_563787, base: "", url: url_ClientGroupsGet_563788,
    schemes: {Scheme.Https})
type
  Call_ClientGroupsListMembers_564105 = ref object of OpenApiRestCall_563564
proc url_ClientGroupsListMembers_564107(protocol: Scheme; host: string; base: string;
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

proc validate_ClientGroupsListMembers_564106(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the members of the client group during the specified time interval.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   clientGroupName: JString (required)
  ##                  : Client Group resource name.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564109 = path.getOrDefault("subscriptionId")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "subscriptionId", valid_564109
  var valid_564110 = path.getOrDefault("clientGroupName")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "clientGroupName", valid_564110
  var valid_564111 = path.getOrDefault("resourceGroupName")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "resourceGroupName", valid_564111
  var valid_564112 = path.getOrDefault("workspaceName")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "workspaceName", valid_564112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   $top: JInt
  ##       : Page size to use. When not specified, the default page size is 100 records.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564113 = query.getOrDefault("api-version")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "api-version", valid_564113
  var valid_564114 = query.getOrDefault("$top")
  valid_564114 = validateParameter(valid_564114, JInt, required = false, default = nil)
  if valid_564114 != nil:
    section.add "$top", valid_564114
  var valid_564115 = query.getOrDefault("startTime")
  valid_564115 = validateParameter(valid_564115, JString, required = false,
                                 default = nil)
  if valid_564115 != nil:
    section.add "startTime", valid_564115
  var valid_564116 = query.getOrDefault("endTime")
  valid_564116 = validateParameter(valid_564116, JString, required = false,
                                 default = nil)
  if valid_564116 != nil:
    section.add "endTime", valid_564116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564117: Call_ClientGroupsListMembers_564105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the members of the client group during the specified time interval.
  ## 
  let valid = call_564117.validator(path, query, header, formData, body)
  let scheme = call_564117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564117.url(scheme.get, call_564117.host, call_564117.base,
                         call_564117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564117, url, valid)

proc call*(call_564118: Call_ClientGroupsListMembers_564105; apiVersion: string;
          subscriptionId: string; clientGroupName: string;
          resourceGroupName: string; workspaceName: string; Top: int = 0;
          startTime: string = ""; endTime: string = ""): Recallable =
  ## clientGroupsListMembers
  ## Returns the members of the client group during the specified time interval.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   Top: int
  ##      : Page size to use. When not specified, the default page size is 100 records.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   clientGroupName: string (required)
  ##                  : Client Group resource name.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564119 = newJObject()
  var query_564120 = newJObject()
  add(query_564120, "api-version", newJString(apiVersion))
  add(query_564120, "$top", newJInt(Top))
  add(query_564120, "startTime", newJString(startTime))
  add(path_564119, "subscriptionId", newJString(subscriptionId))
  add(path_564119, "clientGroupName", newJString(clientGroupName))
  add(path_564119, "resourceGroupName", newJString(resourceGroupName))
  add(path_564119, "workspaceName", newJString(workspaceName))
  add(query_564120, "endTime", newJString(endTime))
  result = call_564118.call(path_564119, query_564120, nil, nil, nil)

var clientGroupsListMembers* = Call_ClientGroupsListMembers_564105(
    name: "clientGroupsListMembers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/clientGroups/{clientGroupName}/members",
    validator: validate_ClientGroupsListMembers_564106, base: "",
    url: url_ClientGroupsListMembers_564107, schemes: {Scheme.Https})
type
  Call_ClientGroupsGetMembersCount_564121 = ref object of OpenApiRestCall_563564
proc url_ClientGroupsGetMembersCount_564123(protocol: Scheme; host: string;
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

proc validate_ClientGroupsGetMembersCount_564122(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the approximate number of members in the client group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   clientGroupName: JString (required)
  ##                  : Client Group resource name.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564124 = path.getOrDefault("subscriptionId")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "subscriptionId", valid_564124
  var valid_564125 = path.getOrDefault("clientGroupName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "clientGroupName", valid_564125
  var valid_564126 = path.getOrDefault("resourceGroupName")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "resourceGroupName", valid_564126
  var valid_564127 = path.getOrDefault("workspaceName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "workspaceName", valid_564127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564128 = query.getOrDefault("api-version")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "api-version", valid_564128
  var valid_564129 = query.getOrDefault("startTime")
  valid_564129 = validateParameter(valid_564129, JString, required = false,
                                 default = nil)
  if valid_564129 != nil:
    section.add "startTime", valid_564129
  var valid_564130 = query.getOrDefault("endTime")
  valid_564130 = validateParameter(valid_564130, JString, required = false,
                                 default = nil)
  if valid_564130 != nil:
    section.add "endTime", valid_564130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564131: Call_ClientGroupsGetMembersCount_564121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the approximate number of members in the client group.
  ## 
  let valid = call_564131.validator(path, query, header, formData, body)
  let scheme = call_564131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564131.url(scheme.get, call_564131.host, call_564131.base,
                         call_564131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564131, url, valid)

proc call*(call_564132: Call_ClientGroupsGetMembersCount_564121;
          apiVersion: string; subscriptionId: string; clientGroupName: string;
          resourceGroupName: string; workspaceName: string; startTime: string = "";
          endTime: string = ""): Recallable =
  ## clientGroupsGetMembersCount
  ## Returns the approximate number of members in the client group.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   clientGroupName: string (required)
  ##                  : Client Group resource name.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564133 = newJObject()
  var query_564134 = newJObject()
  add(query_564134, "api-version", newJString(apiVersion))
  add(query_564134, "startTime", newJString(startTime))
  add(path_564133, "subscriptionId", newJString(subscriptionId))
  add(path_564133, "clientGroupName", newJString(clientGroupName))
  add(path_564133, "resourceGroupName", newJString(resourceGroupName))
  add(path_564133, "workspaceName", newJString(workspaceName))
  add(query_564134, "endTime", newJString(endTime))
  result = call_564132.call(path_564133, query_564134, nil, nil, nil)

var clientGroupsGetMembersCount* = Call_ClientGroupsGetMembersCount_564121(
    name: "clientGroupsGetMembersCount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/clientGroups/{clientGroupName}/membersCount",
    validator: validate_ClientGroupsGetMembersCount_564122, base: "",
    url: url_ClientGroupsGetMembersCount_564123, schemes: {Scheme.Https})
type
  Call_MapsGenerate_564135 = ref object of OpenApiRestCall_563564
proc url_MapsGenerate_564137(protocol: Scheme; host: string; base: string;
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

proc validate_MapsGenerate_564136(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates the specified map.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564138 = path.getOrDefault("subscriptionId")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "subscriptionId", valid_564138
  var valid_564139 = path.getOrDefault("resourceGroupName")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "resourceGroupName", valid_564139
  var valid_564140 = path.getOrDefault("workspaceName")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "workspaceName", valid_564140
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
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
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : Request options.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564143: Call_MapsGenerate_564135; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates the specified map.
  ## 
  let valid = call_564143.validator(path, query, header, formData, body)
  let scheme = call_564143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564143.url(scheme.get, call_564143.host, call_564143.base,
                         call_564143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564143, url, valid)

proc call*(call_564144: Call_MapsGenerate_564135; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; workspaceName: string;
          request: JsonNode): Recallable =
  ## mapsGenerate
  ## Generates the specified map.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   request: JObject (required)
  ##          : Request options.
  var path_564145 = newJObject()
  var query_564146 = newJObject()
  var body_564147 = newJObject()
  add(query_564146, "api-version", newJString(apiVersion))
  add(path_564145, "subscriptionId", newJString(subscriptionId))
  add(path_564145, "resourceGroupName", newJString(resourceGroupName))
  add(path_564145, "workspaceName", newJString(workspaceName))
  if request != nil:
    body_564147 = request
  result = call_564144.call(path_564145, query_564146, nil, nil, body_564147)

var mapsGenerate* = Call_MapsGenerate_564135(name: "mapsGenerate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/generateMap",
    validator: validate_MapsGenerate_564136, base: "", url: url_MapsGenerate_564137,
    schemes: {Scheme.Https})
type
  Call_MachineGroupsCreate_564161 = ref object of OpenApiRestCall_563564
proc url_MachineGroupsCreate_564163(protocol: Scheme; host: string; base: string;
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

proc validate_MachineGroupsCreate_564162(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new machine group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564191 = path.getOrDefault("subscriptionId")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "subscriptionId", valid_564191
  var valid_564192 = path.getOrDefault("resourceGroupName")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "resourceGroupName", valid_564192
  var valid_564193 = path.getOrDefault("workspaceName")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "workspaceName", valid_564193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564194 = query.getOrDefault("api-version")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "api-version", valid_564194
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

proc call*(call_564196: Call_MachineGroupsCreate_564161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new machine group.
  ## 
  let valid = call_564196.validator(path, query, header, formData, body)
  let scheme = call_564196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564196.url(scheme.get, call_564196.host, call_564196.base,
                         call_564196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564196, url, valid)

proc call*(call_564197: Call_MachineGroupsCreate_564161; machineGroup: JsonNode;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          workspaceName: string): Recallable =
  ## machineGroupsCreate
  ## Creates a new machine group.
  ##   machineGroup: JObject (required)
  ##               : Machine Group resource to create.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_564198 = newJObject()
  var query_564199 = newJObject()
  var body_564200 = newJObject()
  if machineGroup != nil:
    body_564200 = machineGroup
  add(query_564199, "api-version", newJString(apiVersion))
  add(path_564198, "subscriptionId", newJString(subscriptionId))
  add(path_564198, "resourceGroupName", newJString(resourceGroupName))
  add(path_564198, "workspaceName", newJString(workspaceName))
  result = call_564197.call(path_564198, query_564199, nil, nil, body_564200)

var machineGroupsCreate* = Call_MachineGroupsCreate_564161(
    name: "machineGroupsCreate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machineGroups",
    validator: validate_MachineGroupsCreate_564162, base: "",
    url: url_MachineGroupsCreate_564163, schemes: {Scheme.Https})
type
  Call_MachineGroupsListByWorkspace_564148 = ref object of OpenApiRestCall_563564
proc url_MachineGroupsListByWorkspace_564150(protocol: Scheme; host: string;
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

proc validate_MachineGroupsListByWorkspace_564149(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all machine groups during the specified time interval.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564151 = path.getOrDefault("subscriptionId")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "subscriptionId", valid_564151
  var valid_564152 = path.getOrDefault("resourceGroupName")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "resourceGroupName", valid_564152
  var valid_564153 = path.getOrDefault("workspaceName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "workspaceName", valid_564153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564154 = query.getOrDefault("api-version")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "api-version", valid_564154
  var valid_564155 = query.getOrDefault("startTime")
  valid_564155 = validateParameter(valid_564155, JString, required = false,
                                 default = nil)
  if valid_564155 != nil:
    section.add "startTime", valid_564155
  var valid_564156 = query.getOrDefault("endTime")
  valid_564156 = validateParameter(valid_564156, JString, required = false,
                                 default = nil)
  if valid_564156 != nil:
    section.add "endTime", valid_564156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564157: Call_MachineGroupsListByWorkspace_564148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all machine groups during the specified time interval.
  ## 
  let valid = call_564157.validator(path, query, header, formData, body)
  let scheme = call_564157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564157.url(scheme.get, call_564157.host, call_564157.base,
                         call_564157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564157, url, valid)

proc call*(call_564158: Call_MachineGroupsListByWorkspace_564148;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          workspaceName: string; startTime: string = ""; endTime: string = ""): Recallable =
  ## machineGroupsListByWorkspace
  ## Returns all machine groups during the specified time interval.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564159 = newJObject()
  var query_564160 = newJObject()
  add(query_564160, "api-version", newJString(apiVersion))
  add(query_564160, "startTime", newJString(startTime))
  add(path_564159, "subscriptionId", newJString(subscriptionId))
  add(path_564159, "resourceGroupName", newJString(resourceGroupName))
  add(path_564159, "workspaceName", newJString(workspaceName))
  add(query_564160, "endTime", newJString(endTime))
  result = call_564158.call(path_564159, query_564160, nil, nil, nil)

var machineGroupsListByWorkspace* = Call_MachineGroupsListByWorkspace_564148(
    name: "machineGroupsListByWorkspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machineGroups",
    validator: validate_MachineGroupsListByWorkspace_564149, base: "",
    url: url_MachineGroupsListByWorkspace_564150, schemes: {Scheme.Https})
type
  Call_MachineGroupsUpdate_564215 = ref object of OpenApiRestCall_563564
proc url_MachineGroupsUpdate_564217(protocol: Scheme; host: string; base: string;
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

proc validate_MachineGroupsUpdate_564216(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a machine group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineGroupName: JString (required)
  ##                   : Machine Group resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineGroupName` field"
  var valid_564218 = path.getOrDefault("machineGroupName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "machineGroupName", valid_564218
  var valid_564219 = path.getOrDefault("subscriptionId")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "subscriptionId", valid_564219
  var valid_564220 = path.getOrDefault("resourceGroupName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "resourceGroupName", valid_564220
  var valid_564221 = path.getOrDefault("workspaceName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "workspaceName", valid_564221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564222 = query.getOrDefault("api-version")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "api-version", valid_564222
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

proc call*(call_564224: Call_MachineGroupsUpdate_564215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a machine group.
  ## 
  let valid = call_564224.validator(path, query, header, formData, body)
  let scheme = call_564224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564224.url(scheme.get, call_564224.host, call_564224.base,
                         call_564224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564224, url, valid)

proc call*(call_564225: Call_MachineGroupsUpdate_564215; machineGroupName: string;
          machineGroup: JsonNode; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; workspaceName: string): Recallable =
  ## machineGroupsUpdate
  ## Updates a machine group.
  ##   machineGroupName: string (required)
  ##                   : Machine Group resource name.
  ##   machineGroup: JObject (required)
  ##               : Machine Group resource to update.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_564226 = newJObject()
  var query_564227 = newJObject()
  var body_564228 = newJObject()
  add(path_564226, "machineGroupName", newJString(machineGroupName))
  if machineGroup != nil:
    body_564228 = machineGroup
  add(query_564227, "api-version", newJString(apiVersion))
  add(path_564226, "subscriptionId", newJString(subscriptionId))
  add(path_564226, "resourceGroupName", newJString(resourceGroupName))
  add(path_564226, "workspaceName", newJString(workspaceName))
  result = call_564225.call(path_564226, query_564227, nil, nil, body_564228)

var machineGroupsUpdate* = Call_MachineGroupsUpdate_564215(
    name: "machineGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machineGroups/{machineGroupName}",
    validator: validate_MachineGroupsUpdate_564216, base: "",
    url: url_MachineGroupsUpdate_564217, schemes: {Scheme.Https})
type
  Call_MachineGroupsGet_564201 = ref object of OpenApiRestCall_563564
proc url_MachineGroupsGet_564203(protocol: Scheme; host: string; base: string;
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

proc validate_MachineGroupsGet_564202(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns the specified machine group as it existed during the specified time interval.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineGroupName: JString (required)
  ##                   : Machine Group resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineGroupName` field"
  var valid_564204 = path.getOrDefault("machineGroupName")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "machineGroupName", valid_564204
  var valid_564205 = path.getOrDefault("subscriptionId")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "subscriptionId", valid_564205
  var valid_564206 = path.getOrDefault("resourceGroupName")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "resourceGroupName", valid_564206
  var valid_564207 = path.getOrDefault("workspaceName")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "workspaceName", valid_564207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564208 = query.getOrDefault("api-version")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "api-version", valid_564208
  var valid_564209 = query.getOrDefault("startTime")
  valid_564209 = validateParameter(valid_564209, JString, required = false,
                                 default = nil)
  if valid_564209 != nil:
    section.add "startTime", valid_564209
  var valid_564210 = query.getOrDefault("endTime")
  valid_564210 = validateParameter(valid_564210, JString, required = false,
                                 default = nil)
  if valid_564210 != nil:
    section.add "endTime", valid_564210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564211: Call_MachineGroupsGet_564201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified machine group as it existed during the specified time interval.
  ## 
  let valid = call_564211.validator(path, query, header, formData, body)
  let scheme = call_564211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564211.url(scheme.get, call_564211.host, call_564211.base,
                         call_564211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564211, url, valid)

proc call*(call_564212: Call_MachineGroupsGet_564201; machineGroupName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          workspaceName: string; startTime: string = ""; endTime: string = ""): Recallable =
  ## machineGroupsGet
  ## Returns the specified machine group as it existed during the specified time interval.
  ##   machineGroupName: string (required)
  ##                   : Machine Group resource name.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564213 = newJObject()
  var query_564214 = newJObject()
  add(path_564213, "machineGroupName", newJString(machineGroupName))
  add(query_564214, "api-version", newJString(apiVersion))
  add(query_564214, "startTime", newJString(startTime))
  add(path_564213, "subscriptionId", newJString(subscriptionId))
  add(path_564213, "resourceGroupName", newJString(resourceGroupName))
  add(path_564213, "workspaceName", newJString(workspaceName))
  add(query_564214, "endTime", newJString(endTime))
  result = call_564212.call(path_564213, query_564214, nil, nil, nil)

var machineGroupsGet* = Call_MachineGroupsGet_564201(name: "machineGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machineGroups/{machineGroupName}",
    validator: validate_MachineGroupsGet_564202, base: "",
    url: url_MachineGroupsGet_564203, schemes: {Scheme.Https})
type
  Call_MachineGroupsDelete_564229 = ref object of OpenApiRestCall_563564
proc url_MachineGroupsDelete_564231(protocol: Scheme; host: string; base: string;
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

proc validate_MachineGroupsDelete_564230(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified Machine Group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineGroupName: JString (required)
  ##                   : Machine Group resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineGroupName` field"
  var valid_564232 = path.getOrDefault("machineGroupName")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "machineGroupName", valid_564232
  var valid_564233 = path.getOrDefault("subscriptionId")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "subscriptionId", valid_564233
  var valid_564234 = path.getOrDefault("resourceGroupName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "resourceGroupName", valid_564234
  var valid_564235 = path.getOrDefault("workspaceName")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "workspaceName", valid_564235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564236 = query.getOrDefault("api-version")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "api-version", valid_564236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564237: Call_MachineGroupsDelete_564229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Machine Group.
  ## 
  let valid = call_564237.validator(path, query, header, formData, body)
  let scheme = call_564237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564237.url(scheme.get, call_564237.host, call_564237.base,
                         call_564237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564237, url, valid)

proc call*(call_564238: Call_MachineGroupsDelete_564229; machineGroupName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          workspaceName: string): Recallable =
  ## machineGroupsDelete
  ## Deletes the specified Machine Group.
  ##   machineGroupName: string (required)
  ##                   : Machine Group resource name.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_564239 = newJObject()
  var query_564240 = newJObject()
  add(path_564239, "machineGroupName", newJString(machineGroupName))
  add(query_564240, "api-version", newJString(apiVersion))
  add(path_564239, "subscriptionId", newJString(subscriptionId))
  add(path_564239, "resourceGroupName", newJString(resourceGroupName))
  add(path_564239, "workspaceName", newJString(workspaceName))
  result = call_564238.call(path_564239, query_564240, nil, nil, nil)

var machineGroupsDelete* = Call_MachineGroupsDelete_564229(
    name: "machineGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machineGroups/{machineGroupName}",
    validator: validate_MachineGroupsDelete_564230, base: "",
    url: url_MachineGroupsDelete_564231, schemes: {Scheme.Https})
type
  Call_MachinesListByWorkspace_564241 = ref object of OpenApiRestCall_563564
proc url_MachinesListByWorkspace_564243(protocol: Scheme; host: string; base: string;
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

proc validate_MachinesListByWorkspace_564242(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of machines matching the specified conditions.  The returned collection represents either machines that are active/live during the specified interval  of time (`live=true` and `startTime`/`endTime` are specified) or that are known to have existed at or  some time prior to the specified point in time (`live=false` and `timestamp` is specified).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564244 = path.getOrDefault("subscriptionId")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "subscriptionId", valid_564244
  var valid_564245 = path.getOrDefault("resourceGroupName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "resourceGroupName", valid_564245
  var valid_564246 = path.getOrDefault("workspaceName")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "workspaceName", valid_564246
  result.add "path", section
  ## parameters in `query` object:
  ##   live: JBool
  ##       : Specifies whether to return live resources (true) or inventory resources (false). Defaults to **true**. When retrieving live resources, the start time (`startTime`) and end time (`endTime`) of the desired interval should be included. When retrieving inventory resources, an optional timestamp (`timestamp`) parameter can be specified to return the version of each resource closest (not-after) that timestamp.
  ##   api-version: JString (required)
  ##              : API version.
  ##   $top: JInt
  ##       : Page size to use. When not specified, the default page size is 100 records.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   timestamp: JString
  ##            : UTC date and time specifying a time instance relative to which to evaluate each machine resource. Only applies when `live=false`. When not specified, the service uses DateTime.UtcNow.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  var valid_564260 = query.getOrDefault("live")
  valid_564260 = validateParameter(valid_564260, JBool, required = false,
                                 default = newJBool(true))
  if valid_564260 != nil:
    section.add "live", valid_564260
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564261 = query.getOrDefault("api-version")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "api-version", valid_564261
  var valid_564262 = query.getOrDefault("$top")
  valid_564262 = validateParameter(valid_564262, JInt, required = false, default = nil)
  if valid_564262 != nil:
    section.add "$top", valid_564262
  var valid_564263 = query.getOrDefault("startTime")
  valid_564263 = validateParameter(valid_564263, JString, required = false,
                                 default = nil)
  if valid_564263 != nil:
    section.add "startTime", valid_564263
  var valid_564264 = query.getOrDefault("timestamp")
  valid_564264 = validateParameter(valid_564264, JString, required = false,
                                 default = nil)
  if valid_564264 != nil:
    section.add "timestamp", valid_564264
  var valid_564265 = query.getOrDefault("endTime")
  valid_564265 = validateParameter(valid_564265, JString, required = false,
                                 default = nil)
  if valid_564265 != nil:
    section.add "endTime", valid_564265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564266: Call_MachinesListByWorkspace_564241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of machines matching the specified conditions.  The returned collection represents either machines that are active/live during the specified interval  of time (`live=true` and `startTime`/`endTime` are specified) or that are known to have existed at or  some time prior to the specified point in time (`live=false` and `timestamp` is specified).
  ## 
  let valid = call_564266.validator(path, query, header, formData, body)
  let scheme = call_564266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564266.url(scheme.get, call_564266.host, call_564266.base,
                         call_564266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564266, url, valid)

proc call*(call_564267: Call_MachinesListByWorkspace_564241; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; workspaceName: string;
          live: bool = true; Top: int = 0; startTime: string = ""; timestamp: string = "";
          endTime: string = ""): Recallable =
  ## machinesListByWorkspace
  ## Returns a collection of machines matching the specified conditions.  The returned collection represents either machines that are active/live during the specified interval  of time (`live=true` and `startTime`/`endTime` are specified) or that are known to have existed at or  some time prior to the specified point in time (`live=false` and `timestamp` is specified).
  ##   live: bool
  ##       : Specifies whether to return live resources (true) or inventory resources (false). Defaults to **true**. When retrieving live resources, the start time (`startTime`) and end time (`endTime`) of the desired interval should be included. When retrieving inventory resources, an optional timestamp (`timestamp`) parameter can be specified to return the version of each resource closest (not-after) that timestamp.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   Top: int
  ##      : Page size to use. When not specified, the default page size is 100 records.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   timestamp: string
  ##            : UTC date and time specifying a time instance relative to which to evaluate each machine resource. Only applies when `live=false`. When not specified, the service uses DateTime.UtcNow.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564268 = newJObject()
  var query_564269 = newJObject()
  add(query_564269, "live", newJBool(live))
  add(query_564269, "api-version", newJString(apiVersion))
  add(query_564269, "$top", newJInt(Top))
  add(query_564269, "startTime", newJString(startTime))
  add(path_564268, "subscriptionId", newJString(subscriptionId))
  add(query_564269, "timestamp", newJString(timestamp))
  add(path_564268, "resourceGroupName", newJString(resourceGroupName))
  add(path_564268, "workspaceName", newJString(workspaceName))
  add(query_564269, "endTime", newJString(endTime))
  result = call_564267.call(path_564268, query_564269, nil, nil, nil)

var machinesListByWorkspace* = Call_MachinesListByWorkspace_564241(
    name: "machinesListByWorkspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines",
    validator: validate_MachinesListByWorkspace_564242, base: "",
    url: url_MachinesListByWorkspace_564243, schemes: {Scheme.Https})
type
  Call_MachinesGet_564270 = ref object of OpenApiRestCall_563564
proc url_MachinesGet_564272(protocol: Scheme; host: string; base: string;
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

proc validate_MachinesGet_564271(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineName` field"
  var valid_564273 = path.getOrDefault("machineName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "machineName", valid_564273
  var valid_564274 = path.getOrDefault("subscriptionId")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "subscriptionId", valid_564274
  var valid_564275 = path.getOrDefault("resourceGroupName")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "resourceGroupName", valid_564275
  var valid_564276 = path.getOrDefault("workspaceName")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "workspaceName", valid_564276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   timestamp: JString
  ##            : UTC date and time specifying a time instance relative to which to evaluate the machine resource. When not specified, the service uses DateTime.UtcNow.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564277 = query.getOrDefault("api-version")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "api-version", valid_564277
  var valid_564278 = query.getOrDefault("timestamp")
  valid_564278 = validateParameter(valid_564278, JString, required = false,
                                 default = nil)
  if valid_564278 != nil:
    section.add "timestamp", valid_564278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564279: Call_MachinesGet_564270; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified machine.
  ## 
  let valid = call_564279.validator(path, query, header, formData, body)
  let scheme = call_564279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564279.url(scheme.get, call_564279.host, call_564279.base,
                         call_564279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564279, url, valid)

proc call*(call_564280: Call_MachinesGet_564270; machineName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          workspaceName: string; timestamp: string = ""): Recallable =
  ## machinesGet
  ## Returns the specified machine.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   timestamp: string
  ##            : UTC date and time specifying a time instance relative to which to evaluate the machine resource. When not specified, the service uses DateTime.UtcNow.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_564281 = newJObject()
  var query_564282 = newJObject()
  add(path_564281, "machineName", newJString(machineName))
  add(query_564282, "api-version", newJString(apiVersion))
  add(path_564281, "subscriptionId", newJString(subscriptionId))
  add(query_564282, "timestamp", newJString(timestamp))
  add(path_564281, "resourceGroupName", newJString(resourceGroupName))
  add(path_564281, "workspaceName", newJString(workspaceName))
  result = call_564280.call(path_564281, query_564282, nil, nil, nil)

var machinesGet* = Call_MachinesGet_564270(name: "machinesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}",
                                        validator: validate_MachinesGet_564271,
                                        base: "", url: url_MachinesGet_564272,
                                        schemes: {Scheme.Https})
type
  Call_MachinesListConnections_564283 = ref object of OpenApiRestCall_563564
proc url_MachinesListConnections_564285(protocol: Scheme; host: string; base: string;
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

proc validate_MachinesListConnections_564284(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of connections terminating or originating at the specified machine
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineName` field"
  var valid_564286 = path.getOrDefault("machineName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "machineName", valid_564286
  var valid_564287 = path.getOrDefault("subscriptionId")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "subscriptionId", valid_564287
  var valid_564288 = path.getOrDefault("resourceGroupName")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "resourceGroupName", valid_564288
  var valid_564289 = path.getOrDefault("workspaceName")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "workspaceName", valid_564289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564290 = query.getOrDefault("api-version")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "api-version", valid_564290
  var valid_564291 = query.getOrDefault("startTime")
  valid_564291 = validateParameter(valid_564291, JString, required = false,
                                 default = nil)
  if valid_564291 != nil:
    section.add "startTime", valid_564291
  var valid_564292 = query.getOrDefault("endTime")
  valid_564292 = validateParameter(valid_564292, JString, required = false,
                                 default = nil)
  if valid_564292 != nil:
    section.add "endTime", valid_564292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564293: Call_MachinesListConnections_564283; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of connections terminating or originating at the specified machine
  ## 
  let valid = call_564293.validator(path, query, header, formData, body)
  let scheme = call_564293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564293.url(scheme.get, call_564293.host, call_564293.base,
                         call_564293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564293, url, valid)

proc call*(call_564294: Call_MachinesListConnections_564283; machineName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          workspaceName: string; startTime: string = ""; endTime: string = ""): Recallable =
  ## machinesListConnections
  ## Returns a collection of connections terminating or originating at the specified machine
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564295 = newJObject()
  var query_564296 = newJObject()
  add(path_564295, "machineName", newJString(machineName))
  add(query_564296, "api-version", newJString(apiVersion))
  add(query_564296, "startTime", newJString(startTime))
  add(path_564295, "subscriptionId", newJString(subscriptionId))
  add(path_564295, "resourceGroupName", newJString(resourceGroupName))
  add(path_564295, "workspaceName", newJString(workspaceName))
  add(query_564296, "endTime", newJString(endTime))
  result = call_564294.call(path_564295, query_564296, nil, nil, nil)

var machinesListConnections* = Call_MachinesListConnections_564283(
    name: "machinesListConnections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/connections",
    validator: validate_MachinesListConnections_564284, base: "",
    url: url_MachinesListConnections_564285, schemes: {Scheme.Https})
type
  Call_MachinesGetLiveness_564297 = ref object of OpenApiRestCall_563564
proc url_MachinesGetLiveness_564299(protocol: Scheme; host: string; base: string;
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

proc validate_MachinesGetLiveness_564298(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Obtains the liveness status of the machine during the specified time interval.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineName` field"
  var valid_564300 = path.getOrDefault("machineName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "machineName", valid_564300
  var valid_564301 = path.getOrDefault("subscriptionId")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "subscriptionId", valid_564301
  var valid_564302 = path.getOrDefault("resourceGroupName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "resourceGroupName", valid_564302
  var valid_564303 = path.getOrDefault("workspaceName")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "workspaceName", valid_564303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564304 = query.getOrDefault("api-version")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "api-version", valid_564304
  var valid_564305 = query.getOrDefault("startTime")
  valid_564305 = validateParameter(valid_564305, JString, required = false,
                                 default = nil)
  if valid_564305 != nil:
    section.add "startTime", valid_564305
  var valid_564306 = query.getOrDefault("endTime")
  valid_564306 = validateParameter(valid_564306, JString, required = false,
                                 default = nil)
  if valid_564306 != nil:
    section.add "endTime", valid_564306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564307: Call_MachinesGetLiveness_564297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Obtains the liveness status of the machine during the specified time interval.
  ## 
  let valid = call_564307.validator(path, query, header, formData, body)
  let scheme = call_564307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564307.url(scheme.get, call_564307.host, call_564307.base,
                         call_564307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564307, url, valid)

proc call*(call_564308: Call_MachinesGetLiveness_564297; machineName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          workspaceName: string; startTime: string = ""; endTime: string = ""): Recallable =
  ## machinesGetLiveness
  ## Obtains the liveness status of the machine during the specified time interval.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564309 = newJObject()
  var query_564310 = newJObject()
  add(path_564309, "machineName", newJString(machineName))
  add(query_564310, "api-version", newJString(apiVersion))
  add(query_564310, "startTime", newJString(startTime))
  add(path_564309, "subscriptionId", newJString(subscriptionId))
  add(path_564309, "resourceGroupName", newJString(resourceGroupName))
  add(path_564309, "workspaceName", newJString(workspaceName))
  add(query_564310, "endTime", newJString(endTime))
  result = call_564308.call(path_564309, query_564310, nil, nil, nil)

var machinesGetLiveness* = Call_MachinesGetLiveness_564297(
    name: "machinesGetLiveness", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/liveness",
    validator: validate_MachinesGetLiveness_564298, base: "",
    url: url_MachinesGetLiveness_564299, schemes: {Scheme.Https})
type
  Call_MachinesListMachineGroupMembership_564311 = ref object of OpenApiRestCall_563564
proc url_MachinesListMachineGroupMembership_564313(protocol: Scheme; host: string;
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

proc validate_MachinesListMachineGroupMembership_564312(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of machine groups this machine belongs to during the specified time interval.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineName` field"
  var valid_564314 = path.getOrDefault("machineName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "machineName", valid_564314
  var valid_564315 = path.getOrDefault("subscriptionId")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "subscriptionId", valid_564315
  var valid_564316 = path.getOrDefault("resourceGroupName")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "resourceGroupName", valid_564316
  var valid_564317 = path.getOrDefault("workspaceName")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "workspaceName", valid_564317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564318 = query.getOrDefault("api-version")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "api-version", valid_564318
  var valid_564319 = query.getOrDefault("startTime")
  valid_564319 = validateParameter(valid_564319, JString, required = false,
                                 default = nil)
  if valid_564319 != nil:
    section.add "startTime", valid_564319
  var valid_564320 = query.getOrDefault("endTime")
  valid_564320 = validateParameter(valid_564320, JString, required = false,
                                 default = nil)
  if valid_564320 != nil:
    section.add "endTime", valid_564320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564321: Call_MachinesListMachineGroupMembership_564311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a collection of machine groups this machine belongs to during the specified time interval.
  ## 
  let valid = call_564321.validator(path, query, header, formData, body)
  let scheme = call_564321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564321.url(scheme.get, call_564321.host, call_564321.base,
                         call_564321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564321, url, valid)

proc call*(call_564322: Call_MachinesListMachineGroupMembership_564311;
          machineName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; workspaceName: string; startTime: string = "";
          endTime: string = ""): Recallable =
  ## machinesListMachineGroupMembership
  ## Returns a collection of machine groups this machine belongs to during the specified time interval.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564323 = newJObject()
  var query_564324 = newJObject()
  add(path_564323, "machineName", newJString(machineName))
  add(query_564324, "api-version", newJString(apiVersion))
  add(query_564324, "startTime", newJString(startTime))
  add(path_564323, "subscriptionId", newJString(subscriptionId))
  add(path_564323, "resourceGroupName", newJString(resourceGroupName))
  add(path_564323, "workspaceName", newJString(workspaceName))
  add(query_564324, "endTime", newJString(endTime))
  result = call_564322.call(path_564323, query_564324, nil, nil, nil)

var machinesListMachineGroupMembership* = Call_MachinesListMachineGroupMembership_564311(
    name: "machinesListMachineGroupMembership", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/machineGroups",
    validator: validate_MachinesListMachineGroupMembership_564312, base: "",
    url: url_MachinesListMachineGroupMembership_564313, schemes: {Scheme.Https})
type
  Call_MachinesListPorts_564325 = ref object of OpenApiRestCall_563564
proc url_MachinesListPorts_564327(protocol: Scheme; host: string; base: string;
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

proc validate_MachinesListPorts_564326(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns a collection of live ports on the specified machine during the specified time interval.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineName` field"
  var valid_564328 = path.getOrDefault("machineName")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "machineName", valid_564328
  var valid_564329 = path.getOrDefault("subscriptionId")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "subscriptionId", valid_564329
  var valid_564330 = path.getOrDefault("resourceGroupName")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "resourceGroupName", valid_564330
  var valid_564331 = path.getOrDefault("workspaceName")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "workspaceName", valid_564331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564332 = query.getOrDefault("api-version")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "api-version", valid_564332
  var valid_564333 = query.getOrDefault("startTime")
  valid_564333 = validateParameter(valid_564333, JString, required = false,
                                 default = nil)
  if valid_564333 != nil:
    section.add "startTime", valid_564333
  var valid_564334 = query.getOrDefault("endTime")
  valid_564334 = validateParameter(valid_564334, JString, required = false,
                                 default = nil)
  if valid_564334 != nil:
    section.add "endTime", valid_564334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564335: Call_MachinesListPorts_564325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of live ports on the specified machine during the specified time interval.
  ## 
  let valid = call_564335.validator(path, query, header, formData, body)
  let scheme = call_564335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564335.url(scheme.get, call_564335.host, call_564335.base,
                         call_564335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564335, url, valid)

proc call*(call_564336: Call_MachinesListPorts_564325; machineName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          workspaceName: string; startTime: string = ""; endTime: string = ""): Recallable =
  ## machinesListPorts
  ## Returns a collection of live ports on the specified machine during the specified time interval.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564337 = newJObject()
  var query_564338 = newJObject()
  add(path_564337, "machineName", newJString(machineName))
  add(query_564338, "api-version", newJString(apiVersion))
  add(query_564338, "startTime", newJString(startTime))
  add(path_564337, "subscriptionId", newJString(subscriptionId))
  add(path_564337, "resourceGroupName", newJString(resourceGroupName))
  add(path_564337, "workspaceName", newJString(workspaceName))
  add(query_564338, "endTime", newJString(endTime))
  result = call_564336.call(path_564337, query_564338, nil, nil, nil)

var machinesListPorts* = Call_MachinesListPorts_564325(name: "machinesListPorts",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/ports",
    validator: validate_MachinesListPorts_564326, base: "",
    url: url_MachinesListPorts_564327, schemes: {Scheme.Https})
type
  Call_PortsGet_564339 = ref object of OpenApiRestCall_563564
proc url_PortsGet_564341(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PortsGet_564340(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified port. The port must be live during the specified time interval. If the port is not live during the interval, status 404 (Not Found) is returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  ##   portName: JString (required)
  ##           : Port resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineName` field"
  var valid_564342 = path.getOrDefault("machineName")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "machineName", valid_564342
  var valid_564343 = path.getOrDefault("subscriptionId")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "subscriptionId", valid_564343
  var valid_564344 = path.getOrDefault("resourceGroupName")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "resourceGroupName", valid_564344
  var valid_564345 = path.getOrDefault("workspaceName")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "workspaceName", valid_564345
  var valid_564346 = path.getOrDefault("portName")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "portName", valid_564346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564347 = query.getOrDefault("api-version")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "api-version", valid_564347
  var valid_564348 = query.getOrDefault("startTime")
  valid_564348 = validateParameter(valid_564348, JString, required = false,
                                 default = nil)
  if valid_564348 != nil:
    section.add "startTime", valid_564348
  var valid_564349 = query.getOrDefault("endTime")
  valid_564349 = validateParameter(valid_564349, JString, required = false,
                                 default = nil)
  if valid_564349 != nil:
    section.add "endTime", valid_564349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564350: Call_PortsGet_564339; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified port. The port must be live during the specified time interval. If the port is not live during the interval, status 404 (Not Found) is returned.
  ## 
  let valid = call_564350.validator(path, query, header, formData, body)
  let scheme = call_564350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564350.url(scheme.get, call_564350.host, call_564350.base,
                         call_564350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564350, url, valid)

proc call*(call_564351: Call_PortsGet_564339; machineName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          workspaceName: string; portName: string; startTime: string = "";
          endTime: string = ""): Recallable =
  ## portsGet
  ## Returns the specified port. The port must be live during the specified time interval. If the port is not live during the interval, status 404 (Not Found) is returned.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   portName: string (required)
  ##           : Port resource name.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564352 = newJObject()
  var query_564353 = newJObject()
  add(path_564352, "machineName", newJString(machineName))
  add(query_564353, "api-version", newJString(apiVersion))
  add(query_564353, "startTime", newJString(startTime))
  add(path_564352, "subscriptionId", newJString(subscriptionId))
  add(path_564352, "resourceGroupName", newJString(resourceGroupName))
  add(path_564352, "workspaceName", newJString(workspaceName))
  add(path_564352, "portName", newJString(portName))
  add(query_564353, "endTime", newJString(endTime))
  result = call_564351.call(path_564352, query_564353, nil, nil, nil)

var portsGet* = Call_PortsGet_564339(name: "portsGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/ports/{portName}",
                                  validator: validate_PortsGet_564340, base: "",
                                  url: url_PortsGet_564341,
                                  schemes: {Scheme.Https})
type
  Call_PortsListAcceptingProcesses_564354 = ref object of OpenApiRestCall_563564
proc url_PortsListAcceptingProcesses_564356(protocol: Scheme; host: string;
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

proc validate_PortsListAcceptingProcesses_564355(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of processes accepting on the specified port
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  ##   portName: JString (required)
  ##           : Port resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineName` field"
  var valid_564357 = path.getOrDefault("machineName")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "machineName", valid_564357
  var valid_564358 = path.getOrDefault("subscriptionId")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "subscriptionId", valid_564358
  var valid_564359 = path.getOrDefault("resourceGroupName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "resourceGroupName", valid_564359
  var valid_564360 = path.getOrDefault("workspaceName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "workspaceName", valid_564360
  var valid_564361 = path.getOrDefault("portName")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "portName", valid_564361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564362 = query.getOrDefault("api-version")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "api-version", valid_564362
  var valid_564363 = query.getOrDefault("startTime")
  valid_564363 = validateParameter(valid_564363, JString, required = false,
                                 default = nil)
  if valid_564363 != nil:
    section.add "startTime", valid_564363
  var valid_564364 = query.getOrDefault("endTime")
  valid_564364 = validateParameter(valid_564364, JString, required = false,
                                 default = nil)
  if valid_564364 != nil:
    section.add "endTime", valid_564364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564365: Call_PortsListAcceptingProcesses_564354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of processes accepting on the specified port
  ## 
  let valid = call_564365.validator(path, query, header, formData, body)
  let scheme = call_564365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564365.url(scheme.get, call_564365.host, call_564365.base,
                         call_564365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564365, url, valid)

proc call*(call_564366: Call_PortsListAcceptingProcesses_564354;
          machineName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; workspaceName: string; portName: string;
          startTime: string = ""; endTime: string = ""): Recallable =
  ## portsListAcceptingProcesses
  ## Returns a collection of processes accepting on the specified port
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   portName: string (required)
  ##           : Port resource name.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564367 = newJObject()
  var query_564368 = newJObject()
  add(path_564367, "machineName", newJString(machineName))
  add(query_564368, "api-version", newJString(apiVersion))
  add(query_564368, "startTime", newJString(startTime))
  add(path_564367, "subscriptionId", newJString(subscriptionId))
  add(path_564367, "resourceGroupName", newJString(resourceGroupName))
  add(path_564367, "workspaceName", newJString(workspaceName))
  add(path_564367, "portName", newJString(portName))
  add(query_564368, "endTime", newJString(endTime))
  result = call_564366.call(path_564367, query_564368, nil, nil, nil)

var portsListAcceptingProcesses* = Call_PortsListAcceptingProcesses_564354(
    name: "portsListAcceptingProcesses", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/ports/{portName}/acceptingProcesses",
    validator: validate_PortsListAcceptingProcesses_564355, base: "",
    url: url_PortsListAcceptingProcesses_564356, schemes: {Scheme.Https})
type
  Call_PortsListConnections_564369 = ref object of OpenApiRestCall_563564
proc url_PortsListConnections_564371(protocol: Scheme; host: string; base: string;
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

proc validate_PortsListConnections_564370(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of connections established via the specified port.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  ##   portName: JString (required)
  ##           : Port resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineName` field"
  var valid_564372 = path.getOrDefault("machineName")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "machineName", valid_564372
  var valid_564373 = path.getOrDefault("subscriptionId")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "subscriptionId", valid_564373
  var valid_564374 = path.getOrDefault("resourceGroupName")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "resourceGroupName", valid_564374
  var valid_564375 = path.getOrDefault("workspaceName")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "workspaceName", valid_564375
  var valid_564376 = path.getOrDefault("portName")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "portName", valid_564376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564377 = query.getOrDefault("api-version")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "api-version", valid_564377
  var valid_564378 = query.getOrDefault("startTime")
  valid_564378 = validateParameter(valid_564378, JString, required = false,
                                 default = nil)
  if valid_564378 != nil:
    section.add "startTime", valid_564378
  var valid_564379 = query.getOrDefault("endTime")
  valid_564379 = validateParameter(valid_564379, JString, required = false,
                                 default = nil)
  if valid_564379 != nil:
    section.add "endTime", valid_564379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564380: Call_PortsListConnections_564369; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of connections established via the specified port.
  ## 
  let valid = call_564380.validator(path, query, header, formData, body)
  let scheme = call_564380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564380.url(scheme.get, call_564380.host, call_564380.base,
                         call_564380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564380, url, valid)

proc call*(call_564381: Call_PortsListConnections_564369; machineName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          workspaceName: string; portName: string; startTime: string = "";
          endTime: string = ""): Recallable =
  ## portsListConnections
  ## Returns a collection of connections established via the specified port.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   portName: string (required)
  ##           : Port resource name.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564382 = newJObject()
  var query_564383 = newJObject()
  add(path_564382, "machineName", newJString(machineName))
  add(query_564383, "api-version", newJString(apiVersion))
  add(query_564383, "startTime", newJString(startTime))
  add(path_564382, "subscriptionId", newJString(subscriptionId))
  add(path_564382, "resourceGroupName", newJString(resourceGroupName))
  add(path_564382, "workspaceName", newJString(workspaceName))
  add(path_564382, "portName", newJString(portName))
  add(query_564383, "endTime", newJString(endTime))
  result = call_564381.call(path_564382, query_564383, nil, nil, nil)

var portsListConnections* = Call_PortsListConnections_564369(
    name: "portsListConnections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/ports/{portName}/connections",
    validator: validate_PortsListConnections_564370, base: "",
    url: url_PortsListConnections_564371, schemes: {Scheme.Https})
type
  Call_PortsGetLiveness_564384 = ref object of OpenApiRestCall_563564
proc url_PortsGetLiveness_564386(protocol: Scheme; host: string; base: string;
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

proc validate_PortsGetLiveness_564385(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Obtains the liveness status of the port during the specified time interval.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  ##   portName: JString (required)
  ##           : Port resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineName` field"
  var valid_564387 = path.getOrDefault("machineName")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "machineName", valid_564387
  var valid_564388 = path.getOrDefault("subscriptionId")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "subscriptionId", valid_564388
  var valid_564389 = path.getOrDefault("resourceGroupName")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "resourceGroupName", valid_564389
  var valid_564390 = path.getOrDefault("workspaceName")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "workspaceName", valid_564390
  var valid_564391 = path.getOrDefault("portName")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "portName", valid_564391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564392 = query.getOrDefault("api-version")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "api-version", valid_564392
  var valid_564393 = query.getOrDefault("startTime")
  valid_564393 = validateParameter(valid_564393, JString, required = false,
                                 default = nil)
  if valid_564393 != nil:
    section.add "startTime", valid_564393
  var valid_564394 = query.getOrDefault("endTime")
  valid_564394 = validateParameter(valid_564394, JString, required = false,
                                 default = nil)
  if valid_564394 != nil:
    section.add "endTime", valid_564394
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564395: Call_PortsGetLiveness_564384; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Obtains the liveness status of the port during the specified time interval.
  ## 
  let valid = call_564395.validator(path, query, header, formData, body)
  let scheme = call_564395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564395.url(scheme.get, call_564395.host, call_564395.base,
                         call_564395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564395, url, valid)

proc call*(call_564396: Call_PortsGetLiveness_564384; machineName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          workspaceName: string; portName: string; startTime: string = "";
          endTime: string = ""): Recallable =
  ## portsGetLiveness
  ## Obtains the liveness status of the port during the specified time interval.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   portName: string (required)
  ##           : Port resource name.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564397 = newJObject()
  var query_564398 = newJObject()
  add(path_564397, "machineName", newJString(machineName))
  add(query_564398, "api-version", newJString(apiVersion))
  add(query_564398, "startTime", newJString(startTime))
  add(path_564397, "subscriptionId", newJString(subscriptionId))
  add(path_564397, "resourceGroupName", newJString(resourceGroupName))
  add(path_564397, "workspaceName", newJString(workspaceName))
  add(path_564397, "portName", newJString(portName))
  add(query_564398, "endTime", newJString(endTime))
  result = call_564396.call(path_564397, query_564398, nil, nil, nil)

var portsGetLiveness* = Call_PortsGetLiveness_564384(name: "portsGetLiveness",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/ports/{portName}/liveness",
    validator: validate_PortsGetLiveness_564385, base: "",
    url: url_PortsGetLiveness_564386, schemes: {Scheme.Https})
type
  Call_MachinesListProcesses_564399 = ref object of OpenApiRestCall_563564
proc url_MachinesListProcesses_564401(protocol: Scheme; host: string; base: string;
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

proc validate_MachinesListProcesses_564400(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of processes on the specified machine matching the specified conditions. The returned collection represents either processes that are active/live during the specified interval  of time (`live=true` and `startTime`/`endTime` are specified) or that are known to have existed at or  some time prior to the specified point in time (`live=false` and `timestamp` is specified).        
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineName` field"
  var valid_564402 = path.getOrDefault("machineName")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "machineName", valid_564402
  var valid_564403 = path.getOrDefault("subscriptionId")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "subscriptionId", valid_564403
  var valid_564404 = path.getOrDefault("resourceGroupName")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "resourceGroupName", valid_564404
  var valid_564405 = path.getOrDefault("workspaceName")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "workspaceName", valid_564405
  result.add "path", section
  ## parameters in `query` object:
  ##   live: JBool
  ##       : Specifies whether to return live resources (true) or inventory resources (false). Defaults to **true**. When retrieving live resources, the start time (`startTime`) and end time (`endTime`) of the desired interval should be included. When retrieving inventory resources, an optional timestamp (`timestamp`) parameter can be specified to return the version of each resource closest (not-after) that timestamp.
  ##   api-version: JString (required)
  ##              : API version.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   timestamp: JString
  ##            : UTC date and time specifying a time instance relative to which to evaluate all process resource. Only applies when `live=false`. When not specified, the service uses DateTime.UtcNow.
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  var valid_564406 = query.getOrDefault("live")
  valid_564406 = validateParameter(valid_564406, JBool, required = false,
                                 default = newJBool(true))
  if valid_564406 != nil:
    section.add "live", valid_564406
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564407 = query.getOrDefault("api-version")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "api-version", valid_564407
  var valid_564408 = query.getOrDefault("startTime")
  valid_564408 = validateParameter(valid_564408, JString, required = false,
                                 default = nil)
  if valid_564408 != nil:
    section.add "startTime", valid_564408
  var valid_564409 = query.getOrDefault("timestamp")
  valid_564409 = validateParameter(valid_564409, JString, required = false,
                                 default = nil)
  if valid_564409 != nil:
    section.add "timestamp", valid_564409
  var valid_564410 = query.getOrDefault("endTime")
  valid_564410 = validateParameter(valid_564410, JString, required = false,
                                 default = nil)
  if valid_564410 != nil:
    section.add "endTime", valid_564410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564411: Call_MachinesListProcesses_564399; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of processes on the specified machine matching the specified conditions. The returned collection represents either processes that are active/live during the specified interval  of time (`live=true` and `startTime`/`endTime` are specified) or that are known to have existed at or  some time prior to the specified point in time (`live=false` and `timestamp` is specified).        
  ## 
  let valid = call_564411.validator(path, query, header, formData, body)
  let scheme = call_564411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564411.url(scheme.get, call_564411.host, call_564411.base,
                         call_564411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564411, url, valid)

proc call*(call_564412: Call_MachinesListProcesses_564399; machineName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          workspaceName: string; live: bool = true; startTime: string = "";
          timestamp: string = ""; endTime: string = ""): Recallable =
  ## machinesListProcesses
  ## Returns a collection of processes on the specified machine matching the specified conditions. The returned collection represents either processes that are active/live during the specified interval  of time (`live=true` and `startTime`/`endTime` are specified) or that are known to have existed at or  some time prior to the specified point in time (`live=false` and `timestamp` is specified).        
  ##   live: bool
  ##       : Specifies whether to return live resources (true) or inventory resources (false). Defaults to **true**. When retrieving live resources, the start time (`startTime`) and end time (`endTime`) of the desired interval should be included. When retrieving inventory resources, an optional timestamp (`timestamp`) parameter can be specified to return the version of each resource closest (not-after) that timestamp.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   timestamp: string
  ##            : UTC date and time specifying a time instance relative to which to evaluate all process resource. Only applies when `live=false`. When not specified, the service uses DateTime.UtcNow.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564413 = newJObject()
  var query_564414 = newJObject()
  add(query_564414, "live", newJBool(live))
  add(path_564413, "machineName", newJString(machineName))
  add(query_564414, "api-version", newJString(apiVersion))
  add(query_564414, "startTime", newJString(startTime))
  add(path_564413, "subscriptionId", newJString(subscriptionId))
  add(query_564414, "timestamp", newJString(timestamp))
  add(path_564413, "resourceGroupName", newJString(resourceGroupName))
  add(path_564413, "workspaceName", newJString(workspaceName))
  add(query_564414, "endTime", newJString(endTime))
  result = call_564412.call(path_564413, query_564414, nil, nil, nil)

var machinesListProcesses* = Call_MachinesListProcesses_564399(
    name: "machinesListProcesses", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/processes",
    validator: validate_MachinesListProcesses_564400, base: "",
    url: url_MachinesListProcesses_564401, schemes: {Scheme.Https})
type
  Call_ProcessesGet_564415 = ref object of OpenApiRestCall_563564
proc url_ProcessesGet_564417(protocol: Scheme; host: string; base: string;
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

proc validate_ProcessesGet_564416(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified process.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   processName: JString (required)
  ##              : Process resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineName` field"
  var valid_564418 = path.getOrDefault("machineName")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "machineName", valid_564418
  var valid_564419 = path.getOrDefault("processName")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "processName", valid_564419
  var valid_564420 = path.getOrDefault("subscriptionId")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "subscriptionId", valid_564420
  var valid_564421 = path.getOrDefault("resourceGroupName")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "resourceGroupName", valid_564421
  var valid_564422 = path.getOrDefault("workspaceName")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "workspaceName", valid_564422
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   timestamp: JString
  ##            : UTC date and time specifying a time instance relative to which to evaluate a resource. When not specified, the service uses DateTime.UtcNow.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564423 = query.getOrDefault("api-version")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "api-version", valid_564423
  var valid_564424 = query.getOrDefault("timestamp")
  valid_564424 = validateParameter(valid_564424, JString, required = false,
                                 default = nil)
  if valid_564424 != nil:
    section.add "timestamp", valid_564424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564425: Call_ProcessesGet_564415; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified process.
  ## 
  let valid = call_564425.validator(path, query, header, formData, body)
  let scheme = call_564425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564425.url(scheme.get, call_564425.host, call_564425.base,
                         call_564425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564425, url, valid)

proc call*(call_564426: Call_ProcessesGet_564415; machineName: string;
          apiVersion: string; processName: string; subscriptionId: string;
          resourceGroupName: string; workspaceName: string; timestamp: string = ""): Recallable =
  ## processesGet
  ## Returns the specified process.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   processName: string (required)
  ##              : Process resource name.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   timestamp: string
  ##            : UTC date and time specifying a time instance relative to which to evaluate a resource. When not specified, the service uses DateTime.UtcNow.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  var path_564427 = newJObject()
  var query_564428 = newJObject()
  add(path_564427, "machineName", newJString(machineName))
  add(query_564428, "api-version", newJString(apiVersion))
  add(path_564427, "processName", newJString(processName))
  add(path_564427, "subscriptionId", newJString(subscriptionId))
  add(query_564428, "timestamp", newJString(timestamp))
  add(path_564427, "resourceGroupName", newJString(resourceGroupName))
  add(path_564427, "workspaceName", newJString(workspaceName))
  result = call_564426.call(path_564427, query_564428, nil, nil, nil)

var processesGet* = Call_ProcessesGet_564415(name: "processesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/processes/{processName}",
    validator: validate_ProcessesGet_564416, base: "", url: url_ProcessesGet_564417,
    schemes: {Scheme.Https})
type
  Call_ProcessesListAcceptingPorts_564429 = ref object of OpenApiRestCall_563564
proc url_ProcessesListAcceptingPorts_564431(protocol: Scheme; host: string;
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

proc validate_ProcessesListAcceptingPorts_564430(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of ports on which this process is accepting
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   processName: JString (required)
  ##              : Process resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineName` field"
  var valid_564432 = path.getOrDefault("machineName")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "machineName", valid_564432
  var valid_564433 = path.getOrDefault("processName")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "processName", valid_564433
  var valid_564434 = path.getOrDefault("subscriptionId")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "subscriptionId", valid_564434
  var valid_564435 = path.getOrDefault("resourceGroupName")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "resourceGroupName", valid_564435
  var valid_564436 = path.getOrDefault("workspaceName")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = nil)
  if valid_564436 != nil:
    section.add "workspaceName", valid_564436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564437 = query.getOrDefault("api-version")
  valid_564437 = validateParameter(valid_564437, JString, required = true,
                                 default = nil)
  if valid_564437 != nil:
    section.add "api-version", valid_564437
  var valid_564438 = query.getOrDefault("startTime")
  valid_564438 = validateParameter(valid_564438, JString, required = false,
                                 default = nil)
  if valid_564438 != nil:
    section.add "startTime", valid_564438
  var valid_564439 = query.getOrDefault("endTime")
  valid_564439 = validateParameter(valid_564439, JString, required = false,
                                 default = nil)
  if valid_564439 != nil:
    section.add "endTime", valid_564439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564440: Call_ProcessesListAcceptingPorts_564429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of ports on which this process is accepting
  ## 
  let valid = call_564440.validator(path, query, header, formData, body)
  let scheme = call_564440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564440.url(scheme.get, call_564440.host, call_564440.base,
                         call_564440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564440, url, valid)

proc call*(call_564441: Call_ProcessesListAcceptingPorts_564429;
          machineName: string; apiVersion: string; processName: string;
          subscriptionId: string; resourceGroupName: string; workspaceName: string;
          startTime: string = ""; endTime: string = ""): Recallable =
  ## processesListAcceptingPorts
  ## Returns a collection of ports on which this process is accepting
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   processName: string (required)
  ##              : Process resource name.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564442 = newJObject()
  var query_564443 = newJObject()
  add(path_564442, "machineName", newJString(machineName))
  add(query_564443, "api-version", newJString(apiVersion))
  add(path_564442, "processName", newJString(processName))
  add(query_564443, "startTime", newJString(startTime))
  add(path_564442, "subscriptionId", newJString(subscriptionId))
  add(path_564442, "resourceGroupName", newJString(resourceGroupName))
  add(path_564442, "workspaceName", newJString(workspaceName))
  add(query_564443, "endTime", newJString(endTime))
  result = call_564441.call(path_564442, query_564443, nil, nil, nil)

var processesListAcceptingPorts* = Call_ProcessesListAcceptingPorts_564429(
    name: "processesListAcceptingPorts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/processes/{processName}/acceptingPorts",
    validator: validate_ProcessesListAcceptingPorts_564430, base: "",
    url: url_ProcessesListAcceptingPorts_564431, schemes: {Scheme.Https})
type
  Call_ProcessesListConnections_564444 = ref object of OpenApiRestCall_563564
proc url_ProcessesListConnections_564446(protocol: Scheme; host: string;
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

proc validate_ProcessesListConnections_564445(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of connections terminating or originating at the specified process
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   processName: JString (required)
  ##              : Process resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineName` field"
  var valid_564447 = path.getOrDefault("machineName")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "machineName", valid_564447
  var valid_564448 = path.getOrDefault("processName")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "processName", valid_564448
  var valid_564449 = path.getOrDefault("subscriptionId")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "subscriptionId", valid_564449
  var valid_564450 = path.getOrDefault("resourceGroupName")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = nil)
  if valid_564450 != nil:
    section.add "resourceGroupName", valid_564450
  var valid_564451 = path.getOrDefault("workspaceName")
  valid_564451 = validateParameter(valid_564451, JString, required = true,
                                 default = nil)
  if valid_564451 != nil:
    section.add "workspaceName", valid_564451
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564452 = query.getOrDefault("api-version")
  valid_564452 = validateParameter(valid_564452, JString, required = true,
                                 default = nil)
  if valid_564452 != nil:
    section.add "api-version", valid_564452
  var valid_564453 = query.getOrDefault("startTime")
  valid_564453 = validateParameter(valid_564453, JString, required = false,
                                 default = nil)
  if valid_564453 != nil:
    section.add "startTime", valid_564453
  var valid_564454 = query.getOrDefault("endTime")
  valid_564454 = validateParameter(valid_564454, JString, required = false,
                                 default = nil)
  if valid_564454 != nil:
    section.add "endTime", valid_564454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564455: Call_ProcessesListConnections_564444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of connections terminating or originating at the specified process
  ## 
  let valid = call_564455.validator(path, query, header, formData, body)
  let scheme = call_564455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564455.url(scheme.get, call_564455.host, call_564455.base,
                         call_564455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564455, url, valid)

proc call*(call_564456: Call_ProcessesListConnections_564444; machineName: string;
          apiVersion: string; processName: string; subscriptionId: string;
          resourceGroupName: string; workspaceName: string; startTime: string = "";
          endTime: string = ""): Recallable =
  ## processesListConnections
  ## Returns a collection of connections terminating or originating at the specified process
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   processName: string (required)
  ##              : Process resource name.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564457 = newJObject()
  var query_564458 = newJObject()
  add(path_564457, "machineName", newJString(machineName))
  add(query_564458, "api-version", newJString(apiVersion))
  add(path_564457, "processName", newJString(processName))
  add(query_564458, "startTime", newJString(startTime))
  add(path_564457, "subscriptionId", newJString(subscriptionId))
  add(path_564457, "resourceGroupName", newJString(resourceGroupName))
  add(path_564457, "workspaceName", newJString(workspaceName))
  add(query_564458, "endTime", newJString(endTime))
  result = call_564456.call(path_564457, query_564458, nil, nil, nil)

var processesListConnections* = Call_ProcessesListConnections_564444(
    name: "processesListConnections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/processes/{processName}/connections",
    validator: validate_ProcessesListConnections_564445, base: "",
    url: url_ProcessesListConnections_564446, schemes: {Scheme.Https})
type
  Call_ProcessesGetLiveness_564459 = ref object of OpenApiRestCall_563564
proc url_ProcessesGetLiveness_564461(protocol: Scheme; host: string; base: string;
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

proc validate_ProcessesGetLiveness_564460(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Obtains the liveness status of the process during the specified time interval.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   machineName: JString (required)
  ##              : Machine resource name.
  ##   processName: JString (required)
  ##              : Process resource name.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `machineName` field"
  var valid_564462 = path.getOrDefault("machineName")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = nil)
  if valid_564462 != nil:
    section.add "machineName", valid_564462
  var valid_564463 = path.getOrDefault("processName")
  valid_564463 = validateParameter(valid_564463, JString, required = true,
                                 default = nil)
  if valid_564463 != nil:
    section.add "processName", valid_564463
  var valid_564464 = path.getOrDefault("subscriptionId")
  valid_564464 = validateParameter(valid_564464, JString, required = true,
                                 default = nil)
  if valid_564464 != nil:
    section.add "subscriptionId", valid_564464
  var valid_564465 = path.getOrDefault("resourceGroupName")
  valid_564465 = validateParameter(valid_564465, JString, required = true,
                                 default = nil)
  if valid_564465 != nil:
    section.add "resourceGroupName", valid_564465
  var valid_564466 = path.getOrDefault("workspaceName")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "workspaceName", valid_564466
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564467 = query.getOrDefault("api-version")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "api-version", valid_564467
  var valid_564468 = query.getOrDefault("startTime")
  valid_564468 = validateParameter(valid_564468, JString, required = false,
                                 default = nil)
  if valid_564468 != nil:
    section.add "startTime", valid_564468
  var valid_564469 = query.getOrDefault("endTime")
  valid_564469 = validateParameter(valid_564469, JString, required = false,
                                 default = nil)
  if valid_564469 != nil:
    section.add "endTime", valid_564469
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564470: Call_ProcessesGetLiveness_564459; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Obtains the liveness status of the process during the specified time interval.
  ## 
  let valid = call_564470.validator(path, query, header, formData, body)
  let scheme = call_564470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564470.url(scheme.get, call_564470.host, call_564470.base,
                         call_564470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564470, url, valid)

proc call*(call_564471: Call_ProcessesGetLiveness_564459; machineName: string;
          apiVersion: string; processName: string; subscriptionId: string;
          resourceGroupName: string; workspaceName: string; startTime: string = "";
          endTime: string = ""): Recallable =
  ## processesGetLiveness
  ## Obtains the liveness status of the process during the specified time interval.
  ##   machineName: string (required)
  ##              : Machine resource name.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   processName: string (required)
  ##              : Process resource name.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564472 = newJObject()
  var query_564473 = newJObject()
  add(path_564472, "machineName", newJString(machineName))
  add(query_564473, "api-version", newJString(apiVersion))
  add(path_564472, "processName", newJString(processName))
  add(query_564473, "startTime", newJString(startTime))
  add(path_564472, "subscriptionId", newJString(subscriptionId))
  add(path_564472, "resourceGroupName", newJString(resourceGroupName))
  add(path_564472, "workspaceName", newJString(workspaceName))
  add(query_564473, "endTime", newJString(endTime))
  result = call_564471.call(path_564472, query_564473, nil, nil, nil)

var processesGetLiveness* = Call_ProcessesGetLiveness_564459(
    name: "processesGetLiveness", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/processes/{processName}/liveness",
    validator: validate_ProcessesGetLiveness_564460, base: "",
    url: url_ProcessesGetLiveness_564461, schemes: {Scheme.Https})
type
  Call_SummariesGetMachines_564474 = ref object of OpenApiRestCall_563564
proc url_SummariesGetMachines_564476(protocol: Scheme; host: string; base: string;
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

proc validate_SummariesGetMachines_564475(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns summary information about the machines in the workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: JString (required)
  ##                : OMS workspace containing the resources of interest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564477 = path.getOrDefault("subscriptionId")
  valid_564477 = validateParameter(valid_564477, JString, required = true,
                                 default = nil)
  if valid_564477 != nil:
    section.add "subscriptionId", valid_564477
  var valid_564478 = path.getOrDefault("resourceGroupName")
  valid_564478 = validateParameter(valid_564478, JString, required = true,
                                 default = nil)
  if valid_564478 != nil:
    section.add "resourceGroupName", valid_564478
  var valid_564479 = path.getOrDefault("workspaceName")
  valid_564479 = validateParameter(valid_564479, JString, required = true,
                                 default = nil)
  if valid_564479 != nil:
    section.add "workspaceName", valid_564479
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   startTime: JString
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   endTime: JString
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564480 = query.getOrDefault("api-version")
  valid_564480 = validateParameter(valid_564480, JString, required = true,
                                 default = nil)
  if valid_564480 != nil:
    section.add "api-version", valid_564480
  var valid_564481 = query.getOrDefault("startTime")
  valid_564481 = validateParameter(valid_564481, JString, required = false,
                                 default = nil)
  if valid_564481 != nil:
    section.add "startTime", valid_564481
  var valid_564482 = query.getOrDefault("endTime")
  valid_564482 = validateParameter(valid_564482, JString, required = false,
                                 default = nil)
  if valid_564482 != nil:
    section.add "endTime", valid_564482
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564483: Call_SummariesGetMachines_564474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns summary information about the machines in the workspace.
  ## 
  let valid = call_564483.validator(path, query, header, formData, body)
  let scheme = call_564483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564483.url(scheme.get, call_564483.host, call_564483.base,
                         call_564483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564483, url, valid)

proc call*(call_564484: Call_SummariesGetMachines_564474; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; workspaceName: string;
          startTime: string = ""; endTime: string = ""): Recallable =
  ## summariesGetMachines
  ## Returns summary information about the machines in the workspace.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   startTime: string
  ##            : UTC date and time specifying the start time of an interval. When not specified the service uses DateTime.UtcNow - 10m
  ##   subscriptionId: string (required)
  ##                 : Azure subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name within the specified subscriptionId.
  ##   workspaceName: string (required)
  ##                : OMS workspace containing the resources of interest.
  ##   endTime: string
  ##          : UTC date and time specifying the end time of an interval. When not specified the service uses DateTime.UtcNow
  var path_564485 = newJObject()
  var query_564486 = newJObject()
  add(query_564486, "api-version", newJString(apiVersion))
  add(query_564486, "startTime", newJString(startTime))
  add(path_564485, "subscriptionId", newJString(subscriptionId))
  add(path_564485, "resourceGroupName", newJString(resourceGroupName))
  add(path_564485, "workspaceName", newJString(workspaceName))
  add(query_564486, "endTime", newJString(endTime))
  result = call_564484.call(path_564485, query_564486, nil, nil, nil)

var summariesGetMachines* = Call_SummariesGetMachines_564474(
    name: "summariesGetMachines", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/summaries/machines",
    validator: validate_SummariesGetMachines_564475, base: "",
    url: url_SummariesGetMachines_564476, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
