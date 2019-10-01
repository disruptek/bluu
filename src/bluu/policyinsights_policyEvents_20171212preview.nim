
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: PolicyEventsClient
## version: 2017-12-12-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "policyinsights-policyEvents"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicyEventsListQueryResultsForManagementGroup_567880 = ref object of OpenApiRestCall_567658
proc url_PolicyEventsListQueryResultsForManagementGroup_567882(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupsNamespace" in path,
        "`managementGroupsNamespace` is a required path parameter"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "policyEventsResource" in path,
        "`policyEventsResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "managementGroupsNamespace"),
               (kind: ConstantSegment, value: "/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyEvents/"),
               (kind: VariableSegment, value: "policyEventsResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyEventsListQueryResultsForManagementGroup_567881(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy events for the resources under the management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupName: JString (required)
  ##                      : Management group name.
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   policyEventsResource: JString (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupName` field"
  var valid_568056 = path.getOrDefault("managementGroupName")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "managementGroupName", valid_568056
  var valid_568070 = path.getOrDefault("managementGroupsNamespace")
  valid_568070 = validateParameter(valid_568070, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_568070 != nil:
    section.add "managementGroupsNamespace", valid_568070
  var valid_568071 = path.getOrDefault("policyEventsResource")
  valid_568071 = validateParameter(valid_568071, JString, required = true,
                                 default = newJString("default"))
  if valid_568071 != nil:
    section.add "policyEventsResource", valid_568071
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_568072 = query.getOrDefault("$orderby")
  valid_568072 = validateParameter(valid_568072, JString, required = false,
                                 default = nil)
  if valid_568072 != nil:
    section.add "$orderby", valid_568072
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568073 = query.getOrDefault("api-version")
  valid_568073 = validateParameter(valid_568073, JString, required = true,
                                 default = nil)
  if valid_568073 != nil:
    section.add "api-version", valid_568073
  var valid_568074 = query.getOrDefault("$from")
  valid_568074 = validateParameter(valid_568074, JString, required = false,
                                 default = nil)
  if valid_568074 != nil:
    section.add "$from", valid_568074
  var valid_568075 = query.getOrDefault("$top")
  valid_568075 = validateParameter(valid_568075, JInt, required = false, default = nil)
  if valid_568075 != nil:
    section.add "$top", valid_568075
  var valid_568076 = query.getOrDefault("$select")
  valid_568076 = validateParameter(valid_568076, JString, required = false,
                                 default = nil)
  if valid_568076 != nil:
    section.add "$select", valid_568076
  var valid_568077 = query.getOrDefault("$to")
  valid_568077 = validateParameter(valid_568077, JString, required = false,
                                 default = nil)
  if valid_568077 != nil:
    section.add "$to", valid_568077
  var valid_568078 = query.getOrDefault("$apply")
  valid_568078 = validateParameter(valid_568078, JString, required = false,
                                 default = nil)
  if valid_568078 != nil:
    section.add "$apply", valid_568078
  var valid_568079 = query.getOrDefault("$filter")
  valid_568079 = validateParameter(valid_568079, JString, required = false,
                                 default = nil)
  if valid_568079 != nil:
    section.add "$filter", valid_568079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568102: Call_PolicyEventsListQueryResultsForManagementGroup_567880;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resources under the management group.
  ## 
  let valid = call_568102.validator(path, query, header, formData, body)
  let scheme = call_568102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568102.url(scheme.get, call_568102.host, call_568102.base,
                         call_568102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568102, url, valid)

proc call*(call_568173: Call_PolicyEventsListQueryResultsForManagementGroup_567880;
          managementGroupName: string; apiVersion: string;
          managementGroupsNamespace: string = "Microsoft.Management";
          Orderby: string = ""; From: string = "";
          policyEventsResource: string = "default"; Top: int = 0; Select: string = "";
          To: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## policyEventsListQueryResultsForManagementGroup
  ## Queries policy events for the resources under the management group.
  ##   managementGroupName: string (required)
  ##                      : Management group name.
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   policyEventsResource: string (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568174 = newJObject()
  var query_568176 = newJObject()
  add(path_568174, "managementGroupName", newJString(managementGroupName))
  add(path_568174, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_568176, "$orderby", newJString(Orderby))
  add(query_568176, "api-version", newJString(apiVersion))
  add(query_568176, "$from", newJString(From))
  add(path_568174, "policyEventsResource", newJString(policyEventsResource))
  add(query_568176, "$top", newJInt(Top))
  add(query_568176, "$select", newJString(Select))
  add(query_568176, "$to", newJString(To))
  add(query_568176, "$apply", newJString(Apply))
  add(query_568176, "$filter", newJString(Filter))
  result = call_568173.call(path_568174, query_568176, nil, nil, nil)

var policyEventsListQueryResultsForManagementGroup* = Call_PolicyEventsListQueryResultsForManagementGroup_567880(
    name: "policyEventsListQueryResultsForManagementGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForManagementGroup_567881,
    base: "", url: url_PolicyEventsListQueryResultsForManagementGroup_567882,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForSubscription_568215 = ref object of OpenApiRestCall_567658
proc url_PolicyEventsListQueryResultsForSubscription_568217(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "policyEventsResource" in path,
        "`policyEventsResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyEvents/"),
               (kind: VariableSegment, value: "policyEventsResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyEventsListQueryResultsForSubscription_568216(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queries policy events for the resources under the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyEventsResource: JString (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyEventsResource` field"
  var valid_568218 = path.getOrDefault("policyEventsResource")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = newJString("default"))
  if valid_568218 != nil:
    section.add "policyEventsResource", valid_568218
  var valid_568219 = path.getOrDefault("subscriptionId")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "subscriptionId", valid_568219
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_568220 = query.getOrDefault("$orderby")
  valid_568220 = validateParameter(valid_568220, JString, required = false,
                                 default = nil)
  if valid_568220 != nil:
    section.add "$orderby", valid_568220
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568221 = query.getOrDefault("api-version")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "api-version", valid_568221
  var valid_568222 = query.getOrDefault("$from")
  valid_568222 = validateParameter(valid_568222, JString, required = false,
                                 default = nil)
  if valid_568222 != nil:
    section.add "$from", valid_568222
  var valid_568223 = query.getOrDefault("$top")
  valid_568223 = validateParameter(valid_568223, JInt, required = false, default = nil)
  if valid_568223 != nil:
    section.add "$top", valid_568223
  var valid_568224 = query.getOrDefault("$select")
  valid_568224 = validateParameter(valid_568224, JString, required = false,
                                 default = nil)
  if valid_568224 != nil:
    section.add "$select", valid_568224
  var valid_568225 = query.getOrDefault("$to")
  valid_568225 = validateParameter(valid_568225, JString, required = false,
                                 default = nil)
  if valid_568225 != nil:
    section.add "$to", valid_568225
  var valid_568226 = query.getOrDefault("$apply")
  valid_568226 = validateParameter(valid_568226, JString, required = false,
                                 default = nil)
  if valid_568226 != nil:
    section.add "$apply", valid_568226
  var valid_568227 = query.getOrDefault("$filter")
  valid_568227 = validateParameter(valid_568227, JString, required = false,
                                 default = nil)
  if valid_568227 != nil:
    section.add "$filter", valid_568227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568228: Call_PolicyEventsListQueryResultsForSubscription_568215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resources under the subscription.
  ## 
  let valid = call_568228.validator(path, query, header, formData, body)
  let scheme = call_568228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568228.url(scheme.get, call_568228.host, call_568228.base,
                         call_568228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568228, url, valid)

proc call*(call_568229: Call_PolicyEventsListQueryResultsForSubscription_568215;
          apiVersion: string; subscriptionId: string; Orderby: string = "";
          From: string = ""; policyEventsResource: string = "default"; Top: int = 0;
          Select: string = ""; To: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## policyEventsListQueryResultsForSubscription
  ## Queries policy events for the resources under the subscription.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   policyEventsResource: string (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568230 = newJObject()
  var query_568231 = newJObject()
  add(query_568231, "$orderby", newJString(Orderby))
  add(query_568231, "api-version", newJString(apiVersion))
  add(query_568231, "$from", newJString(From))
  add(path_568230, "policyEventsResource", newJString(policyEventsResource))
  add(path_568230, "subscriptionId", newJString(subscriptionId))
  add(query_568231, "$top", newJInt(Top))
  add(query_568231, "$select", newJString(Select))
  add(query_568231, "$to", newJString(To))
  add(query_568231, "$apply", newJString(Apply))
  add(query_568231, "$filter", newJString(Filter))
  result = call_568229.call(path_568230, query_568231, nil, nil, nil)

var policyEventsListQueryResultsForSubscription* = Call_PolicyEventsListQueryResultsForSubscription_568215(
    name: "policyEventsListQueryResultsForSubscription",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForSubscription_568216,
    base: "", url: url_PolicyEventsListQueryResultsForSubscription_568217,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_568232 = ref object of OpenApiRestCall_567658
proc url_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_568234(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "authorizationNamespace" in path,
        "`authorizationNamespace` is a required path parameter"
  assert "policyAssignmentName" in path,
        "`policyAssignmentName` is a required path parameter"
  assert "policyEventsResource" in path,
        "`policyEventsResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "authorizationNamespace"),
               (kind: ConstantSegment, value: "/policyAssignments/"),
               (kind: VariableSegment, value: "policyAssignmentName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyEvents/"),
               (kind: VariableSegment, value: "policyEventsResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_568233(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy events for the subscription level policy assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   policyEventsResource: JString (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policyAssignmentName: JString (required)
  ##                       : Policy assignment name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationNamespace` field"
  var valid_568235 = path.getOrDefault("authorizationNamespace")
  valid_568235 = validateParameter(valid_568235, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_568235 != nil:
    section.add "authorizationNamespace", valid_568235
  var valid_568236 = path.getOrDefault("policyEventsResource")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = newJString("default"))
  if valid_568236 != nil:
    section.add "policyEventsResource", valid_568236
  var valid_568237 = path.getOrDefault("subscriptionId")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "subscriptionId", valid_568237
  var valid_568238 = path.getOrDefault("policyAssignmentName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "policyAssignmentName", valid_568238
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_568239 = query.getOrDefault("$orderby")
  valid_568239 = validateParameter(valid_568239, JString, required = false,
                                 default = nil)
  if valid_568239 != nil:
    section.add "$orderby", valid_568239
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568240 = query.getOrDefault("api-version")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "api-version", valid_568240
  var valid_568241 = query.getOrDefault("$from")
  valid_568241 = validateParameter(valid_568241, JString, required = false,
                                 default = nil)
  if valid_568241 != nil:
    section.add "$from", valid_568241
  var valid_568242 = query.getOrDefault("$top")
  valid_568242 = validateParameter(valid_568242, JInt, required = false, default = nil)
  if valid_568242 != nil:
    section.add "$top", valid_568242
  var valid_568243 = query.getOrDefault("$select")
  valid_568243 = validateParameter(valid_568243, JString, required = false,
                                 default = nil)
  if valid_568243 != nil:
    section.add "$select", valid_568243
  var valid_568244 = query.getOrDefault("$to")
  valid_568244 = validateParameter(valid_568244, JString, required = false,
                                 default = nil)
  if valid_568244 != nil:
    section.add "$to", valid_568244
  var valid_568245 = query.getOrDefault("$apply")
  valid_568245 = validateParameter(valid_568245, JString, required = false,
                                 default = nil)
  if valid_568245 != nil:
    section.add "$apply", valid_568245
  var valid_568246 = query.getOrDefault("$filter")
  valid_568246 = validateParameter(valid_568246, JString, required = false,
                                 default = nil)
  if valid_568246 != nil:
    section.add "$filter", valid_568246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568247: Call_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_568232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the subscription level policy assignment.
  ## 
  let valid = call_568247.validator(path, query, header, formData, body)
  let scheme = call_568247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568247.url(scheme.get, call_568247.host, call_568247.base,
                         call_568247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568247, url, valid)

proc call*(call_568248: Call_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_568232;
          apiVersion: string; subscriptionId: string; policyAssignmentName: string;
          Orderby: string = "";
          authorizationNamespace: string = "Microsoft.Authorization";
          From: string = ""; policyEventsResource: string = "default"; Top: int = 0;
          Select: string = ""; To: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## policyEventsListQueryResultsForSubscriptionLevelPolicyAssignment
  ## Queries policy events for the subscription level policy assignment.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   policyEventsResource: string (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568249 = newJObject()
  var query_568250 = newJObject()
  add(query_568250, "$orderby", newJString(Orderby))
  add(path_568249, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_568250, "api-version", newJString(apiVersion))
  add(query_568250, "$from", newJString(From))
  add(path_568249, "policyEventsResource", newJString(policyEventsResource))
  add(path_568249, "subscriptionId", newJString(subscriptionId))
  add(query_568250, "$top", newJInt(Top))
  add(query_568250, "$select", newJString(Select))
  add(path_568249, "policyAssignmentName", newJString(policyAssignmentName))
  add(query_568250, "$to", newJString(To))
  add(query_568250, "$apply", newJString(Apply))
  add(query_568250, "$filter", newJString(Filter))
  result = call_568248.call(path_568249, query_568250, nil, nil, nil)

var policyEventsListQueryResultsForSubscriptionLevelPolicyAssignment* = Call_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_568232(
    name: "policyEventsListQueryResultsForSubscriptionLevelPolicyAssignment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policyAssignments/{policyAssignmentName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults", validator: validate_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_568233,
    base: "",
    url: url_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_568234,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForPolicyDefinition_568251 = ref object of OpenApiRestCall_567658
proc url_PolicyEventsListQueryResultsForPolicyDefinition_568253(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "authorizationNamespace" in path,
        "`authorizationNamespace` is a required path parameter"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  assert "policyEventsResource" in path,
        "`policyEventsResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "authorizationNamespace"),
               (kind: ConstantSegment, value: "/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyEvents/"),
               (kind: VariableSegment, value: "policyEventsResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyEventsListQueryResultsForPolicyDefinition_568252(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy events for the subscription level policy definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   policyEventsResource: JString (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policyDefinitionName: JString (required)
  ##                       : Policy definition name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationNamespace` field"
  var valid_568254 = path.getOrDefault("authorizationNamespace")
  valid_568254 = validateParameter(valid_568254, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_568254 != nil:
    section.add "authorizationNamespace", valid_568254
  var valid_568255 = path.getOrDefault("policyEventsResource")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = newJString("default"))
  if valid_568255 != nil:
    section.add "policyEventsResource", valid_568255
  var valid_568256 = path.getOrDefault("subscriptionId")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "subscriptionId", valid_568256
  var valid_568257 = path.getOrDefault("policyDefinitionName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "policyDefinitionName", valid_568257
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_568258 = query.getOrDefault("$orderby")
  valid_568258 = validateParameter(valid_568258, JString, required = false,
                                 default = nil)
  if valid_568258 != nil:
    section.add "$orderby", valid_568258
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568259 = query.getOrDefault("api-version")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "api-version", valid_568259
  var valid_568260 = query.getOrDefault("$from")
  valid_568260 = validateParameter(valid_568260, JString, required = false,
                                 default = nil)
  if valid_568260 != nil:
    section.add "$from", valid_568260
  var valid_568261 = query.getOrDefault("$top")
  valid_568261 = validateParameter(valid_568261, JInt, required = false, default = nil)
  if valid_568261 != nil:
    section.add "$top", valid_568261
  var valid_568262 = query.getOrDefault("$select")
  valid_568262 = validateParameter(valid_568262, JString, required = false,
                                 default = nil)
  if valid_568262 != nil:
    section.add "$select", valid_568262
  var valid_568263 = query.getOrDefault("$to")
  valid_568263 = validateParameter(valid_568263, JString, required = false,
                                 default = nil)
  if valid_568263 != nil:
    section.add "$to", valid_568263
  var valid_568264 = query.getOrDefault("$apply")
  valid_568264 = validateParameter(valid_568264, JString, required = false,
                                 default = nil)
  if valid_568264 != nil:
    section.add "$apply", valid_568264
  var valid_568265 = query.getOrDefault("$filter")
  valid_568265 = validateParameter(valid_568265, JString, required = false,
                                 default = nil)
  if valid_568265 != nil:
    section.add "$filter", valid_568265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568266: Call_PolicyEventsListQueryResultsForPolicyDefinition_568251;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the subscription level policy definition.
  ## 
  let valid = call_568266.validator(path, query, header, formData, body)
  let scheme = call_568266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568266.url(scheme.get, call_568266.host, call_568266.base,
                         call_568266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568266, url, valid)

proc call*(call_568267: Call_PolicyEventsListQueryResultsForPolicyDefinition_568251;
          apiVersion: string; subscriptionId: string; policyDefinitionName: string;
          Orderby: string = "";
          authorizationNamespace: string = "Microsoft.Authorization";
          From: string = ""; policyEventsResource: string = "default"; Top: int = 0;
          Select: string = ""; To: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## policyEventsListQueryResultsForPolicyDefinition
  ## Queries policy events for the subscription level policy definition.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   policyEventsResource: string (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   policyDefinitionName: string (required)
  ##                       : Policy definition name.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568268 = newJObject()
  var query_568269 = newJObject()
  add(query_568269, "$orderby", newJString(Orderby))
  add(path_568268, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_568269, "api-version", newJString(apiVersion))
  add(query_568269, "$from", newJString(From))
  add(path_568268, "policyEventsResource", newJString(policyEventsResource))
  add(path_568268, "subscriptionId", newJString(subscriptionId))
  add(query_568269, "$top", newJInt(Top))
  add(query_568269, "$select", newJString(Select))
  add(query_568269, "$to", newJString(To))
  add(query_568269, "$apply", newJString(Apply))
  add(path_568268, "policyDefinitionName", newJString(policyDefinitionName))
  add(query_568269, "$filter", newJString(Filter))
  result = call_568267.call(path_568268, query_568269, nil, nil, nil)

var policyEventsListQueryResultsForPolicyDefinition* = Call_PolicyEventsListQueryResultsForPolicyDefinition_568251(
    name: "policyEventsListQueryResultsForPolicyDefinition",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policyDefinitions/{policyDefinitionName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForPolicyDefinition_568252,
    base: "", url: url_PolicyEventsListQueryResultsForPolicyDefinition_568253,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForPolicySetDefinition_568270 = ref object of OpenApiRestCall_567658
proc url_PolicyEventsListQueryResultsForPolicySetDefinition_568272(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "authorizationNamespace" in path,
        "`authorizationNamespace` is a required path parameter"
  assert "policySetDefinitionName" in path,
        "`policySetDefinitionName` is a required path parameter"
  assert "policyEventsResource" in path,
        "`policyEventsResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "authorizationNamespace"),
               (kind: ConstantSegment, value: "/policySetDefinitions/"),
               (kind: VariableSegment, value: "policySetDefinitionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyEvents/"),
               (kind: VariableSegment, value: "policyEventsResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyEventsListQueryResultsForPolicySetDefinition_568271(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy events for the subscription level policy set definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policySetDefinitionName: JString (required)
  ##                          : Policy set definition name.
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   policyEventsResource: JString (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policySetDefinitionName` field"
  var valid_568273 = path.getOrDefault("policySetDefinitionName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "policySetDefinitionName", valid_568273
  var valid_568274 = path.getOrDefault("authorizationNamespace")
  valid_568274 = validateParameter(valid_568274, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_568274 != nil:
    section.add "authorizationNamespace", valid_568274
  var valid_568275 = path.getOrDefault("policyEventsResource")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = newJString("default"))
  if valid_568275 != nil:
    section.add "policyEventsResource", valid_568275
  var valid_568276 = path.getOrDefault("subscriptionId")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "subscriptionId", valid_568276
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_568277 = query.getOrDefault("$orderby")
  valid_568277 = validateParameter(valid_568277, JString, required = false,
                                 default = nil)
  if valid_568277 != nil:
    section.add "$orderby", valid_568277
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568278 = query.getOrDefault("api-version")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "api-version", valid_568278
  var valid_568279 = query.getOrDefault("$from")
  valid_568279 = validateParameter(valid_568279, JString, required = false,
                                 default = nil)
  if valid_568279 != nil:
    section.add "$from", valid_568279
  var valid_568280 = query.getOrDefault("$top")
  valid_568280 = validateParameter(valid_568280, JInt, required = false, default = nil)
  if valid_568280 != nil:
    section.add "$top", valid_568280
  var valid_568281 = query.getOrDefault("$select")
  valid_568281 = validateParameter(valid_568281, JString, required = false,
                                 default = nil)
  if valid_568281 != nil:
    section.add "$select", valid_568281
  var valid_568282 = query.getOrDefault("$to")
  valid_568282 = validateParameter(valid_568282, JString, required = false,
                                 default = nil)
  if valid_568282 != nil:
    section.add "$to", valid_568282
  var valid_568283 = query.getOrDefault("$apply")
  valid_568283 = validateParameter(valid_568283, JString, required = false,
                                 default = nil)
  if valid_568283 != nil:
    section.add "$apply", valid_568283
  var valid_568284 = query.getOrDefault("$filter")
  valid_568284 = validateParameter(valid_568284, JString, required = false,
                                 default = nil)
  if valid_568284 != nil:
    section.add "$filter", valid_568284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568285: Call_PolicyEventsListQueryResultsForPolicySetDefinition_568270;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the subscription level policy set definition.
  ## 
  let valid = call_568285.validator(path, query, header, formData, body)
  let scheme = call_568285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568285.url(scheme.get, call_568285.host, call_568285.base,
                         call_568285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568285, url, valid)

proc call*(call_568286: Call_PolicyEventsListQueryResultsForPolicySetDefinition_568270;
          policySetDefinitionName: string; apiVersion: string;
          subscriptionId: string; Orderby: string = "";
          authorizationNamespace: string = "Microsoft.Authorization";
          From: string = ""; policyEventsResource: string = "default"; Top: int = 0;
          Select: string = ""; To: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## policyEventsListQueryResultsForPolicySetDefinition
  ## Queries policy events for the subscription level policy set definition.
  ##   policySetDefinitionName: string (required)
  ##                          : Policy set definition name.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   policyEventsResource: string (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568287 = newJObject()
  var query_568288 = newJObject()
  add(path_568287, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_568288, "$orderby", newJString(Orderby))
  add(path_568287, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_568288, "api-version", newJString(apiVersion))
  add(query_568288, "$from", newJString(From))
  add(path_568287, "policyEventsResource", newJString(policyEventsResource))
  add(path_568287, "subscriptionId", newJString(subscriptionId))
  add(query_568288, "$top", newJInt(Top))
  add(query_568288, "$select", newJString(Select))
  add(query_568288, "$to", newJString(To))
  add(query_568288, "$apply", newJString(Apply))
  add(query_568288, "$filter", newJString(Filter))
  result = call_568286.call(path_568287, query_568288, nil, nil, nil)

var policyEventsListQueryResultsForPolicySetDefinition* = Call_PolicyEventsListQueryResultsForPolicySetDefinition_568270(
    name: "policyEventsListQueryResultsForPolicySetDefinition",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policySetDefinitions/{policySetDefinitionName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForPolicySetDefinition_568271,
    base: "", url: url_PolicyEventsListQueryResultsForPolicySetDefinition_568272,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForResourceGroup_568289 = ref object of OpenApiRestCall_567658
proc url_PolicyEventsListQueryResultsForResourceGroup_568291(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "policyEventsResource" in path,
        "`policyEventsResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyEvents/"),
               (kind: VariableSegment, value: "policyEventsResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyEventsListQueryResultsForResourceGroup_568290(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queries policy events for the resources under the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   policyEventsResource: JString (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568292 = path.getOrDefault("resourceGroupName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "resourceGroupName", valid_568292
  var valid_568293 = path.getOrDefault("policyEventsResource")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = newJString("default"))
  if valid_568293 != nil:
    section.add "policyEventsResource", valid_568293
  var valid_568294 = path.getOrDefault("subscriptionId")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "subscriptionId", valid_568294
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_568295 = query.getOrDefault("$orderby")
  valid_568295 = validateParameter(valid_568295, JString, required = false,
                                 default = nil)
  if valid_568295 != nil:
    section.add "$orderby", valid_568295
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568296 = query.getOrDefault("api-version")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "api-version", valid_568296
  var valid_568297 = query.getOrDefault("$from")
  valid_568297 = validateParameter(valid_568297, JString, required = false,
                                 default = nil)
  if valid_568297 != nil:
    section.add "$from", valid_568297
  var valid_568298 = query.getOrDefault("$top")
  valid_568298 = validateParameter(valid_568298, JInt, required = false, default = nil)
  if valid_568298 != nil:
    section.add "$top", valid_568298
  var valid_568299 = query.getOrDefault("$select")
  valid_568299 = validateParameter(valid_568299, JString, required = false,
                                 default = nil)
  if valid_568299 != nil:
    section.add "$select", valid_568299
  var valid_568300 = query.getOrDefault("$to")
  valid_568300 = validateParameter(valid_568300, JString, required = false,
                                 default = nil)
  if valid_568300 != nil:
    section.add "$to", valid_568300
  var valid_568301 = query.getOrDefault("$apply")
  valid_568301 = validateParameter(valid_568301, JString, required = false,
                                 default = nil)
  if valid_568301 != nil:
    section.add "$apply", valid_568301
  var valid_568302 = query.getOrDefault("$filter")
  valid_568302 = validateParameter(valid_568302, JString, required = false,
                                 default = nil)
  if valid_568302 != nil:
    section.add "$filter", valid_568302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568303: Call_PolicyEventsListQueryResultsForResourceGroup_568289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resources under the resource group.
  ## 
  let valid = call_568303.validator(path, query, header, formData, body)
  let scheme = call_568303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568303.url(scheme.get, call_568303.host, call_568303.base,
                         call_568303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568303, url, valid)

proc call*(call_568304: Call_PolicyEventsListQueryResultsForResourceGroup_568289;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Orderby: string = ""; From: string = "";
          policyEventsResource: string = "default"; Top: int = 0; Select: string = "";
          To: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## policyEventsListQueryResultsForResourceGroup
  ## Queries policy events for the resources under the resource group.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   policyEventsResource: string (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568305 = newJObject()
  var query_568306 = newJObject()
  add(query_568306, "$orderby", newJString(Orderby))
  add(path_568305, "resourceGroupName", newJString(resourceGroupName))
  add(query_568306, "api-version", newJString(apiVersion))
  add(query_568306, "$from", newJString(From))
  add(path_568305, "policyEventsResource", newJString(policyEventsResource))
  add(path_568305, "subscriptionId", newJString(subscriptionId))
  add(query_568306, "$top", newJInt(Top))
  add(query_568306, "$select", newJString(Select))
  add(query_568306, "$to", newJString(To))
  add(query_568306, "$apply", newJString(Apply))
  add(query_568306, "$filter", newJString(Filter))
  result = call_568304.call(path_568305, query_568306, nil, nil, nil)

var policyEventsListQueryResultsForResourceGroup* = Call_PolicyEventsListQueryResultsForResourceGroup_568289(
    name: "policyEventsListQueryResultsForResourceGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForResourceGroup_568290,
    base: "", url: url_PolicyEventsListQueryResultsForResourceGroup_568291,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_568307 = ref object of OpenApiRestCall_567658
proc url_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_568309(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "authorizationNamespace" in path,
        "`authorizationNamespace` is a required path parameter"
  assert "policyAssignmentName" in path,
        "`policyAssignmentName` is a required path parameter"
  assert "policyEventsResource" in path,
        "`policyEventsResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "authorizationNamespace"),
               (kind: ConstantSegment, value: "/policyAssignments/"),
               (kind: VariableSegment, value: "policyAssignmentName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyEvents/"),
               (kind: VariableSegment, value: "policyEventsResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_568308(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy events for the resource group level policy assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   policyEventsResource: JString (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policyAssignmentName: JString (required)
  ##                       : Policy assignment name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568310 = path.getOrDefault("resourceGroupName")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "resourceGroupName", valid_568310
  var valid_568311 = path.getOrDefault("authorizationNamespace")
  valid_568311 = validateParameter(valid_568311, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_568311 != nil:
    section.add "authorizationNamespace", valid_568311
  var valid_568312 = path.getOrDefault("policyEventsResource")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = newJString("default"))
  if valid_568312 != nil:
    section.add "policyEventsResource", valid_568312
  var valid_568313 = path.getOrDefault("subscriptionId")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "subscriptionId", valid_568313
  var valid_568314 = path.getOrDefault("policyAssignmentName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "policyAssignmentName", valid_568314
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_568315 = query.getOrDefault("$orderby")
  valid_568315 = validateParameter(valid_568315, JString, required = false,
                                 default = nil)
  if valid_568315 != nil:
    section.add "$orderby", valid_568315
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568316 = query.getOrDefault("api-version")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "api-version", valid_568316
  var valid_568317 = query.getOrDefault("$from")
  valid_568317 = validateParameter(valid_568317, JString, required = false,
                                 default = nil)
  if valid_568317 != nil:
    section.add "$from", valid_568317
  var valid_568318 = query.getOrDefault("$top")
  valid_568318 = validateParameter(valid_568318, JInt, required = false, default = nil)
  if valid_568318 != nil:
    section.add "$top", valid_568318
  var valid_568319 = query.getOrDefault("$select")
  valid_568319 = validateParameter(valid_568319, JString, required = false,
                                 default = nil)
  if valid_568319 != nil:
    section.add "$select", valid_568319
  var valid_568320 = query.getOrDefault("$to")
  valid_568320 = validateParameter(valid_568320, JString, required = false,
                                 default = nil)
  if valid_568320 != nil:
    section.add "$to", valid_568320
  var valid_568321 = query.getOrDefault("$apply")
  valid_568321 = validateParameter(valid_568321, JString, required = false,
                                 default = nil)
  if valid_568321 != nil:
    section.add "$apply", valid_568321
  var valid_568322 = query.getOrDefault("$filter")
  valid_568322 = validateParameter(valid_568322, JString, required = false,
                                 default = nil)
  if valid_568322 != nil:
    section.add "$filter", valid_568322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568323: Call_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_568307;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resource group level policy assignment.
  ## 
  let valid = call_568323.validator(path, query, header, formData, body)
  let scheme = call_568323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568323.url(scheme.get, call_568323.host, call_568323.base,
                         call_568323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568323, url, valid)

proc call*(call_568324: Call_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_568307;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyAssignmentName: string; Orderby: string = "";
          authorizationNamespace: string = "Microsoft.Authorization";
          From: string = ""; policyEventsResource: string = "default"; Top: int = 0;
          Select: string = ""; To: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## policyEventsListQueryResultsForResourceGroupLevelPolicyAssignment
  ## Queries policy events for the resource group level policy assignment.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   policyEventsResource: string (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568325 = newJObject()
  var query_568326 = newJObject()
  add(query_568326, "$orderby", newJString(Orderby))
  add(path_568325, "resourceGroupName", newJString(resourceGroupName))
  add(path_568325, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_568326, "api-version", newJString(apiVersion))
  add(query_568326, "$from", newJString(From))
  add(path_568325, "policyEventsResource", newJString(policyEventsResource))
  add(path_568325, "subscriptionId", newJString(subscriptionId))
  add(query_568326, "$top", newJInt(Top))
  add(query_568326, "$select", newJString(Select))
  add(path_568325, "policyAssignmentName", newJString(policyAssignmentName))
  add(query_568326, "$to", newJString(To))
  add(query_568326, "$apply", newJString(Apply))
  add(query_568326, "$filter", newJString(Filter))
  result = call_568324.call(path_568325, query_568326, nil, nil, nil)

var policyEventsListQueryResultsForResourceGroupLevelPolicyAssignment* = Call_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_568307(
    name: "policyEventsListQueryResultsForResourceGroupLevelPolicyAssignment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{authorizationNamespace}/policyAssignments/{policyAssignmentName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults", validator: validate_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_568308,
    base: "",
    url: url_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_568309,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForResource_568327 = ref object of OpenApiRestCall_567658
proc url_PolicyEventsListQueryResultsForResource_568329(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "policyEventsResource" in path,
        "`policyEventsResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyEvents/"),
               (kind: VariableSegment, value: "policyEventsResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyEventsListQueryResultsForResource_568328(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queries policy events for the resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyEventsResource: JString (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   resourceId: JString (required)
  ##             : Resource ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyEventsResource` field"
  var valid_568330 = path.getOrDefault("policyEventsResource")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = newJString("default"))
  if valid_568330 != nil:
    section.add "policyEventsResource", valid_568330
  var valid_568331 = path.getOrDefault("resourceId")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "resourceId", valid_568331
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_568332 = query.getOrDefault("$orderby")
  valid_568332 = validateParameter(valid_568332, JString, required = false,
                                 default = nil)
  if valid_568332 != nil:
    section.add "$orderby", valid_568332
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568333 = query.getOrDefault("api-version")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "api-version", valid_568333
  var valid_568334 = query.getOrDefault("$from")
  valid_568334 = validateParameter(valid_568334, JString, required = false,
                                 default = nil)
  if valid_568334 != nil:
    section.add "$from", valid_568334
  var valid_568335 = query.getOrDefault("$top")
  valid_568335 = validateParameter(valid_568335, JInt, required = false, default = nil)
  if valid_568335 != nil:
    section.add "$top", valid_568335
  var valid_568336 = query.getOrDefault("$select")
  valid_568336 = validateParameter(valid_568336, JString, required = false,
                                 default = nil)
  if valid_568336 != nil:
    section.add "$select", valid_568336
  var valid_568337 = query.getOrDefault("$to")
  valid_568337 = validateParameter(valid_568337, JString, required = false,
                                 default = nil)
  if valid_568337 != nil:
    section.add "$to", valid_568337
  var valid_568338 = query.getOrDefault("$apply")
  valid_568338 = validateParameter(valid_568338, JString, required = false,
                                 default = nil)
  if valid_568338 != nil:
    section.add "$apply", valid_568338
  var valid_568339 = query.getOrDefault("$filter")
  valid_568339 = validateParameter(valid_568339, JString, required = false,
                                 default = nil)
  if valid_568339 != nil:
    section.add "$filter", valid_568339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568340: Call_PolicyEventsListQueryResultsForResource_568327;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resource.
  ## 
  let valid = call_568340.validator(path, query, header, formData, body)
  let scheme = call_568340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568340.url(scheme.get, call_568340.host, call_568340.base,
                         call_568340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568340, url, valid)

proc call*(call_568341: Call_PolicyEventsListQueryResultsForResource_568327;
          apiVersion: string; resourceId: string; Orderby: string = "";
          From: string = ""; policyEventsResource: string = "default"; Top: int = 0;
          Select: string = ""; To: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## policyEventsListQueryResultsForResource
  ## Queries policy events for the resource.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   policyEventsResource: string (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   resourceId: string (required)
  ##             : Resource ID.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568342 = newJObject()
  var query_568343 = newJObject()
  add(query_568343, "$orderby", newJString(Orderby))
  add(query_568343, "api-version", newJString(apiVersion))
  add(query_568343, "$from", newJString(From))
  add(path_568342, "policyEventsResource", newJString(policyEventsResource))
  add(query_568343, "$top", newJInt(Top))
  add(query_568343, "$select", newJString(Select))
  add(path_568342, "resourceId", newJString(resourceId))
  add(query_568343, "$to", newJString(To))
  add(query_568343, "$apply", newJString(Apply))
  add(query_568343, "$filter", newJString(Filter))
  result = call_568341.call(path_568342, query_568343, nil, nil, nil)

var policyEventsListQueryResultsForResource* = Call_PolicyEventsListQueryResultsForResource_568327(
    name: "policyEventsListQueryResultsForResource", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForResource_568328, base: "",
    url: url_PolicyEventsListQueryResultsForResource_568329,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsGetMetadata_568344 = ref object of OpenApiRestCall_567658
proc url_PolicyEventsGetMetadata_568346(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyEvents/$metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyEventsGetMetadata_568345(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets OData metadata XML document.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : A valid scope, i.e. management group, subscription, resource group, or resource ID. Scope used has no effect on metadata returned.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568347 = path.getOrDefault("scope")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "scope", valid_568347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568348 = query.getOrDefault("api-version")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "api-version", valid_568348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568349: Call_PolicyEventsGetMetadata_568344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets OData metadata XML document.
  ## 
  let valid = call_568349.validator(path, query, header, formData, body)
  let scheme = call_568349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568349.url(scheme.get, call_568349.host, call_568349.base,
                         call_568349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568349, url, valid)

proc call*(call_568350: Call_PolicyEventsGetMetadata_568344; apiVersion: string;
          scope: string): Recallable =
  ## policyEventsGetMetadata
  ## Gets OData metadata XML document.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   scope: string (required)
  ##        : A valid scope, i.e. management group, subscription, resource group, or resource ID. Scope used has no effect on metadata returned.
  var path_568351 = newJObject()
  var query_568352 = newJObject()
  add(query_568352, "api-version", newJString(apiVersion))
  add(path_568351, "scope", newJString(scope))
  result = call_568350.call(path_568351, query_568352, nil, nil, nil)

var policyEventsGetMetadata* = Call_PolicyEventsGetMetadata_568344(
    name: "policyEventsGetMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.PolicyInsights/policyEvents/$metadata",
    validator: validate_PolicyEventsGetMetadata_568345, base: "",
    url: url_PolicyEventsGetMetadata_568346, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
