
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2015-06-01-preview
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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "security-tasks"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TasksListByHomeRegion_593646 = ref object of OpenApiRestCall_593424
proc url_TasksListByHomeRegion_593648(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksListByHomeRegion_593647(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Recommended tasks that will help improve the security of the subscription proactively
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
  var valid_593809 = path.getOrDefault("ascLocation")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "ascLocation", valid_593809
  var valid_593810 = path.getOrDefault("subscriptionId")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "subscriptionId", valid_593810
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593811 = query.getOrDefault("api-version")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "api-version", valid_593811
  var valid_593812 = query.getOrDefault("$filter")
  valid_593812 = validateParameter(valid_593812, JString, required = false,
                                 default = nil)
  if valid_593812 != nil:
    section.add "$filter", valid_593812
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593839: Call_TasksListByHomeRegion_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_593839.validator(path, query, header, formData, body)
  let scheme = call_593839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593839.url(scheme.get, call_593839.host, call_593839.base,
                         call_593839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593839, url, valid)

proc call*(call_593910: Call_TasksListByHomeRegion_593646; apiVersion: string;
          ascLocation: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## tasksListByHomeRegion
  ## Recommended tasks that will help improve the security of the subscription proactively
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_593911 = newJObject()
  var query_593913 = newJObject()
  add(query_593913, "api-version", newJString(apiVersion))
  add(path_593911, "ascLocation", newJString(ascLocation))
  add(path_593911, "subscriptionId", newJString(subscriptionId))
  add(query_593913, "$filter", newJString(Filter))
  result = call_593910.call(path_593911, query_593913, nil, nil, nil)

var tasksListByHomeRegion* = Call_TasksListByHomeRegion_593646(
    name: "tasksListByHomeRegion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/tasks",
    validator: validate_TasksListByHomeRegion_593647, base: "",
    url: url_TasksListByHomeRegion_593648, schemes: {Scheme.Https})
type
  Call_TasksGetSubscriptionLevelTask_593952 = ref object of OpenApiRestCall_593424
proc url_TasksGetSubscriptionLevelTask_593954(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksGetSubscriptionLevelTask_593953(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   taskName: JString (required)
  ##           : Name of the task object, will be a GUID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_593964 = path.getOrDefault("ascLocation")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "ascLocation", valid_593964
  var valid_593965 = path.getOrDefault("subscriptionId")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "subscriptionId", valid_593965
  var valid_593966 = path.getOrDefault("taskName")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "taskName", valid_593966
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593967 = query.getOrDefault("api-version")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "api-version", valid_593967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593968: Call_TasksGetSubscriptionLevelTask_593952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_593968.validator(path, query, header, formData, body)
  let scheme = call_593968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593968.url(scheme.get, call_593968.host, call_593968.base,
                         call_593968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593968, url, valid)

proc call*(call_593969: Call_TasksGetSubscriptionLevelTask_593952;
          apiVersion: string; ascLocation: string; subscriptionId: string;
          taskName: string): Recallable =
  ## tasksGetSubscriptionLevelTask
  ## Recommended tasks that will help improve the security of the subscription proactively
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   taskName: string (required)
  ##           : Name of the task object, will be a GUID
  var path_593970 = newJObject()
  var query_593971 = newJObject()
  add(query_593971, "api-version", newJString(apiVersion))
  add(path_593970, "ascLocation", newJString(ascLocation))
  add(path_593970, "subscriptionId", newJString(subscriptionId))
  add(path_593970, "taskName", newJString(taskName))
  result = call_593969.call(path_593970, query_593971, nil, nil, nil)

var tasksGetSubscriptionLevelTask* = Call_TasksGetSubscriptionLevelTask_593952(
    name: "tasksGetSubscriptionLevelTask", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/tasks/{taskName}",
    validator: validate_TasksGetSubscriptionLevelTask_593953, base: "",
    url: url_TasksGetSubscriptionLevelTask_593954, schemes: {Scheme.Https})
type
  Call_TasksUpdateSubscriptionLevelTaskState_593972 = ref object of OpenApiRestCall_593424
proc url_TasksUpdateSubscriptionLevelTaskState_593974(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  assert "taskUpdateActionType" in path,
        "`taskUpdateActionType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "taskUpdateActionType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksUpdateSubscriptionLevelTaskState_593973(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ascLocation: JString (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   taskName: JString (required)
  ##           : Name of the task object, will be a GUID
  ##   taskUpdateActionType: JString (required)
  ##                       : Type of the action to do on the task
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ascLocation` field"
  var valid_593975 = path.getOrDefault("ascLocation")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "ascLocation", valid_593975
  var valid_593976 = path.getOrDefault("subscriptionId")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "subscriptionId", valid_593976
  var valid_593977 = path.getOrDefault("taskName")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "taskName", valid_593977
  var valid_593991 = path.getOrDefault("taskUpdateActionType")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = newJString("Activate"))
  if valid_593991 != nil:
    section.add "taskUpdateActionType", valid_593991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593992 = query.getOrDefault("api-version")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "api-version", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_TasksUpdateSubscriptionLevelTaskState_593972;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_TasksUpdateSubscriptionLevelTaskState_593972;
          apiVersion: string; ascLocation: string; subscriptionId: string;
          taskName: string; taskUpdateActionType: string = "Activate"): Recallable =
  ## tasksUpdateSubscriptionLevelTaskState
  ## Recommended tasks that will help improve the security of the subscription proactively
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   taskName: string (required)
  ##           : Name of the task object, will be a GUID
  ##   taskUpdateActionType: string (required)
  ##                       : Type of the action to do on the task
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(query_593996, "api-version", newJString(apiVersion))
  add(path_593995, "ascLocation", newJString(ascLocation))
  add(path_593995, "subscriptionId", newJString(subscriptionId))
  add(path_593995, "taskName", newJString(taskName))
  add(path_593995, "taskUpdateActionType", newJString(taskUpdateActionType))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var tasksUpdateSubscriptionLevelTaskState* = Call_TasksUpdateSubscriptionLevelTaskState_593972(
    name: "tasksUpdateSubscriptionLevelTaskState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/locations/{ascLocation}/tasks/{taskName}/{taskUpdateActionType}",
    validator: validate_TasksUpdateSubscriptionLevelTaskState_593973, base: "",
    url: url_TasksUpdateSubscriptionLevelTaskState_593974, schemes: {Scheme.Https})
type
  Call_TasksList_593997 = ref object of OpenApiRestCall_593424
proc url_TasksList_593999(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksList_593998(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594000 = path.getOrDefault("subscriptionId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "subscriptionId", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "api-version", valid_594001
  var valid_594002 = query.getOrDefault("$filter")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "$filter", valid_594002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594003: Call_TasksList_593997; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_594003.validator(path, query, header, formData, body)
  let scheme = call_594003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594003.url(scheme.get, call_594003.host, call_594003.base,
                         call_594003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594003, url, valid)

proc call*(call_594004: Call_TasksList_593997; apiVersion: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## tasksList
  ## Recommended tasks that will help improve the security of the subscription proactively
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_594005 = newJObject()
  var query_594006 = newJObject()
  add(query_594006, "api-version", newJString(apiVersion))
  add(path_594005, "subscriptionId", newJString(subscriptionId))
  add(query_594006, "$filter", newJString(Filter))
  result = call_594004.call(path_594005, query_594006, nil, nil, nil)

var tasksList* = Call_TasksList_593997(name: "tasksList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/tasks",
                                    validator: validate_TasksList_593998,
                                    base: "", url: url_TasksList_593999,
                                    schemes: {Scheme.Https})
type
  Call_TasksListByResourceGroup_594007 = ref object of OpenApiRestCall_593424
proc url_TasksListByResourceGroup_594009(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksListByResourceGroup_594008(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Recommended tasks that will help improve the security of the subscription proactively
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
  var valid_594010 = path.getOrDefault("resourceGroupName")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "resourceGroupName", valid_594010
  var valid_594011 = path.getOrDefault("ascLocation")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "ascLocation", valid_594011
  var valid_594012 = path.getOrDefault("subscriptionId")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "subscriptionId", valid_594012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594013 = query.getOrDefault("api-version")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "api-version", valid_594013
  var valid_594014 = query.getOrDefault("$filter")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "$filter", valid_594014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_TasksListByResourceGroup_594007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_TasksListByResourceGroup_594007;
          resourceGroupName: string; apiVersion: string; ascLocation: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## tasksListByResourceGroup
  ## Recommended tasks that will help improve the security of the subscription proactively
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  add(path_594017, "resourceGroupName", newJString(resourceGroupName))
  add(query_594018, "api-version", newJString(apiVersion))
  add(path_594017, "ascLocation", newJString(ascLocation))
  add(path_594017, "subscriptionId", newJString(subscriptionId))
  add(query_594018, "$filter", newJString(Filter))
  result = call_594016.call(path_594017, query_594018, nil, nil, nil)

var tasksListByResourceGroup* = Call_TasksListByResourceGroup_594007(
    name: "tasksListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/tasks",
    validator: validate_TasksListByResourceGroup_594008, base: "",
    url: url_TasksListByResourceGroup_594009, schemes: {Scheme.Https})
type
  Call_TasksGetResourceGroupLevelTask_594019 = ref object of OpenApiRestCall_593424
proc url_TasksGetResourceGroupLevelTask_594021(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksGetResourceGroupLevelTask_594020(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Recommended tasks that will help improve the security of the subscription proactively
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
  ##   taskName: JString (required)
  ##           : Name of the task object, will be a GUID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594022 = path.getOrDefault("resourceGroupName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "resourceGroupName", valid_594022
  var valid_594023 = path.getOrDefault("ascLocation")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "ascLocation", valid_594023
  var valid_594024 = path.getOrDefault("subscriptionId")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "subscriptionId", valid_594024
  var valid_594025 = path.getOrDefault("taskName")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "taskName", valid_594025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594026 = query.getOrDefault("api-version")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "api-version", valid_594026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594027: Call_TasksGetResourceGroupLevelTask_594019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_594027.validator(path, query, header, formData, body)
  let scheme = call_594027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594027.url(scheme.get, call_594027.host, call_594027.base,
                         call_594027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594027, url, valid)

proc call*(call_594028: Call_TasksGetResourceGroupLevelTask_594019;
          resourceGroupName: string; apiVersion: string; ascLocation: string;
          subscriptionId: string; taskName: string): Recallable =
  ## tasksGetResourceGroupLevelTask
  ## Recommended tasks that will help improve the security of the subscription proactively
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   taskName: string (required)
  ##           : Name of the task object, will be a GUID
  var path_594029 = newJObject()
  var query_594030 = newJObject()
  add(path_594029, "resourceGroupName", newJString(resourceGroupName))
  add(query_594030, "api-version", newJString(apiVersion))
  add(path_594029, "ascLocation", newJString(ascLocation))
  add(path_594029, "subscriptionId", newJString(subscriptionId))
  add(path_594029, "taskName", newJString(taskName))
  result = call_594028.call(path_594029, query_594030, nil, nil, nil)

var tasksGetResourceGroupLevelTask* = Call_TasksGetResourceGroupLevelTask_594019(
    name: "tasksGetResourceGroupLevelTask", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/tasks/{taskName}",
    validator: validate_TasksGetResourceGroupLevelTask_594020, base: "",
    url: url_TasksGetResourceGroupLevelTask_594021, schemes: {Scheme.Https})
type
  Call_TasksUpdateResourceGroupLevelTaskState_594031 = ref object of OpenApiRestCall_593424
proc url_TasksUpdateResourceGroupLevelTaskState_594033(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ascLocation" in path, "`ascLocation` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  assert "taskUpdateActionType" in path,
        "`taskUpdateActionType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/locations/"),
               (kind: VariableSegment, value: "ascLocation"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "taskUpdateActionType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksUpdateResourceGroupLevelTaskState_594032(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Recommended tasks that will help improve the security of the subscription proactively
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
  ##   taskName: JString (required)
  ##           : Name of the task object, will be a GUID
  ##   taskUpdateActionType: JString (required)
  ##                       : Type of the action to do on the task
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594034 = path.getOrDefault("resourceGroupName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "resourceGroupName", valid_594034
  var valid_594035 = path.getOrDefault("ascLocation")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "ascLocation", valid_594035
  var valid_594036 = path.getOrDefault("subscriptionId")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "subscriptionId", valid_594036
  var valid_594037 = path.getOrDefault("taskName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "taskName", valid_594037
  var valid_594038 = path.getOrDefault("taskUpdateActionType")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = newJString("Activate"))
  if valid_594038 != nil:
    section.add "taskUpdateActionType", valid_594038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594039 = query.getOrDefault("api-version")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "api-version", valid_594039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594040: Call_TasksUpdateResourceGroupLevelTaskState_594031;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Recommended tasks that will help improve the security of the subscription proactively
  ## 
  let valid = call_594040.validator(path, query, header, formData, body)
  let scheme = call_594040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594040.url(scheme.get, call_594040.host, call_594040.base,
                         call_594040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594040, url, valid)

proc call*(call_594041: Call_TasksUpdateResourceGroupLevelTaskState_594031;
          resourceGroupName: string; apiVersion: string; ascLocation: string;
          subscriptionId: string; taskName: string;
          taskUpdateActionType: string = "Activate"): Recallable =
  ## tasksUpdateResourceGroupLevelTaskState
  ## Recommended tasks that will help improve the security of the subscription proactively
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   ascLocation: string (required)
  ##              : The location where ASC stores the data of the subscription. can be retrieved from Get locations
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   taskName: string (required)
  ##           : Name of the task object, will be a GUID
  ##   taskUpdateActionType: string (required)
  ##                       : Type of the action to do on the task
  var path_594042 = newJObject()
  var query_594043 = newJObject()
  add(path_594042, "resourceGroupName", newJString(resourceGroupName))
  add(query_594043, "api-version", newJString(apiVersion))
  add(path_594042, "ascLocation", newJString(ascLocation))
  add(path_594042, "subscriptionId", newJString(subscriptionId))
  add(path_594042, "taskName", newJString(taskName))
  add(path_594042, "taskUpdateActionType", newJString(taskUpdateActionType))
  result = call_594041.call(path_594042, query_594043, nil, nil, nil)

var tasksUpdateResourceGroupLevelTaskState* = Call_TasksUpdateResourceGroupLevelTaskState_594031(
    name: "tasksUpdateResourceGroupLevelTaskState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/locations/{ascLocation}/tasks/{taskName}/{taskUpdateActionType}",
    validator: validate_TasksUpdateResourceGroupLevelTaskState_594032, base: "",
    url: url_TasksUpdateResourceGroupLevelTaskState_594033,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
