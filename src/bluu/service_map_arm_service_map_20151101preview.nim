
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "service-map-arm-service-map"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClientGroupsGet_593659 = ref object of OpenApiRestCall_593437
proc url_ClientGroupsGet_593661(protocol: Scheme; host: string; base: string;
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

proc validate_ClientGroupsGet_593660(path: JsonNode; query: JsonNode;
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
  var valid_593834 = path.getOrDefault("resourceGroupName")
  valid_593834 = validateParameter(valid_593834, JString, required = true,
                                 default = nil)
  if valid_593834 != nil:
    section.add "resourceGroupName", valid_593834
  var valid_593835 = path.getOrDefault("subscriptionId")
  valid_593835 = validateParameter(valid_593835, JString, required = true,
                                 default = nil)
  if valid_593835 != nil:
    section.add "subscriptionId", valid_593835
  var valid_593836 = path.getOrDefault("workspaceName")
  valid_593836 = validateParameter(valid_593836, JString, required = true,
                                 default = nil)
  if valid_593836 != nil:
    section.add "workspaceName", valid_593836
  var valid_593837 = path.getOrDefault("clientGroupName")
  valid_593837 = validateParameter(valid_593837, JString, required = true,
                                 default = nil)
  if valid_593837 != nil:
    section.add "clientGroupName", valid_593837
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
  var valid_593838 = query.getOrDefault("api-version")
  valid_593838 = validateParameter(valid_593838, JString, required = true,
                                 default = nil)
  if valid_593838 != nil:
    section.add "api-version", valid_593838
  var valid_593839 = query.getOrDefault("endTime")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "endTime", valid_593839
  var valid_593840 = query.getOrDefault("startTime")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "startTime", valid_593840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593863: Call_ClientGroupsGet_593659; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified client group
  ## 
  let valid = call_593863.validator(path, query, header, formData, body)
  let scheme = call_593863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593863.url(scheme.get, call_593863.host, call_593863.base,
                         call_593863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593863, url, valid)

proc call*(call_593934: Call_ClientGroupsGet_593659; resourceGroupName: string;
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
  var path_593935 = newJObject()
  var query_593937 = newJObject()
  add(path_593935, "resourceGroupName", newJString(resourceGroupName))
  add(query_593937, "api-version", newJString(apiVersion))
  add(path_593935, "subscriptionId", newJString(subscriptionId))
  add(query_593937, "endTime", newJString(endTime))
  add(query_593937, "startTime", newJString(startTime))
  add(path_593935, "workspaceName", newJString(workspaceName))
  add(path_593935, "clientGroupName", newJString(clientGroupName))
  result = call_593934.call(path_593935, query_593937, nil, nil, nil)

var clientGroupsGet* = Call_ClientGroupsGet_593659(name: "clientGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/clientGroups/{clientGroupName}",
    validator: validate_ClientGroupsGet_593660, base: "", url: url_ClientGroupsGet_593661,
    schemes: {Scheme.Https})
type
  Call_ClientGroupsListMembers_593976 = ref object of OpenApiRestCall_593437
proc url_ClientGroupsListMembers_593978(protocol: Scheme; host: string; base: string;
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

proc validate_ClientGroupsListMembers_593977(path: JsonNode; query: JsonNode;
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
  var valid_593980 = path.getOrDefault("resourceGroupName")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "resourceGroupName", valid_593980
  var valid_593981 = path.getOrDefault("subscriptionId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "subscriptionId", valid_593981
  var valid_593982 = path.getOrDefault("workspaceName")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "workspaceName", valid_593982
  var valid_593983 = path.getOrDefault("clientGroupName")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "clientGroupName", valid_593983
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
  var valid_593984 = query.getOrDefault("api-version")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "api-version", valid_593984
  var valid_593985 = query.getOrDefault("endTime")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "endTime", valid_593985
  var valid_593986 = query.getOrDefault("$top")
  valid_593986 = validateParameter(valid_593986, JInt, required = false, default = nil)
  if valid_593986 != nil:
    section.add "$top", valid_593986
  var valid_593987 = query.getOrDefault("startTime")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "startTime", valid_593987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593988: Call_ClientGroupsListMembers_593976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the members of the client group during the specified time interval.
  ## 
  let valid = call_593988.validator(path, query, header, formData, body)
  let scheme = call_593988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593988.url(scheme.get, call_593988.host, call_593988.base,
                         call_593988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593988, url, valid)

proc call*(call_593989: Call_ClientGroupsListMembers_593976;
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
  var path_593990 = newJObject()
  var query_593991 = newJObject()
  add(path_593990, "resourceGroupName", newJString(resourceGroupName))
  add(query_593991, "api-version", newJString(apiVersion))
  add(path_593990, "subscriptionId", newJString(subscriptionId))
  add(query_593991, "endTime", newJString(endTime))
  add(query_593991, "$top", newJInt(Top))
  add(query_593991, "startTime", newJString(startTime))
  add(path_593990, "workspaceName", newJString(workspaceName))
  add(path_593990, "clientGroupName", newJString(clientGroupName))
  result = call_593989.call(path_593990, query_593991, nil, nil, nil)

var clientGroupsListMembers* = Call_ClientGroupsListMembers_593976(
    name: "clientGroupsListMembers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/clientGroups/{clientGroupName}/members",
    validator: validate_ClientGroupsListMembers_593977, base: "",
    url: url_ClientGroupsListMembers_593978, schemes: {Scheme.Https})
type
  Call_ClientGroupsGetMembersCount_593992 = ref object of OpenApiRestCall_593437
proc url_ClientGroupsGetMembersCount_593994(protocol: Scheme; host: string;
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

proc validate_ClientGroupsGetMembersCount_593993(path: JsonNode; query: JsonNode;
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
  var valid_593995 = path.getOrDefault("resourceGroupName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "resourceGroupName", valid_593995
  var valid_593996 = path.getOrDefault("subscriptionId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "subscriptionId", valid_593996
  var valid_593997 = path.getOrDefault("workspaceName")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "workspaceName", valid_593997
  var valid_593998 = path.getOrDefault("clientGroupName")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "clientGroupName", valid_593998
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
  var valid_593999 = query.getOrDefault("api-version")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "api-version", valid_593999
  var valid_594000 = query.getOrDefault("endTime")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "endTime", valid_594000
  var valid_594001 = query.getOrDefault("startTime")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "startTime", valid_594001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594002: Call_ClientGroupsGetMembersCount_593992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the approximate number of members in the client group.
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_ClientGroupsGetMembersCount_593992;
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
  var path_594004 = newJObject()
  var query_594005 = newJObject()
  add(path_594004, "resourceGroupName", newJString(resourceGroupName))
  add(query_594005, "api-version", newJString(apiVersion))
  add(path_594004, "subscriptionId", newJString(subscriptionId))
  add(query_594005, "endTime", newJString(endTime))
  add(query_594005, "startTime", newJString(startTime))
  add(path_594004, "workspaceName", newJString(workspaceName))
  add(path_594004, "clientGroupName", newJString(clientGroupName))
  result = call_594003.call(path_594004, query_594005, nil, nil, nil)

var clientGroupsGetMembersCount* = Call_ClientGroupsGetMembersCount_593992(
    name: "clientGroupsGetMembersCount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/clientGroups/{clientGroupName}/membersCount",
    validator: validate_ClientGroupsGetMembersCount_593993, base: "",
    url: url_ClientGroupsGetMembersCount_593994, schemes: {Scheme.Https})
type
  Call_MapsGenerate_594006 = ref object of OpenApiRestCall_593437
proc url_MapsGenerate_594008(protocol: Scheme; host: string; base: string;
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

proc validate_MapsGenerate_594007(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594009 = path.getOrDefault("resourceGroupName")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "resourceGroupName", valid_594009
  var valid_594010 = path.getOrDefault("subscriptionId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "subscriptionId", valid_594010
  var valid_594011 = path.getOrDefault("workspaceName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "workspaceName", valid_594011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594012 = query.getOrDefault("api-version")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "api-version", valid_594012
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

proc call*(call_594014: Call_MapsGenerate_594006; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates the specified map.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_MapsGenerate_594006; resourceGroupName: string;
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
  var path_594016 = newJObject()
  var query_594017 = newJObject()
  var body_594018 = newJObject()
  add(path_594016, "resourceGroupName", newJString(resourceGroupName))
  add(query_594017, "api-version", newJString(apiVersion))
  add(path_594016, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_594018 = request
  add(path_594016, "workspaceName", newJString(workspaceName))
  result = call_594015.call(path_594016, query_594017, nil, nil, body_594018)

var mapsGenerate* = Call_MapsGenerate_594006(name: "mapsGenerate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/generateMap",
    validator: validate_MapsGenerate_594007, base: "", url: url_MapsGenerate_594008,
    schemes: {Scheme.Https})
type
  Call_MachineGroupsCreate_594032 = ref object of OpenApiRestCall_593437
proc url_MachineGroupsCreate_594034(protocol: Scheme; host: string; base: string;
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

proc validate_MachineGroupsCreate_594033(path: JsonNode; query: JsonNode;
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
  var valid_594062 = path.getOrDefault("resourceGroupName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "resourceGroupName", valid_594062
  var valid_594063 = path.getOrDefault("subscriptionId")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "subscriptionId", valid_594063
  var valid_594064 = path.getOrDefault("workspaceName")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "workspaceName", valid_594064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594065 = query.getOrDefault("api-version")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "api-version", valid_594065
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

proc call*(call_594067: Call_MachineGroupsCreate_594032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new machine group.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_MachineGroupsCreate_594032; resourceGroupName: string;
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
  var path_594069 = newJObject()
  var query_594070 = newJObject()
  var body_594071 = newJObject()
  add(path_594069, "resourceGroupName", newJString(resourceGroupName))
  add(query_594070, "api-version", newJString(apiVersion))
  add(path_594069, "subscriptionId", newJString(subscriptionId))
  add(path_594069, "workspaceName", newJString(workspaceName))
  if machineGroup != nil:
    body_594071 = machineGroup
  result = call_594068.call(path_594069, query_594070, nil, nil, body_594071)

var machineGroupsCreate* = Call_MachineGroupsCreate_594032(
    name: "machineGroupsCreate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machineGroups",
    validator: validate_MachineGroupsCreate_594033, base: "",
    url: url_MachineGroupsCreate_594034, schemes: {Scheme.Https})
type
  Call_MachineGroupsListByWorkspace_594019 = ref object of OpenApiRestCall_593437
proc url_MachineGroupsListByWorkspace_594021(protocol: Scheme; host: string;
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

proc validate_MachineGroupsListByWorkspace_594020(path: JsonNode; query: JsonNode;
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
  var valid_594022 = path.getOrDefault("resourceGroupName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "resourceGroupName", valid_594022
  var valid_594023 = path.getOrDefault("subscriptionId")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "subscriptionId", valid_594023
  var valid_594024 = path.getOrDefault("workspaceName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "workspaceName", valid_594024
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
  var valid_594025 = query.getOrDefault("api-version")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "api-version", valid_594025
  var valid_594026 = query.getOrDefault("endTime")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "endTime", valid_594026
  var valid_594027 = query.getOrDefault("startTime")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "startTime", valid_594027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594028: Call_MachineGroupsListByWorkspace_594019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all machine groups during the specified time interval.
  ## 
  let valid = call_594028.validator(path, query, header, formData, body)
  let scheme = call_594028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594028.url(scheme.get, call_594028.host, call_594028.base,
                         call_594028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594028, url, valid)

proc call*(call_594029: Call_MachineGroupsListByWorkspace_594019;
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
  var path_594030 = newJObject()
  var query_594031 = newJObject()
  add(path_594030, "resourceGroupName", newJString(resourceGroupName))
  add(query_594031, "api-version", newJString(apiVersion))
  add(path_594030, "subscriptionId", newJString(subscriptionId))
  add(query_594031, "endTime", newJString(endTime))
  add(query_594031, "startTime", newJString(startTime))
  add(path_594030, "workspaceName", newJString(workspaceName))
  result = call_594029.call(path_594030, query_594031, nil, nil, nil)

var machineGroupsListByWorkspace* = Call_MachineGroupsListByWorkspace_594019(
    name: "machineGroupsListByWorkspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machineGroups",
    validator: validate_MachineGroupsListByWorkspace_594020, base: "",
    url: url_MachineGroupsListByWorkspace_594021, schemes: {Scheme.Https})
type
  Call_MachineGroupsUpdate_594086 = ref object of OpenApiRestCall_593437
proc url_MachineGroupsUpdate_594088(protocol: Scheme; host: string; base: string;
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

proc validate_MachineGroupsUpdate_594087(path: JsonNode; query: JsonNode;
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
  var valid_594089 = path.getOrDefault("resourceGroupName")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "resourceGroupName", valid_594089
  var valid_594090 = path.getOrDefault("subscriptionId")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "subscriptionId", valid_594090
  var valid_594091 = path.getOrDefault("machineGroupName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "machineGroupName", valid_594091
  var valid_594092 = path.getOrDefault("workspaceName")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "workspaceName", valid_594092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594093 = query.getOrDefault("api-version")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "api-version", valid_594093
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

proc call*(call_594095: Call_MachineGroupsUpdate_594086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a machine group.
  ## 
  let valid = call_594095.validator(path, query, header, formData, body)
  let scheme = call_594095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594095.url(scheme.get, call_594095.host, call_594095.base,
                         call_594095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594095, url, valid)

proc call*(call_594096: Call_MachineGroupsUpdate_594086; resourceGroupName: string;
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
  var path_594097 = newJObject()
  var query_594098 = newJObject()
  var body_594099 = newJObject()
  add(path_594097, "resourceGroupName", newJString(resourceGroupName))
  add(query_594098, "api-version", newJString(apiVersion))
  add(path_594097, "subscriptionId", newJString(subscriptionId))
  add(path_594097, "machineGroupName", newJString(machineGroupName))
  add(path_594097, "workspaceName", newJString(workspaceName))
  if machineGroup != nil:
    body_594099 = machineGroup
  result = call_594096.call(path_594097, query_594098, nil, nil, body_594099)

var machineGroupsUpdate* = Call_MachineGroupsUpdate_594086(
    name: "machineGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machineGroups/{machineGroupName}",
    validator: validate_MachineGroupsUpdate_594087, base: "",
    url: url_MachineGroupsUpdate_594088, schemes: {Scheme.Https})
type
  Call_MachineGroupsGet_594072 = ref object of OpenApiRestCall_593437
proc url_MachineGroupsGet_594074(protocol: Scheme; host: string; base: string;
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

proc validate_MachineGroupsGet_594073(path: JsonNode; query: JsonNode;
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
  var valid_594075 = path.getOrDefault("resourceGroupName")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "resourceGroupName", valid_594075
  var valid_594076 = path.getOrDefault("subscriptionId")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "subscriptionId", valid_594076
  var valid_594077 = path.getOrDefault("machineGroupName")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "machineGroupName", valid_594077
  var valid_594078 = path.getOrDefault("workspaceName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "workspaceName", valid_594078
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
  var valid_594079 = query.getOrDefault("api-version")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "api-version", valid_594079
  var valid_594080 = query.getOrDefault("endTime")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "endTime", valid_594080
  var valid_594081 = query.getOrDefault("startTime")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "startTime", valid_594081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594082: Call_MachineGroupsGet_594072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified machine group as it existed during the specified time interval.
  ## 
  let valid = call_594082.validator(path, query, header, formData, body)
  let scheme = call_594082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594082.url(scheme.get, call_594082.host, call_594082.base,
                         call_594082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594082, url, valid)

proc call*(call_594083: Call_MachineGroupsGet_594072; resourceGroupName: string;
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
  var path_594084 = newJObject()
  var query_594085 = newJObject()
  add(path_594084, "resourceGroupName", newJString(resourceGroupName))
  add(query_594085, "api-version", newJString(apiVersion))
  add(path_594084, "subscriptionId", newJString(subscriptionId))
  add(query_594085, "endTime", newJString(endTime))
  add(path_594084, "machineGroupName", newJString(machineGroupName))
  add(query_594085, "startTime", newJString(startTime))
  add(path_594084, "workspaceName", newJString(workspaceName))
  result = call_594083.call(path_594084, query_594085, nil, nil, nil)

var machineGroupsGet* = Call_MachineGroupsGet_594072(name: "machineGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machineGroups/{machineGroupName}",
    validator: validate_MachineGroupsGet_594073, base: "",
    url: url_MachineGroupsGet_594074, schemes: {Scheme.Https})
type
  Call_MachineGroupsDelete_594100 = ref object of OpenApiRestCall_593437
proc url_MachineGroupsDelete_594102(protocol: Scheme; host: string; base: string;
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

proc validate_MachineGroupsDelete_594101(path: JsonNode; query: JsonNode;
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
  var valid_594103 = path.getOrDefault("resourceGroupName")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "resourceGroupName", valid_594103
  var valid_594104 = path.getOrDefault("subscriptionId")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "subscriptionId", valid_594104
  var valid_594105 = path.getOrDefault("machineGroupName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "machineGroupName", valid_594105
  var valid_594106 = path.getOrDefault("workspaceName")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "workspaceName", valid_594106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594107 = query.getOrDefault("api-version")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "api-version", valid_594107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594108: Call_MachineGroupsDelete_594100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Machine Group.
  ## 
  let valid = call_594108.validator(path, query, header, formData, body)
  let scheme = call_594108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594108.url(scheme.get, call_594108.host, call_594108.base,
                         call_594108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594108, url, valid)

proc call*(call_594109: Call_MachineGroupsDelete_594100; resourceGroupName: string;
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
  var path_594110 = newJObject()
  var query_594111 = newJObject()
  add(path_594110, "resourceGroupName", newJString(resourceGroupName))
  add(query_594111, "api-version", newJString(apiVersion))
  add(path_594110, "subscriptionId", newJString(subscriptionId))
  add(path_594110, "machineGroupName", newJString(machineGroupName))
  add(path_594110, "workspaceName", newJString(workspaceName))
  result = call_594109.call(path_594110, query_594111, nil, nil, nil)

var machineGroupsDelete* = Call_MachineGroupsDelete_594100(
    name: "machineGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machineGroups/{machineGroupName}",
    validator: validate_MachineGroupsDelete_594101, base: "",
    url: url_MachineGroupsDelete_594102, schemes: {Scheme.Https})
type
  Call_MachinesListByWorkspace_594112 = ref object of OpenApiRestCall_593437
proc url_MachinesListByWorkspace_594114(protocol: Scheme; host: string; base: string;
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

proc validate_MachinesListByWorkspace_594113(path: JsonNode; query: JsonNode;
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
  var valid_594115 = path.getOrDefault("resourceGroupName")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "resourceGroupName", valid_594115
  var valid_594116 = path.getOrDefault("subscriptionId")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "subscriptionId", valid_594116
  var valid_594117 = path.getOrDefault("workspaceName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "workspaceName", valid_594117
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
  var valid_594118 = query.getOrDefault("api-version")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "api-version", valid_594118
  var valid_594132 = query.getOrDefault("live")
  valid_594132 = validateParameter(valid_594132, JBool, required = false,
                                 default = newJBool(true))
  if valid_594132 != nil:
    section.add "live", valid_594132
  var valid_594133 = query.getOrDefault("endTime")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "endTime", valid_594133
  var valid_594134 = query.getOrDefault("$top")
  valid_594134 = validateParameter(valid_594134, JInt, required = false, default = nil)
  if valid_594134 != nil:
    section.add "$top", valid_594134
  var valid_594135 = query.getOrDefault("timestamp")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "timestamp", valid_594135
  var valid_594136 = query.getOrDefault("startTime")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "startTime", valid_594136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594137: Call_MachinesListByWorkspace_594112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of machines matching the specified conditions.  The returned collection represents either machines that are active/live during the specified interval  of time (`live=true` and `startTime`/`endTime` are specified) or that are known to have existed at or  some time prior to the specified point in time (`live=false` and `timestamp` is specified).
  ## 
  let valid = call_594137.validator(path, query, header, formData, body)
  let scheme = call_594137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594137.url(scheme.get, call_594137.host, call_594137.base,
                         call_594137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594137, url, valid)

proc call*(call_594138: Call_MachinesListByWorkspace_594112;
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
  var path_594139 = newJObject()
  var query_594140 = newJObject()
  add(path_594139, "resourceGroupName", newJString(resourceGroupName))
  add(query_594140, "api-version", newJString(apiVersion))
  add(path_594139, "subscriptionId", newJString(subscriptionId))
  add(query_594140, "live", newJBool(live))
  add(query_594140, "endTime", newJString(endTime))
  add(query_594140, "$top", newJInt(Top))
  add(query_594140, "timestamp", newJString(timestamp))
  add(query_594140, "startTime", newJString(startTime))
  add(path_594139, "workspaceName", newJString(workspaceName))
  result = call_594138.call(path_594139, query_594140, nil, nil, nil)

var machinesListByWorkspace* = Call_MachinesListByWorkspace_594112(
    name: "machinesListByWorkspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines",
    validator: validate_MachinesListByWorkspace_594113, base: "",
    url: url_MachinesListByWorkspace_594114, schemes: {Scheme.Https})
type
  Call_MachinesGet_594141 = ref object of OpenApiRestCall_593437
proc url_MachinesGet_594143(protocol: Scheme; host: string; base: string;
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

proc validate_MachinesGet_594142(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594144 = path.getOrDefault("resourceGroupName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "resourceGroupName", valid_594144
  var valid_594145 = path.getOrDefault("machineName")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "machineName", valid_594145
  var valid_594146 = path.getOrDefault("subscriptionId")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "subscriptionId", valid_594146
  var valid_594147 = path.getOrDefault("workspaceName")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "workspaceName", valid_594147
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   timestamp: JString
  ##            : UTC date and time specifying a time instance relative to which to evaluate the machine resource. When not specified, the service uses DateTime.UtcNow.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594148 = query.getOrDefault("api-version")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "api-version", valid_594148
  var valid_594149 = query.getOrDefault("timestamp")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "timestamp", valid_594149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594150: Call_MachinesGet_594141; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified machine.
  ## 
  let valid = call_594150.validator(path, query, header, formData, body)
  let scheme = call_594150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594150.url(scheme.get, call_594150.host, call_594150.base,
                         call_594150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594150, url, valid)

proc call*(call_594151: Call_MachinesGet_594141; resourceGroupName: string;
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
  var path_594152 = newJObject()
  var query_594153 = newJObject()
  add(path_594152, "resourceGroupName", newJString(resourceGroupName))
  add(query_594153, "api-version", newJString(apiVersion))
  add(path_594152, "machineName", newJString(machineName))
  add(path_594152, "subscriptionId", newJString(subscriptionId))
  add(query_594153, "timestamp", newJString(timestamp))
  add(path_594152, "workspaceName", newJString(workspaceName))
  result = call_594151.call(path_594152, query_594153, nil, nil, nil)

var machinesGet* = Call_MachinesGet_594141(name: "machinesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}",
                                        validator: validate_MachinesGet_594142,
                                        base: "", url: url_MachinesGet_594143,
                                        schemes: {Scheme.Https})
type
  Call_MachinesListConnections_594154 = ref object of OpenApiRestCall_593437
proc url_MachinesListConnections_594156(protocol: Scheme; host: string; base: string;
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

proc validate_MachinesListConnections_594155(path: JsonNode; query: JsonNode;
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
  var valid_594157 = path.getOrDefault("resourceGroupName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "resourceGroupName", valid_594157
  var valid_594158 = path.getOrDefault("machineName")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "machineName", valid_594158
  var valid_594159 = path.getOrDefault("subscriptionId")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "subscriptionId", valid_594159
  var valid_594160 = path.getOrDefault("workspaceName")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "workspaceName", valid_594160
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
  var valid_594161 = query.getOrDefault("api-version")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "api-version", valid_594161
  var valid_594162 = query.getOrDefault("endTime")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "endTime", valid_594162
  var valid_594163 = query.getOrDefault("startTime")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "startTime", valid_594163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594164: Call_MachinesListConnections_594154; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of connections terminating or originating at the specified machine
  ## 
  let valid = call_594164.validator(path, query, header, formData, body)
  let scheme = call_594164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594164.url(scheme.get, call_594164.host, call_594164.base,
                         call_594164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594164, url, valid)

proc call*(call_594165: Call_MachinesListConnections_594154;
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
  var path_594166 = newJObject()
  var query_594167 = newJObject()
  add(path_594166, "resourceGroupName", newJString(resourceGroupName))
  add(query_594167, "api-version", newJString(apiVersion))
  add(path_594166, "machineName", newJString(machineName))
  add(path_594166, "subscriptionId", newJString(subscriptionId))
  add(query_594167, "endTime", newJString(endTime))
  add(query_594167, "startTime", newJString(startTime))
  add(path_594166, "workspaceName", newJString(workspaceName))
  result = call_594165.call(path_594166, query_594167, nil, nil, nil)

var machinesListConnections* = Call_MachinesListConnections_594154(
    name: "machinesListConnections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/connections",
    validator: validate_MachinesListConnections_594155, base: "",
    url: url_MachinesListConnections_594156, schemes: {Scheme.Https})
type
  Call_MachinesGetLiveness_594168 = ref object of OpenApiRestCall_593437
proc url_MachinesGetLiveness_594170(protocol: Scheme; host: string; base: string;
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

proc validate_MachinesGetLiveness_594169(path: JsonNode; query: JsonNode;
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
  var valid_594171 = path.getOrDefault("resourceGroupName")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "resourceGroupName", valid_594171
  var valid_594172 = path.getOrDefault("machineName")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "machineName", valid_594172
  var valid_594173 = path.getOrDefault("subscriptionId")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "subscriptionId", valid_594173
  var valid_594174 = path.getOrDefault("workspaceName")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "workspaceName", valid_594174
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
  var valid_594175 = query.getOrDefault("api-version")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "api-version", valid_594175
  var valid_594176 = query.getOrDefault("endTime")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "endTime", valid_594176
  var valid_594177 = query.getOrDefault("startTime")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "startTime", valid_594177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594178: Call_MachinesGetLiveness_594168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Obtains the liveness status of the machine during the specified time interval.
  ## 
  let valid = call_594178.validator(path, query, header, formData, body)
  let scheme = call_594178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594178.url(scheme.get, call_594178.host, call_594178.base,
                         call_594178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594178, url, valid)

proc call*(call_594179: Call_MachinesGetLiveness_594168; resourceGroupName: string;
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
  var path_594180 = newJObject()
  var query_594181 = newJObject()
  add(path_594180, "resourceGroupName", newJString(resourceGroupName))
  add(query_594181, "api-version", newJString(apiVersion))
  add(path_594180, "machineName", newJString(machineName))
  add(path_594180, "subscriptionId", newJString(subscriptionId))
  add(query_594181, "endTime", newJString(endTime))
  add(query_594181, "startTime", newJString(startTime))
  add(path_594180, "workspaceName", newJString(workspaceName))
  result = call_594179.call(path_594180, query_594181, nil, nil, nil)

var machinesGetLiveness* = Call_MachinesGetLiveness_594168(
    name: "machinesGetLiveness", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/liveness",
    validator: validate_MachinesGetLiveness_594169, base: "",
    url: url_MachinesGetLiveness_594170, schemes: {Scheme.Https})
type
  Call_MachinesListMachineGroupMembership_594182 = ref object of OpenApiRestCall_593437
proc url_MachinesListMachineGroupMembership_594184(protocol: Scheme; host: string;
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

proc validate_MachinesListMachineGroupMembership_594183(path: JsonNode;
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
  var valid_594185 = path.getOrDefault("resourceGroupName")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "resourceGroupName", valid_594185
  var valid_594186 = path.getOrDefault("machineName")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "machineName", valid_594186
  var valid_594187 = path.getOrDefault("subscriptionId")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "subscriptionId", valid_594187
  var valid_594188 = path.getOrDefault("workspaceName")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "workspaceName", valid_594188
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
  var valid_594189 = query.getOrDefault("api-version")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "api-version", valid_594189
  var valid_594190 = query.getOrDefault("endTime")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "endTime", valid_594190
  var valid_594191 = query.getOrDefault("startTime")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "startTime", valid_594191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594192: Call_MachinesListMachineGroupMembership_594182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a collection of machine groups this machine belongs to during the specified time interval.
  ## 
  let valid = call_594192.validator(path, query, header, formData, body)
  let scheme = call_594192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594192.url(scheme.get, call_594192.host, call_594192.base,
                         call_594192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594192, url, valid)

proc call*(call_594193: Call_MachinesListMachineGroupMembership_594182;
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
  var path_594194 = newJObject()
  var query_594195 = newJObject()
  add(path_594194, "resourceGroupName", newJString(resourceGroupName))
  add(query_594195, "api-version", newJString(apiVersion))
  add(path_594194, "machineName", newJString(machineName))
  add(path_594194, "subscriptionId", newJString(subscriptionId))
  add(query_594195, "endTime", newJString(endTime))
  add(query_594195, "startTime", newJString(startTime))
  add(path_594194, "workspaceName", newJString(workspaceName))
  result = call_594193.call(path_594194, query_594195, nil, nil, nil)

var machinesListMachineGroupMembership* = Call_MachinesListMachineGroupMembership_594182(
    name: "machinesListMachineGroupMembership", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/machineGroups",
    validator: validate_MachinesListMachineGroupMembership_594183, base: "",
    url: url_MachinesListMachineGroupMembership_594184, schemes: {Scheme.Https})
type
  Call_MachinesListPorts_594196 = ref object of OpenApiRestCall_593437
proc url_MachinesListPorts_594198(protocol: Scheme; host: string; base: string;
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

proc validate_MachinesListPorts_594197(path: JsonNode; query: JsonNode;
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
  var valid_594199 = path.getOrDefault("resourceGroupName")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "resourceGroupName", valid_594199
  var valid_594200 = path.getOrDefault("machineName")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "machineName", valid_594200
  var valid_594201 = path.getOrDefault("subscriptionId")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "subscriptionId", valid_594201
  var valid_594202 = path.getOrDefault("workspaceName")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "workspaceName", valid_594202
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
  var valid_594203 = query.getOrDefault("api-version")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "api-version", valid_594203
  var valid_594204 = query.getOrDefault("endTime")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "endTime", valid_594204
  var valid_594205 = query.getOrDefault("startTime")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "startTime", valid_594205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594206: Call_MachinesListPorts_594196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of live ports on the specified machine during the specified time interval.
  ## 
  let valid = call_594206.validator(path, query, header, formData, body)
  let scheme = call_594206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594206.url(scheme.get, call_594206.host, call_594206.base,
                         call_594206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594206, url, valid)

proc call*(call_594207: Call_MachinesListPorts_594196; resourceGroupName: string;
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
  var path_594208 = newJObject()
  var query_594209 = newJObject()
  add(path_594208, "resourceGroupName", newJString(resourceGroupName))
  add(query_594209, "api-version", newJString(apiVersion))
  add(path_594208, "machineName", newJString(machineName))
  add(path_594208, "subscriptionId", newJString(subscriptionId))
  add(query_594209, "endTime", newJString(endTime))
  add(query_594209, "startTime", newJString(startTime))
  add(path_594208, "workspaceName", newJString(workspaceName))
  result = call_594207.call(path_594208, query_594209, nil, nil, nil)

var machinesListPorts* = Call_MachinesListPorts_594196(name: "machinesListPorts",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/ports",
    validator: validate_MachinesListPorts_594197, base: "",
    url: url_MachinesListPorts_594198, schemes: {Scheme.Https})
type
  Call_PortsGet_594210 = ref object of OpenApiRestCall_593437
proc url_PortsGet_594212(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PortsGet_594211(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594213 = path.getOrDefault("resourceGroupName")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "resourceGroupName", valid_594213
  var valid_594214 = path.getOrDefault("machineName")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "machineName", valid_594214
  var valid_594215 = path.getOrDefault("subscriptionId")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "subscriptionId", valid_594215
  var valid_594216 = path.getOrDefault("portName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "portName", valid_594216
  var valid_594217 = path.getOrDefault("workspaceName")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "workspaceName", valid_594217
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
  var valid_594218 = query.getOrDefault("api-version")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "api-version", valid_594218
  var valid_594219 = query.getOrDefault("endTime")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "endTime", valid_594219
  var valid_594220 = query.getOrDefault("startTime")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = nil)
  if valid_594220 != nil:
    section.add "startTime", valid_594220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594221: Call_PortsGet_594210; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified port. The port must be live during the specified time interval. If the port is not live during the interval, status 404 (Not Found) is returned.
  ## 
  let valid = call_594221.validator(path, query, header, formData, body)
  let scheme = call_594221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594221.url(scheme.get, call_594221.host, call_594221.base,
                         call_594221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594221, url, valid)

proc call*(call_594222: Call_PortsGet_594210; resourceGroupName: string;
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
  var path_594223 = newJObject()
  var query_594224 = newJObject()
  add(path_594223, "resourceGroupName", newJString(resourceGroupName))
  add(query_594224, "api-version", newJString(apiVersion))
  add(path_594223, "machineName", newJString(machineName))
  add(path_594223, "subscriptionId", newJString(subscriptionId))
  add(query_594224, "endTime", newJString(endTime))
  add(path_594223, "portName", newJString(portName))
  add(query_594224, "startTime", newJString(startTime))
  add(path_594223, "workspaceName", newJString(workspaceName))
  result = call_594222.call(path_594223, query_594224, nil, nil, nil)

var portsGet* = Call_PortsGet_594210(name: "portsGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/ports/{portName}",
                                  validator: validate_PortsGet_594211, base: "",
                                  url: url_PortsGet_594212,
                                  schemes: {Scheme.Https})
type
  Call_PortsListAcceptingProcesses_594225 = ref object of OpenApiRestCall_593437
proc url_PortsListAcceptingProcesses_594227(protocol: Scheme; host: string;
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

proc validate_PortsListAcceptingProcesses_594226(path: JsonNode; query: JsonNode;
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
  var valid_594228 = path.getOrDefault("resourceGroupName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "resourceGroupName", valid_594228
  var valid_594229 = path.getOrDefault("machineName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "machineName", valid_594229
  var valid_594230 = path.getOrDefault("subscriptionId")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "subscriptionId", valid_594230
  var valid_594231 = path.getOrDefault("portName")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "portName", valid_594231
  var valid_594232 = path.getOrDefault("workspaceName")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "workspaceName", valid_594232
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
  var valid_594233 = query.getOrDefault("api-version")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "api-version", valid_594233
  var valid_594234 = query.getOrDefault("endTime")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "endTime", valid_594234
  var valid_594235 = query.getOrDefault("startTime")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "startTime", valid_594235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594236: Call_PortsListAcceptingProcesses_594225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of processes accepting on the specified port
  ## 
  let valid = call_594236.validator(path, query, header, formData, body)
  let scheme = call_594236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594236.url(scheme.get, call_594236.host, call_594236.base,
                         call_594236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594236, url, valid)

proc call*(call_594237: Call_PortsListAcceptingProcesses_594225;
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
  var path_594238 = newJObject()
  var query_594239 = newJObject()
  add(path_594238, "resourceGroupName", newJString(resourceGroupName))
  add(query_594239, "api-version", newJString(apiVersion))
  add(path_594238, "machineName", newJString(machineName))
  add(path_594238, "subscriptionId", newJString(subscriptionId))
  add(query_594239, "endTime", newJString(endTime))
  add(path_594238, "portName", newJString(portName))
  add(query_594239, "startTime", newJString(startTime))
  add(path_594238, "workspaceName", newJString(workspaceName))
  result = call_594237.call(path_594238, query_594239, nil, nil, nil)

var portsListAcceptingProcesses* = Call_PortsListAcceptingProcesses_594225(
    name: "portsListAcceptingProcesses", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/ports/{portName}/acceptingProcesses",
    validator: validate_PortsListAcceptingProcesses_594226, base: "",
    url: url_PortsListAcceptingProcesses_594227, schemes: {Scheme.Https})
type
  Call_PortsListConnections_594240 = ref object of OpenApiRestCall_593437
proc url_PortsListConnections_594242(protocol: Scheme; host: string; base: string;
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

proc validate_PortsListConnections_594241(path: JsonNode; query: JsonNode;
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
  var valid_594243 = path.getOrDefault("resourceGroupName")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "resourceGroupName", valid_594243
  var valid_594244 = path.getOrDefault("machineName")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "machineName", valid_594244
  var valid_594245 = path.getOrDefault("subscriptionId")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "subscriptionId", valid_594245
  var valid_594246 = path.getOrDefault("portName")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "portName", valid_594246
  var valid_594247 = path.getOrDefault("workspaceName")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "workspaceName", valid_594247
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
  var valid_594248 = query.getOrDefault("api-version")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "api-version", valid_594248
  var valid_594249 = query.getOrDefault("endTime")
  valid_594249 = validateParameter(valid_594249, JString, required = false,
                                 default = nil)
  if valid_594249 != nil:
    section.add "endTime", valid_594249
  var valid_594250 = query.getOrDefault("startTime")
  valid_594250 = validateParameter(valid_594250, JString, required = false,
                                 default = nil)
  if valid_594250 != nil:
    section.add "startTime", valid_594250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594251: Call_PortsListConnections_594240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of connections established via the specified port.
  ## 
  let valid = call_594251.validator(path, query, header, formData, body)
  let scheme = call_594251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594251.url(scheme.get, call_594251.host, call_594251.base,
                         call_594251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594251, url, valid)

proc call*(call_594252: Call_PortsListConnections_594240;
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
  var path_594253 = newJObject()
  var query_594254 = newJObject()
  add(path_594253, "resourceGroupName", newJString(resourceGroupName))
  add(query_594254, "api-version", newJString(apiVersion))
  add(path_594253, "machineName", newJString(machineName))
  add(path_594253, "subscriptionId", newJString(subscriptionId))
  add(query_594254, "endTime", newJString(endTime))
  add(path_594253, "portName", newJString(portName))
  add(query_594254, "startTime", newJString(startTime))
  add(path_594253, "workspaceName", newJString(workspaceName))
  result = call_594252.call(path_594253, query_594254, nil, nil, nil)

var portsListConnections* = Call_PortsListConnections_594240(
    name: "portsListConnections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/ports/{portName}/connections",
    validator: validate_PortsListConnections_594241, base: "",
    url: url_PortsListConnections_594242, schemes: {Scheme.Https})
type
  Call_PortsGetLiveness_594255 = ref object of OpenApiRestCall_593437
proc url_PortsGetLiveness_594257(protocol: Scheme; host: string; base: string;
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

proc validate_PortsGetLiveness_594256(path: JsonNode; query: JsonNode;
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
  var valid_594258 = path.getOrDefault("resourceGroupName")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "resourceGroupName", valid_594258
  var valid_594259 = path.getOrDefault("machineName")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "machineName", valid_594259
  var valid_594260 = path.getOrDefault("subscriptionId")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "subscriptionId", valid_594260
  var valid_594261 = path.getOrDefault("portName")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "portName", valid_594261
  var valid_594262 = path.getOrDefault("workspaceName")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "workspaceName", valid_594262
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
  var valid_594263 = query.getOrDefault("api-version")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "api-version", valid_594263
  var valid_594264 = query.getOrDefault("endTime")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = nil)
  if valid_594264 != nil:
    section.add "endTime", valid_594264
  var valid_594265 = query.getOrDefault("startTime")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = nil)
  if valid_594265 != nil:
    section.add "startTime", valid_594265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594266: Call_PortsGetLiveness_594255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Obtains the liveness status of the port during the specified time interval.
  ## 
  let valid = call_594266.validator(path, query, header, formData, body)
  let scheme = call_594266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594266.url(scheme.get, call_594266.host, call_594266.base,
                         call_594266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594266, url, valid)

proc call*(call_594267: Call_PortsGetLiveness_594255; resourceGroupName: string;
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
  var path_594268 = newJObject()
  var query_594269 = newJObject()
  add(path_594268, "resourceGroupName", newJString(resourceGroupName))
  add(query_594269, "api-version", newJString(apiVersion))
  add(path_594268, "machineName", newJString(machineName))
  add(path_594268, "subscriptionId", newJString(subscriptionId))
  add(query_594269, "endTime", newJString(endTime))
  add(path_594268, "portName", newJString(portName))
  add(query_594269, "startTime", newJString(startTime))
  add(path_594268, "workspaceName", newJString(workspaceName))
  result = call_594267.call(path_594268, query_594269, nil, nil, nil)

var portsGetLiveness* = Call_PortsGetLiveness_594255(name: "portsGetLiveness",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/ports/{portName}/liveness",
    validator: validate_PortsGetLiveness_594256, base: "",
    url: url_PortsGetLiveness_594257, schemes: {Scheme.Https})
type
  Call_MachinesListProcesses_594270 = ref object of OpenApiRestCall_593437
proc url_MachinesListProcesses_594272(protocol: Scheme; host: string; base: string;
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

proc validate_MachinesListProcesses_594271(path: JsonNode; query: JsonNode;
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
  var valid_594273 = path.getOrDefault("resourceGroupName")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "resourceGroupName", valid_594273
  var valid_594274 = path.getOrDefault("machineName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "machineName", valid_594274
  var valid_594275 = path.getOrDefault("subscriptionId")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "subscriptionId", valid_594275
  var valid_594276 = path.getOrDefault("workspaceName")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "workspaceName", valid_594276
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
  var valid_594277 = query.getOrDefault("api-version")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "api-version", valid_594277
  var valid_594278 = query.getOrDefault("live")
  valid_594278 = validateParameter(valid_594278, JBool, required = false,
                                 default = newJBool(true))
  if valid_594278 != nil:
    section.add "live", valid_594278
  var valid_594279 = query.getOrDefault("endTime")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "endTime", valid_594279
  var valid_594280 = query.getOrDefault("timestamp")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = nil)
  if valid_594280 != nil:
    section.add "timestamp", valid_594280
  var valid_594281 = query.getOrDefault("startTime")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = nil)
  if valid_594281 != nil:
    section.add "startTime", valid_594281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594282: Call_MachinesListProcesses_594270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of processes on the specified machine matching the specified conditions. The returned collection represents either processes that are active/live during the specified interval  of time (`live=true` and `startTime`/`endTime` are specified) or that are known to have existed at or  some time prior to the specified point in time (`live=false` and `timestamp` is specified).        
  ## 
  let valid = call_594282.validator(path, query, header, formData, body)
  let scheme = call_594282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594282.url(scheme.get, call_594282.host, call_594282.base,
                         call_594282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594282, url, valid)

proc call*(call_594283: Call_MachinesListProcesses_594270;
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
  var path_594284 = newJObject()
  var query_594285 = newJObject()
  add(path_594284, "resourceGroupName", newJString(resourceGroupName))
  add(query_594285, "api-version", newJString(apiVersion))
  add(path_594284, "machineName", newJString(machineName))
  add(path_594284, "subscriptionId", newJString(subscriptionId))
  add(query_594285, "live", newJBool(live))
  add(query_594285, "endTime", newJString(endTime))
  add(query_594285, "timestamp", newJString(timestamp))
  add(query_594285, "startTime", newJString(startTime))
  add(path_594284, "workspaceName", newJString(workspaceName))
  result = call_594283.call(path_594284, query_594285, nil, nil, nil)

var machinesListProcesses* = Call_MachinesListProcesses_594270(
    name: "machinesListProcesses", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/processes",
    validator: validate_MachinesListProcesses_594271, base: "",
    url: url_MachinesListProcesses_594272, schemes: {Scheme.Https})
type
  Call_ProcessesGet_594286 = ref object of OpenApiRestCall_593437
proc url_ProcessesGet_594288(protocol: Scheme; host: string; base: string;
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

proc validate_ProcessesGet_594287(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594289 = path.getOrDefault("resourceGroupName")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "resourceGroupName", valid_594289
  var valid_594290 = path.getOrDefault("machineName")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "machineName", valid_594290
  var valid_594291 = path.getOrDefault("subscriptionId")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "subscriptionId", valid_594291
  var valid_594292 = path.getOrDefault("processName")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "processName", valid_594292
  var valid_594293 = path.getOrDefault("workspaceName")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "workspaceName", valid_594293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   timestamp: JString
  ##            : UTC date and time specifying a time instance relative to which to evaluate a resource. When not specified, the service uses DateTime.UtcNow.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594294 = query.getOrDefault("api-version")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "api-version", valid_594294
  var valid_594295 = query.getOrDefault("timestamp")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "timestamp", valid_594295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594296: Call_ProcessesGet_594286; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified process.
  ## 
  let valid = call_594296.validator(path, query, header, formData, body)
  let scheme = call_594296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594296.url(scheme.get, call_594296.host, call_594296.base,
                         call_594296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594296, url, valid)

proc call*(call_594297: Call_ProcessesGet_594286; resourceGroupName: string;
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
  var path_594298 = newJObject()
  var query_594299 = newJObject()
  add(path_594298, "resourceGroupName", newJString(resourceGroupName))
  add(query_594299, "api-version", newJString(apiVersion))
  add(path_594298, "machineName", newJString(machineName))
  add(path_594298, "subscriptionId", newJString(subscriptionId))
  add(path_594298, "processName", newJString(processName))
  add(query_594299, "timestamp", newJString(timestamp))
  add(path_594298, "workspaceName", newJString(workspaceName))
  result = call_594297.call(path_594298, query_594299, nil, nil, nil)

var processesGet* = Call_ProcessesGet_594286(name: "processesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/processes/{processName}",
    validator: validate_ProcessesGet_594287, base: "", url: url_ProcessesGet_594288,
    schemes: {Scheme.Https})
type
  Call_ProcessesListAcceptingPorts_594300 = ref object of OpenApiRestCall_593437
proc url_ProcessesListAcceptingPorts_594302(protocol: Scheme; host: string;
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

proc validate_ProcessesListAcceptingPorts_594301(path: JsonNode; query: JsonNode;
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
  var valid_594303 = path.getOrDefault("resourceGroupName")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "resourceGroupName", valid_594303
  var valid_594304 = path.getOrDefault("machineName")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "machineName", valid_594304
  var valid_594305 = path.getOrDefault("subscriptionId")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "subscriptionId", valid_594305
  var valid_594306 = path.getOrDefault("processName")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = nil)
  if valid_594306 != nil:
    section.add "processName", valid_594306
  var valid_594307 = path.getOrDefault("workspaceName")
  valid_594307 = validateParameter(valid_594307, JString, required = true,
                                 default = nil)
  if valid_594307 != nil:
    section.add "workspaceName", valid_594307
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
  var valid_594308 = query.getOrDefault("api-version")
  valid_594308 = validateParameter(valid_594308, JString, required = true,
                                 default = nil)
  if valid_594308 != nil:
    section.add "api-version", valid_594308
  var valid_594309 = query.getOrDefault("endTime")
  valid_594309 = validateParameter(valid_594309, JString, required = false,
                                 default = nil)
  if valid_594309 != nil:
    section.add "endTime", valid_594309
  var valid_594310 = query.getOrDefault("startTime")
  valid_594310 = validateParameter(valid_594310, JString, required = false,
                                 default = nil)
  if valid_594310 != nil:
    section.add "startTime", valid_594310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594311: Call_ProcessesListAcceptingPorts_594300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of ports on which this process is accepting
  ## 
  let valid = call_594311.validator(path, query, header, formData, body)
  let scheme = call_594311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594311.url(scheme.get, call_594311.host, call_594311.base,
                         call_594311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594311, url, valid)

proc call*(call_594312: Call_ProcessesListAcceptingPorts_594300;
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
  var path_594313 = newJObject()
  var query_594314 = newJObject()
  add(path_594313, "resourceGroupName", newJString(resourceGroupName))
  add(query_594314, "api-version", newJString(apiVersion))
  add(path_594313, "machineName", newJString(machineName))
  add(path_594313, "subscriptionId", newJString(subscriptionId))
  add(query_594314, "endTime", newJString(endTime))
  add(path_594313, "processName", newJString(processName))
  add(query_594314, "startTime", newJString(startTime))
  add(path_594313, "workspaceName", newJString(workspaceName))
  result = call_594312.call(path_594313, query_594314, nil, nil, nil)

var processesListAcceptingPorts* = Call_ProcessesListAcceptingPorts_594300(
    name: "processesListAcceptingPorts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/processes/{processName}/acceptingPorts",
    validator: validate_ProcessesListAcceptingPorts_594301, base: "",
    url: url_ProcessesListAcceptingPorts_594302, schemes: {Scheme.Https})
type
  Call_ProcessesListConnections_594315 = ref object of OpenApiRestCall_593437
proc url_ProcessesListConnections_594317(protocol: Scheme; host: string;
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

proc validate_ProcessesListConnections_594316(path: JsonNode; query: JsonNode;
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
  var valid_594318 = path.getOrDefault("resourceGroupName")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "resourceGroupName", valid_594318
  var valid_594319 = path.getOrDefault("machineName")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "machineName", valid_594319
  var valid_594320 = path.getOrDefault("subscriptionId")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = nil)
  if valid_594320 != nil:
    section.add "subscriptionId", valid_594320
  var valid_594321 = path.getOrDefault("processName")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "processName", valid_594321
  var valid_594322 = path.getOrDefault("workspaceName")
  valid_594322 = validateParameter(valid_594322, JString, required = true,
                                 default = nil)
  if valid_594322 != nil:
    section.add "workspaceName", valid_594322
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
  var valid_594323 = query.getOrDefault("api-version")
  valid_594323 = validateParameter(valid_594323, JString, required = true,
                                 default = nil)
  if valid_594323 != nil:
    section.add "api-version", valid_594323
  var valid_594324 = query.getOrDefault("endTime")
  valid_594324 = validateParameter(valid_594324, JString, required = false,
                                 default = nil)
  if valid_594324 != nil:
    section.add "endTime", valid_594324
  var valid_594325 = query.getOrDefault("startTime")
  valid_594325 = validateParameter(valid_594325, JString, required = false,
                                 default = nil)
  if valid_594325 != nil:
    section.add "startTime", valid_594325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594326: Call_ProcessesListConnections_594315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of connections terminating or originating at the specified process
  ## 
  let valid = call_594326.validator(path, query, header, formData, body)
  let scheme = call_594326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594326.url(scheme.get, call_594326.host, call_594326.base,
                         call_594326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594326, url, valid)

proc call*(call_594327: Call_ProcessesListConnections_594315;
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
  var path_594328 = newJObject()
  var query_594329 = newJObject()
  add(path_594328, "resourceGroupName", newJString(resourceGroupName))
  add(query_594329, "api-version", newJString(apiVersion))
  add(path_594328, "machineName", newJString(machineName))
  add(path_594328, "subscriptionId", newJString(subscriptionId))
  add(query_594329, "endTime", newJString(endTime))
  add(path_594328, "processName", newJString(processName))
  add(query_594329, "startTime", newJString(startTime))
  add(path_594328, "workspaceName", newJString(workspaceName))
  result = call_594327.call(path_594328, query_594329, nil, nil, nil)

var processesListConnections* = Call_ProcessesListConnections_594315(
    name: "processesListConnections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/processes/{processName}/connections",
    validator: validate_ProcessesListConnections_594316, base: "",
    url: url_ProcessesListConnections_594317, schemes: {Scheme.Https})
type
  Call_ProcessesGetLiveness_594330 = ref object of OpenApiRestCall_593437
proc url_ProcessesGetLiveness_594332(protocol: Scheme; host: string; base: string;
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

proc validate_ProcessesGetLiveness_594331(path: JsonNode; query: JsonNode;
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
  var valid_594333 = path.getOrDefault("resourceGroupName")
  valid_594333 = validateParameter(valid_594333, JString, required = true,
                                 default = nil)
  if valid_594333 != nil:
    section.add "resourceGroupName", valid_594333
  var valid_594334 = path.getOrDefault("machineName")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "machineName", valid_594334
  var valid_594335 = path.getOrDefault("subscriptionId")
  valid_594335 = validateParameter(valid_594335, JString, required = true,
                                 default = nil)
  if valid_594335 != nil:
    section.add "subscriptionId", valid_594335
  var valid_594336 = path.getOrDefault("processName")
  valid_594336 = validateParameter(valid_594336, JString, required = true,
                                 default = nil)
  if valid_594336 != nil:
    section.add "processName", valid_594336
  var valid_594337 = path.getOrDefault("workspaceName")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "workspaceName", valid_594337
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
  var valid_594338 = query.getOrDefault("api-version")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "api-version", valid_594338
  var valid_594339 = query.getOrDefault("endTime")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "endTime", valid_594339
  var valid_594340 = query.getOrDefault("startTime")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = nil)
  if valid_594340 != nil:
    section.add "startTime", valid_594340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594341: Call_ProcessesGetLiveness_594330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Obtains the liveness status of the process during the specified time interval.
  ## 
  let valid = call_594341.validator(path, query, header, formData, body)
  let scheme = call_594341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594341.url(scheme.get, call_594341.host, call_594341.base,
                         call_594341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594341, url, valid)

proc call*(call_594342: Call_ProcessesGetLiveness_594330;
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
  var path_594343 = newJObject()
  var query_594344 = newJObject()
  add(path_594343, "resourceGroupName", newJString(resourceGroupName))
  add(query_594344, "api-version", newJString(apiVersion))
  add(path_594343, "machineName", newJString(machineName))
  add(path_594343, "subscriptionId", newJString(subscriptionId))
  add(query_594344, "endTime", newJString(endTime))
  add(path_594343, "processName", newJString(processName))
  add(query_594344, "startTime", newJString(startTime))
  add(path_594343, "workspaceName", newJString(workspaceName))
  result = call_594342.call(path_594343, query_594344, nil, nil, nil)

var processesGetLiveness* = Call_ProcessesGetLiveness_594330(
    name: "processesGetLiveness", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/machines/{machineName}/processes/{processName}/liveness",
    validator: validate_ProcessesGetLiveness_594331, base: "",
    url: url_ProcessesGetLiveness_594332, schemes: {Scheme.Https})
type
  Call_SummariesGetMachines_594345 = ref object of OpenApiRestCall_593437
proc url_SummariesGetMachines_594347(protocol: Scheme; host: string; base: string;
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

proc validate_SummariesGetMachines_594346(path: JsonNode; query: JsonNode;
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
  var valid_594348 = path.getOrDefault("resourceGroupName")
  valid_594348 = validateParameter(valid_594348, JString, required = true,
                                 default = nil)
  if valid_594348 != nil:
    section.add "resourceGroupName", valid_594348
  var valid_594349 = path.getOrDefault("subscriptionId")
  valid_594349 = validateParameter(valid_594349, JString, required = true,
                                 default = nil)
  if valid_594349 != nil:
    section.add "subscriptionId", valid_594349
  var valid_594350 = path.getOrDefault("workspaceName")
  valid_594350 = validateParameter(valid_594350, JString, required = true,
                                 default = nil)
  if valid_594350 != nil:
    section.add "workspaceName", valid_594350
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
  var valid_594351 = query.getOrDefault("api-version")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "api-version", valid_594351
  var valid_594352 = query.getOrDefault("endTime")
  valid_594352 = validateParameter(valid_594352, JString, required = false,
                                 default = nil)
  if valid_594352 != nil:
    section.add "endTime", valid_594352
  var valid_594353 = query.getOrDefault("startTime")
  valid_594353 = validateParameter(valid_594353, JString, required = false,
                                 default = nil)
  if valid_594353 != nil:
    section.add "startTime", valid_594353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594354: Call_SummariesGetMachines_594345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns summary information about the machines in the workspace.
  ## 
  let valid = call_594354.validator(path, query, header, formData, body)
  let scheme = call_594354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594354.url(scheme.get, call_594354.host, call_594354.base,
                         call_594354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594354, url, valid)

proc call*(call_594355: Call_SummariesGetMachines_594345;
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
  var path_594356 = newJObject()
  var query_594357 = newJObject()
  add(path_594356, "resourceGroupName", newJString(resourceGroupName))
  add(query_594357, "api-version", newJString(apiVersion))
  add(path_594356, "subscriptionId", newJString(subscriptionId))
  add(query_594357, "endTime", newJString(endTime))
  add(query_594357, "startTime", newJString(startTime))
  add(path_594356, "workspaceName", newJString(workspaceName))
  result = call_594355.call(path_594356, query_594357, nil, nil, nil)

var summariesGetMachines* = Call_SummariesGetMachines_594345(
    name: "summariesGetMachines", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/features/serviceMap/summaries/machines",
    validator: validate_SummariesGetMachines_594346, base: "",
    url: url_SummariesGetMachines_594347, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
