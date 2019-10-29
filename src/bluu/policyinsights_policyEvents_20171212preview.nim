
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
  macServiceName = "policyinsights-policyEvents"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicyEventsListQueryResultsForManagementGroup_563778 = ref object of OpenApiRestCall_563556
proc url_PolicyEventsListQueryResultsForManagementGroup_563780(protocol: Scheme;
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

proc validate_PolicyEventsListQueryResultsForManagementGroup_563779(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy events for the resources under the management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyEventsResource: JString (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   managementGroupName: JString (required)
  ##                      : Management group name.
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyEventsResource` field"
  var valid_563969 = path.getOrDefault("policyEventsResource")
  valid_563969 = validateParameter(valid_563969, JString, required = true,
                                 default = newJString("default"))
  if valid_563969 != nil:
    section.add "policyEventsResource", valid_563969
  var valid_563970 = path.getOrDefault("managementGroupName")
  valid_563970 = validateParameter(valid_563970, JString, required = true,
                                 default = nil)
  if valid_563970 != nil:
    section.add "managementGroupName", valid_563970
  var valid_563971 = path.getOrDefault("managementGroupsNamespace")
  valid_563971 = validateParameter(valid_563971, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_563971 != nil:
    section.add "managementGroupsNamespace", valid_563971
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563972 = query.getOrDefault("api-version")
  valid_563972 = validateParameter(valid_563972, JString, required = true,
                                 default = nil)
  if valid_563972 != nil:
    section.add "api-version", valid_563972
  var valid_563973 = query.getOrDefault("$top")
  valid_563973 = validateParameter(valid_563973, JInt, required = false, default = nil)
  if valid_563973 != nil:
    section.add "$top", valid_563973
  var valid_563974 = query.getOrDefault("$select")
  valid_563974 = validateParameter(valid_563974, JString, required = false,
                                 default = nil)
  if valid_563974 != nil:
    section.add "$select", valid_563974
  var valid_563975 = query.getOrDefault("$to")
  valid_563975 = validateParameter(valid_563975, JString, required = false,
                                 default = nil)
  if valid_563975 != nil:
    section.add "$to", valid_563975
  var valid_563976 = query.getOrDefault("$orderby")
  valid_563976 = validateParameter(valid_563976, JString, required = false,
                                 default = nil)
  if valid_563976 != nil:
    section.add "$orderby", valid_563976
  var valid_563977 = query.getOrDefault("$apply")
  valid_563977 = validateParameter(valid_563977, JString, required = false,
                                 default = nil)
  if valid_563977 != nil:
    section.add "$apply", valid_563977
  var valid_563978 = query.getOrDefault("$filter")
  valid_563978 = validateParameter(valid_563978, JString, required = false,
                                 default = nil)
  if valid_563978 != nil:
    section.add "$filter", valid_563978
  var valid_563979 = query.getOrDefault("$from")
  valid_563979 = validateParameter(valid_563979, JString, required = false,
                                 default = nil)
  if valid_563979 != nil:
    section.add "$from", valid_563979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564002: Call_PolicyEventsListQueryResultsForManagementGroup_563778;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resources under the management group.
  ## 
  let valid = call_564002.validator(path, query, header, formData, body)
  let scheme = call_564002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564002.url(scheme.get, call_564002.host, call_564002.base,
                         call_564002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564002, url, valid)

proc call*(call_564073: Call_PolicyEventsListQueryResultsForManagementGroup_563778;
          apiVersion: string; managementGroupName: string;
          policyEventsResource: string = "default"; Top: int = 0; Select: string = "";
          To: string = ""; Orderby: string = "";
          managementGroupsNamespace: string = "Microsoft.Management";
          Apply: string = ""; Filter: string = ""; From: string = ""): Recallable =
  ## policyEventsListQueryResultsForManagementGroup
  ## Queries policy events for the resources under the management group.
  ##   policyEventsResource: string (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   managementGroupName: string (required)
  ##                      : Management group name.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  var path_564074 = newJObject()
  var query_564076 = newJObject()
  add(path_564074, "policyEventsResource", newJString(policyEventsResource))
  add(query_564076, "api-version", newJString(apiVersion))
  add(path_564074, "managementGroupName", newJString(managementGroupName))
  add(query_564076, "$top", newJInt(Top))
  add(query_564076, "$select", newJString(Select))
  add(query_564076, "$to", newJString(To))
  add(query_564076, "$orderby", newJString(Orderby))
  add(path_564074, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_564076, "$apply", newJString(Apply))
  add(query_564076, "$filter", newJString(Filter))
  add(query_564076, "$from", newJString(From))
  result = call_564073.call(path_564074, query_564076, nil, nil, nil)

var policyEventsListQueryResultsForManagementGroup* = Call_PolicyEventsListQueryResultsForManagementGroup_563778(
    name: "policyEventsListQueryResultsForManagementGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForManagementGroup_563779,
    base: "", url: url_PolicyEventsListQueryResultsForManagementGroup_563780,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForSubscription_564115 = ref object of OpenApiRestCall_563556
proc url_PolicyEventsListQueryResultsForSubscription_564117(protocol: Scheme;
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

proc validate_PolicyEventsListQueryResultsForSubscription_564116(path: JsonNode;
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
  var valid_564118 = path.getOrDefault("policyEventsResource")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = newJString("default"))
  if valid_564118 != nil:
    section.add "policyEventsResource", valid_564118
  var valid_564119 = path.getOrDefault("subscriptionId")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "subscriptionId", valid_564119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564120 = query.getOrDefault("api-version")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "api-version", valid_564120
  var valid_564121 = query.getOrDefault("$top")
  valid_564121 = validateParameter(valid_564121, JInt, required = false, default = nil)
  if valid_564121 != nil:
    section.add "$top", valid_564121
  var valid_564122 = query.getOrDefault("$select")
  valid_564122 = validateParameter(valid_564122, JString, required = false,
                                 default = nil)
  if valid_564122 != nil:
    section.add "$select", valid_564122
  var valid_564123 = query.getOrDefault("$to")
  valid_564123 = validateParameter(valid_564123, JString, required = false,
                                 default = nil)
  if valid_564123 != nil:
    section.add "$to", valid_564123
  var valid_564124 = query.getOrDefault("$orderby")
  valid_564124 = validateParameter(valid_564124, JString, required = false,
                                 default = nil)
  if valid_564124 != nil:
    section.add "$orderby", valid_564124
  var valid_564125 = query.getOrDefault("$apply")
  valid_564125 = validateParameter(valid_564125, JString, required = false,
                                 default = nil)
  if valid_564125 != nil:
    section.add "$apply", valid_564125
  var valid_564126 = query.getOrDefault("$filter")
  valid_564126 = validateParameter(valid_564126, JString, required = false,
                                 default = nil)
  if valid_564126 != nil:
    section.add "$filter", valid_564126
  var valid_564127 = query.getOrDefault("$from")
  valid_564127 = validateParameter(valid_564127, JString, required = false,
                                 default = nil)
  if valid_564127 != nil:
    section.add "$from", valid_564127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564128: Call_PolicyEventsListQueryResultsForSubscription_564115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resources under the subscription.
  ## 
  let valid = call_564128.validator(path, query, header, formData, body)
  let scheme = call_564128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564128.url(scheme.get, call_564128.host, call_564128.base,
                         call_564128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564128, url, valid)

proc call*(call_564129: Call_PolicyEventsListQueryResultsForSubscription_564115;
          apiVersion: string; subscriptionId: string;
          policyEventsResource: string = "default"; Top: int = 0; Select: string = "";
          To: string = ""; Orderby: string = ""; Apply: string = ""; Filter: string = "";
          From: string = ""): Recallable =
  ## policyEventsListQueryResultsForSubscription
  ## Queries policy events for the resources under the subscription.
  ##   policyEventsResource: string (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  var path_564130 = newJObject()
  var query_564131 = newJObject()
  add(path_564130, "policyEventsResource", newJString(policyEventsResource))
  add(query_564131, "api-version", newJString(apiVersion))
  add(query_564131, "$top", newJInt(Top))
  add(query_564131, "$select", newJString(Select))
  add(path_564130, "subscriptionId", newJString(subscriptionId))
  add(query_564131, "$to", newJString(To))
  add(query_564131, "$orderby", newJString(Orderby))
  add(query_564131, "$apply", newJString(Apply))
  add(query_564131, "$filter", newJString(Filter))
  add(query_564131, "$from", newJString(From))
  result = call_564129.call(path_564130, query_564131, nil, nil, nil)

var policyEventsListQueryResultsForSubscription* = Call_PolicyEventsListQueryResultsForSubscription_564115(
    name: "policyEventsListQueryResultsForSubscription",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForSubscription_564116,
    base: "", url: url_PolicyEventsListQueryResultsForSubscription_564117,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_564132 = ref object of OpenApiRestCall_563556
proc url_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_564134(
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

proc validate_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_564133(
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
  ##   policyAssignmentName: JString (required)
  ##                       : Policy assignment name.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationNamespace` field"
  var valid_564135 = path.getOrDefault("authorizationNamespace")
  valid_564135 = validateParameter(valid_564135, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_564135 != nil:
    section.add "authorizationNamespace", valid_564135
  var valid_564136 = path.getOrDefault("policyEventsResource")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = newJString("default"))
  if valid_564136 != nil:
    section.add "policyEventsResource", valid_564136
  var valid_564137 = path.getOrDefault("policyAssignmentName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "policyAssignmentName", valid_564137
  var valid_564138 = path.getOrDefault("subscriptionId")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "subscriptionId", valid_564138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564139 = query.getOrDefault("api-version")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "api-version", valid_564139
  var valid_564140 = query.getOrDefault("$top")
  valid_564140 = validateParameter(valid_564140, JInt, required = false, default = nil)
  if valid_564140 != nil:
    section.add "$top", valid_564140
  var valid_564141 = query.getOrDefault("$select")
  valid_564141 = validateParameter(valid_564141, JString, required = false,
                                 default = nil)
  if valid_564141 != nil:
    section.add "$select", valid_564141
  var valid_564142 = query.getOrDefault("$to")
  valid_564142 = validateParameter(valid_564142, JString, required = false,
                                 default = nil)
  if valid_564142 != nil:
    section.add "$to", valid_564142
  var valid_564143 = query.getOrDefault("$orderby")
  valid_564143 = validateParameter(valid_564143, JString, required = false,
                                 default = nil)
  if valid_564143 != nil:
    section.add "$orderby", valid_564143
  var valid_564144 = query.getOrDefault("$apply")
  valid_564144 = validateParameter(valid_564144, JString, required = false,
                                 default = nil)
  if valid_564144 != nil:
    section.add "$apply", valid_564144
  var valid_564145 = query.getOrDefault("$filter")
  valid_564145 = validateParameter(valid_564145, JString, required = false,
                                 default = nil)
  if valid_564145 != nil:
    section.add "$filter", valid_564145
  var valid_564146 = query.getOrDefault("$from")
  valid_564146 = validateParameter(valid_564146, JString, required = false,
                                 default = nil)
  if valid_564146 != nil:
    section.add "$from", valid_564146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564147: Call_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_564132;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the subscription level policy assignment.
  ## 
  let valid = call_564147.validator(path, query, header, formData, body)
  let scheme = call_564147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564147.url(scheme.get, call_564147.host, call_564147.base,
                         call_564147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564147, url, valid)

proc call*(call_564148: Call_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_564132;
          apiVersion: string; policyAssignmentName: string; subscriptionId: string;
          authorizationNamespace: string = "Microsoft.Authorization";
          policyEventsResource: string = "default"; Top: int = 0; Select: string = "";
          To: string = ""; Orderby: string = ""; Apply: string = ""; Filter: string = "";
          From: string = ""): Recallable =
  ## policyEventsListQueryResultsForSubscriptionLevelPolicyAssignment
  ## Queries policy events for the subscription level policy assignment.
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   policyEventsResource: string (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  var path_564149 = newJObject()
  var query_564150 = newJObject()
  add(path_564149, "authorizationNamespace", newJString(authorizationNamespace))
  add(path_564149, "policyEventsResource", newJString(policyEventsResource))
  add(query_564150, "api-version", newJString(apiVersion))
  add(query_564150, "$top", newJInt(Top))
  add(path_564149, "policyAssignmentName", newJString(policyAssignmentName))
  add(query_564150, "$select", newJString(Select))
  add(path_564149, "subscriptionId", newJString(subscriptionId))
  add(query_564150, "$to", newJString(To))
  add(query_564150, "$orderby", newJString(Orderby))
  add(query_564150, "$apply", newJString(Apply))
  add(query_564150, "$filter", newJString(Filter))
  add(query_564150, "$from", newJString(From))
  result = call_564148.call(path_564149, query_564150, nil, nil, nil)

var policyEventsListQueryResultsForSubscriptionLevelPolicyAssignment* = Call_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_564132(
    name: "policyEventsListQueryResultsForSubscriptionLevelPolicyAssignment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policyAssignments/{policyAssignmentName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults", validator: validate_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_564133,
    base: "",
    url: url_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_564134,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForPolicyDefinition_564151 = ref object of OpenApiRestCall_563556
proc url_PolicyEventsListQueryResultsForPolicyDefinition_564153(protocol: Scheme;
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

proc validate_PolicyEventsListQueryResultsForPolicyDefinition_564152(
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
  var valid_564154 = path.getOrDefault("authorizationNamespace")
  valid_564154 = validateParameter(valid_564154, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_564154 != nil:
    section.add "authorizationNamespace", valid_564154
  var valid_564155 = path.getOrDefault("policyEventsResource")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = newJString("default"))
  if valid_564155 != nil:
    section.add "policyEventsResource", valid_564155
  var valid_564156 = path.getOrDefault("subscriptionId")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "subscriptionId", valid_564156
  var valid_564157 = path.getOrDefault("policyDefinitionName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "policyDefinitionName", valid_564157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564158 = query.getOrDefault("api-version")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "api-version", valid_564158
  var valid_564159 = query.getOrDefault("$top")
  valid_564159 = validateParameter(valid_564159, JInt, required = false, default = nil)
  if valid_564159 != nil:
    section.add "$top", valid_564159
  var valid_564160 = query.getOrDefault("$select")
  valid_564160 = validateParameter(valid_564160, JString, required = false,
                                 default = nil)
  if valid_564160 != nil:
    section.add "$select", valid_564160
  var valid_564161 = query.getOrDefault("$to")
  valid_564161 = validateParameter(valid_564161, JString, required = false,
                                 default = nil)
  if valid_564161 != nil:
    section.add "$to", valid_564161
  var valid_564162 = query.getOrDefault("$orderby")
  valid_564162 = validateParameter(valid_564162, JString, required = false,
                                 default = nil)
  if valid_564162 != nil:
    section.add "$orderby", valid_564162
  var valid_564163 = query.getOrDefault("$apply")
  valid_564163 = validateParameter(valid_564163, JString, required = false,
                                 default = nil)
  if valid_564163 != nil:
    section.add "$apply", valid_564163
  var valid_564164 = query.getOrDefault("$filter")
  valid_564164 = validateParameter(valid_564164, JString, required = false,
                                 default = nil)
  if valid_564164 != nil:
    section.add "$filter", valid_564164
  var valid_564165 = query.getOrDefault("$from")
  valid_564165 = validateParameter(valid_564165, JString, required = false,
                                 default = nil)
  if valid_564165 != nil:
    section.add "$from", valid_564165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564166: Call_PolicyEventsListQueryResultsForPolicyDefinition_564151;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the subscription level policy definition.
  ## 
  let valid = call_564166.validator(path, query, header, formData, body)
  let scheme = call_564166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564166.url(scheme.get, call_564166.host, call_564166.base,
                         call_564166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564166, url, valid)

proc call*(call_564167: Call_PolicyEventsListQueryResultsForPolicyDefinition_564151;
          apiVersion: string; subscriptionId: string; policyDefinitionName: string;
          authorizationNamespace: string = "Microsoft.Authorization";
          policyEventsResource: string = "default"; Top: int = 0; Select: string = "";
          To: string = ""; Orderby: string = ""; Apply: string = ""; Filter: string = "";
          From: string = ""): Recallable =
  ## policyEventsListQueryResultsForPolicyDefinition
  ## Queries policy events for the subscription level policy definition.
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   policyEventsResource: string (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   policyDefinitionName: string (required)
  ##                       : Policy definition name.
  ##   Filter: string
  ##         : OData filter expression.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  var path_564168 = newJObject()
  var query_564169 = newJObject()
  add(path_564168, "authorizationNamespace", newJString(authorizationNamespace))
  add(path_564168, "policyEventsResource", newJString(policyEventsResource))
  add(query_564169, "api-version", newJString(apiVersion))
  add(query_564169, "$top", newJInt(Top))
  add(query_564169, "$select", newJString(Select))
  add(path_564168, "subscriptionId", newJString(subscriptionId))
  add(query_564169, "$to", newJString(To))
  add(query_564169, "$orderby", newJString(Orderby))
  add(query_564169, "$apply", newJString(Apply))
  add(path_564168, "policyDefinitionName", newJString(policyDefinitionName))
  add(query_564169, "$filter", newJString(Filter))
  add(query_564169, "$from", newJString(From))
  result = call_564167.call(path_564168, query_564169, nil, nil, nil)

var policyEventsListQueryResultsForPolicyDefinition* = Call_PolicyEventsListQueryResultsForPolicyDefinition_564151(
    name: "policyEventsListQueryResultsForPolicyDefinition",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policyDefinitions/{policyDefinitionName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForPolicyDefinition_564152,
    base: "", url: url_PolicyEventsListQueryResultsForPolicyDefinition_564153,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForPolicySetDefinition_564170 = ref object of OpenApiRestCall_563556
proc url_PolicyEventsListQueryResultsForPolicySetDefinition_564172(
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

proc validate_PolicyEventsListQueryResultsForPolicySetDefinition_564171(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy events for the subscription level policy set definition.
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
  ##   policySetDefinitionName: JString (required)
  ##                          : Policy set definition name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationNamespace` field"
  var valid_564173 = path.getOrDefault("authorizationNamespace")
  valid_564173 = validateParameter(valid_564173, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_564173 != nil:
    section.add "authorizationNamespace", valid_564173
  var valid_564174 = path.getOrDefault("policyEventsResource")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = newJString("default"))
  if valid_564174 != nil:
    section.add "policyEventsResource", valid_564174
  var valid_564175 = path.getOrDefault("subscriptionId")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "subscriptionId", valid_564175
  var valid_564176 = path.getOrDefault("policySetDefinitionName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "policySetDefinitionName", valid_564176
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564177 = query.getOrDefault("api-version")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "api-version", valid_564177
  var valid_564178 = query.getOrDefault("$top")
  valid_564178 = validateParameter(valid_564178, JInt, required = false, default = nil)
  if valid_564178 != nil:
    section.add "$top", valid_564178
  var valid_564179 = query.getOrDefault("$select")
  valid_564179 = validateParameter(valid_564179, JString, required = false,
                                 default = nil)
  if valid_564179 != nil:
    section.add "$select", valid_564179
  var valid_564180 = query.getOrDefault("$to")
  valid_564180 = validateParameter(valid_564180, JString, required = false,
                                 default = nil)
  if valid_564180 != nil:
    section.add "$to", valid_564180
  var valid_564181 = query.getOrDefault("$orderby")
  valid_564181 = validateParameter(valid_564181, JString, required = false,
                                 default = nil)
  if valid_564181 != nil:
    section.add "$orderby", valid_564181
  var valid_564182 = query.getOrDefault("$apply")
  valid_564182 = validateParameter(valid_564182, JString, required = false,
                                 default = nil)
  if valid_564182 != nil:
    section.add "$apply", valid_564182
  var valid_564183 = query.getOrDefault("$filter")
  valid_564183 = validateParameter(valid_564183, JString, required = false,
                                 default = nil)
  if valid_564183 != nil:
    section.add "$filter", valid_564183
  var valid_564184 = query.getOrDefault("$from")
  valid_564184 = validateParameter(valid_564184, JString, required = false,
                                 default = nil)
  if valid_564184 != nil:
    section.add "$from", valid_564184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564185: Call_PolicyEventsListQueryResultsForPolicySetDefinition_564170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the subscription level policy set definition.
  ## 
  let valid = call_564185.validator(path, query, header, formData, body)
  let scheme = call_564185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564185.url(scheme.get, call_564185.host, call_564185.base,
                         call_564185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564185, url, valid)

proc call*(call_564186: Call_PolicyEventsListQueryResultsForPolicySetDefinition_564170;
          apiVersion: string; subscriptionId: string;
          policySetDefinitionName: string;
          authorizationNamespace: string = "Microsoft.Authorization";
          policyEventsResource: string = "default"; Top: int = 0; Select: string = "";
          To: string = ""; Orderby: string = ""; Apply: string = ""; Filter: string = "";
          From: string = ""): Recallable =
  ## policyEventsListQueryResultsForPolicySetDefinition
  ## Queries policy events for the subscription level policy set definition.
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   policyEventsResource: string (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   policySetDefinitionName: string (required)
  ##                          : Policy set definition name.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  var path_564187 = newJObject()
  var query_564188 = newJObject()
  add(path_564187, "authorizationNamespace", newJString(authorizationNamespace))
  add(path_564187, "policyEventsResource", newJString(policyEventsResource))
  add(query_564188, "api-version", newJString(apiVersion))
  add(query_564188, "$top", newJInt(Top))
  add(query_564188, "$select", newJString(Select))
  add(path_564187, "subscriptionId", newJString(subscriptionId))
  add(query_564188, "$to", newJString(To))
  add(query_564188, "$orderby", newJString(Orderby))
  add(path_564187, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_564188, "$apply", newJString(Apply))
  add(query_564188, "$filter", newJString(Filter))
  add(query_564188, "$from", newJString(From))
  result = call_564186.call(path_564187, query_564188, nil, nil, nil)

var policyEventsListQueryResultsForPolicySetDefinition* = Call_PolicyEventsListQueryResultsForPolicySetDefinition_564170(
    name: "policyEventsListQueryResultsForPolicySetDefinition",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policySetDefinitions/{policySetDefinitionName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForPolicySetDefinition_564171,
    base: "", url: url_PolicyEventsListQueryResultsForPolicySetDefinition_564172,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForResourceGroup_564189 = ref object of OpenApiRestCall_563556
proc url_PolicyEventsListQueryResultsForResourceGroup_564191(protocol: Scheme;
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

proc validate_PolicyEventsListQueryResultsForResourceGroup_564190(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queries policy events for the resources under the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyEventsResource: JString (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyEventsResource` field"
  var valid_564192 = path.getOrDefault("policyEventsResource")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = newJString("default"))
  if valid_564192 != nil:
    section.add "policyEventsResource", valid_564192
  var valid_564193 = path.getOrDefault("subscriptionId")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "subscriptionId", valid_564193
  var valid_564194 = path.getOrDefault("resourceGroupName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "resourceGroupName", valid_564194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564195 = query.getOrDefault("api-version")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "api-version", valid_564195
  var valid_564196 = query.getOrDefault("$top")
  valid_564196 = validateParameter(valid_564196, JInt, required = false, default = nil)
  if valid_564196 != nil:
    section.add "$top", valid_564196
  var valid_564197 = query.getOrDefault("$select")
  valid_564197 = validateParameter(valid_564197, JString, required = false,
                                 default = nil)
  if valid_564197 != nil:
    section.add "$select", valid_564197
  var valid_564198 = query.getOrDefault("$to")
  valid_564198 = validateParameter(valid_564198, JString, required = false,
                                 default = nil)
  if valid_564198 != nil:
    section.add "$to", valid_564198
  var valid_564199 = query.getOrDefault("$orderby")
  valid_564199 = validateParameter(valid_564199, JString, required = false,
                                 default = nil)
  if valid_564199 != nil:
    section.add "$orderby", valid_564199
  var valid_564200 = query.getOrDefault("$apply")
  valid_564200 = validateParameter(valid_564200, JString, required = false,
                                 default = nil)
  if valid_564200 != nil:
    section.add "$apply", valid_564200
  var valid_564201 = query.getOrDefault("$filter")
  valid_564201 = validateParameter(valid_564201, JString, required = false,
                                 default = nil)
  if valid_564201 != nil:
    section.add "$filter", valid_564201
  var valid_564202 = query.getOrDefault("$from")
  valid_564202 = validateParameter(valid_564202, JString, required = false,
                                 default = nil)
  if valid_564202 != nil:
    section.add "$from", valid_564202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564203: Call_PolicyEventsListQueryResultsForResourceGroup_564189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resources under the resource group.
  ## 
  let valid = call_564203.validator(path, query, header, formData, body)
  let scheme = call_564203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564203.url(scheme.get, call_564203.host, call_564203.base,
                         call_564203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564203, url, valid)

proc call*(call_564204: Call_PolicyEventsListQueryResultsForResourceGroup_564189;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          policyEventsResource: string = "default"; Top: int = 0; Select: string = "";
          To: string = ""; Orderby: string = ""; Apply: string = ""; Filter: string = "";
          From: string = ""): Recallable =
  ## policyEventsListQueryResultsForResourceGroup
  ## Queries policy events for the resources under the resource group.
  ##   policyEventsResource: string (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   Filter: string
  ##         : OData filter expression.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  var path_564205 = newJObject()
  var query_564206 = newJObject()
  add(path_564205, "policyEventsResource", newJString(policyEventsResource))
  add(query_564206, "api-version", newJString(apiVersion))
  add(query_564206, "$top", newJInt(Top))
  add(query_564206, "$select", newJString(Select))
  add(path_564205, "subscriptionId", newJString(subscriptionId))
  add(query_564206, "$to", newJString(To))
  add(query_564206, "$orderby", newJString(Orderby))
  add(query_564206, "$apply", newJString(Apply))
  add(path_564205, "resourceGroupName", newJString(resourceGroupName))
  add(query_564206, "$filter", newJString(Filter))
  add(query_564206, "$from", newJString(From))
  result = call_564204.call(path_564205, query_564206, nil, nil, nil)

var policyEventsListQueryResultsForResourceGroup* = Call_PolicyEventsListQueryResultsForResourceGroup_564189(
    name: "policyEventsListQueryResultsForResourceGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForResourceGroup_564190,
    base: "", url: url_PolicyEventsListQueryResultsForResourceGroup_564191,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_564207 = ref object of OpenApiRestCall_563556
proc url_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_564209(
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

proc validate_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_564208(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy events for the resource group level policy assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   policyEventsResource: JString (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   policyAssignmentName: JString (required)
  ##                       : Policy assignment name.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationNamespace` field"
  var valid_564210 = path.getOrDefault("authorizationNamespace")
  valid_564210 = validateParameter(valid_564210, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_564210 != nil:
    section.add "authorizationNamespace", valid_564210
  var valid_564211 = path.getOrDefault("policyEventsResource")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = newJString("default"))
  if valid_564211 != nil:
    section.add "policyEventsResource", valid_564211
  var valid_564212 = path.getOrDefault("policyAssignmentName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "policyAssignmentName", valid_564212
  var valid_564213 = path.getOrDefault("subscriptionId")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "subscriptionId", valid_564213
  var valid_564214 = path.getOrDefault("resourceGroupName")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "resourceGroupName", valid_564214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564215 = query.getOrDefault("api-version")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "api-version", valid_564215
  var valid_564216 = query.getOrDefault("$top")
  valid_564216 = validateParameter(valid_564216, JInt, required = false, default = nil)
  if valid_564216 != nil:
    section.add "$top", valid_564216
  var valid_564217 = query.getOrDefault("$select")
  valid_564217 = validateParameter(valid_564217, JString, required = false,
                                 default = nil)
  if valid_564217 != nil:
    section.add "$select", valid_564217
  var valid_564218 = query.getOrDefault("$to")
  valid_564218 = validateParameter(valid_564218, JString, required = false,
                                 default = nil)
  if valid_564218 != nil:
    section.add "$to", valid_564218
  var valid_564219 = query.getOrDefault("$orderby")
  valid_564219 = validateParameter(valid_564219, JString, required = false,
                                 default = nil)
  if valid_564219 != nil:
    section.add "$orderby", valid_564219
  var valid_564220 = query.getOrDefault("$apply")
  valid_564220 = validateParameter(valid_564220, JString, required = false,
                                 default = nil)
  if valid_564220 != nil:
    section.add "$apply", valid_564220
  var valid_564221 = query.getOrDefault("$filter")
  valid_564221 = validateParameter(valid_564221, JString, required = false,
                                 default = nil)
  if valid_564221 != nil:
    section.add "$filter", valid_564221
  var valid_564222 = query.getOrDefault("$from")
  valid_564222 = validateParameter(valid_564222, JString, required = false,
                                 default = nil)
  if valid_564222 != nil:
    section.add "$from", valid_564222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564223: Call_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_564207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resource group level policy assignment.
  ## 
  let valid = call_564223.validator(path, query, header, formData, body)
  let scheme = call_564223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564223.url(scheme.get, call_564223.host, call_564223.base,
                         call_564223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564223, url, valid)

proc call*(call_564224: Call_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_564207;
          apiVersion: string; policyAssignmentName: string; subscriptionId: string;
          resourceGroupName: string;
          authorizationNamespace: string = "Microsoft.Authorization";
          policyEventsResource: string = "default"; Top: int = 0; Select: string = "";
          To: string = ""; Orderby: string = ""; Apply: string = ""; Filter: string = "";
          From: string = ""): Recallable =
  ## policyEventsListQueryResultsForResourceGroupLevelPolicyAssignment
  ## Queries policy events for the resource group level policy assignment.
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   policyEventsResource: string (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   Filter: string
  ##         : OData filter expression.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  var path_564225 = newJObject()
  var query_564226 = newJObject()
  add(path_564225, "authorizationNamespace", newJString(authorizationNamespace))
  add(path_564225, "policyEventsResource", newJString(policyEventsResource))
  add(query_564226, "api-version", newJString(apiVersion))
  add(query_564226, "$top", newJInt(Top))
  add(path_564225, "policyAssignmentName", newJString(policyAssignmentName))
  add(query_564226, "$select", newJString(Select))
  add(path_564225, "subscriptionId", newJString(subscriptionId))
  add(query_564226, "$to", newJString(To))
  add(query_564226, "$orderby", newJString(Orderby))
  add(query_564226, "$apply", newJString(Apply))
  add(path_564225, "resourceGroupName", newJString(resourceGroupName))
  add(query_564226, "$filter", newJString(Filter))
  add(query_564226, "$from", newJString(From))
  result = call_564224.call(path_564225, query_564226, nil, nil, nil)

var policyEventsListQueryResultsForResourceGroupLevelPolicyAssignment* = Call_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_564207(
    name: "policyEventsListQueryResultsForResourceGroupLevelPolicyAssignment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{authorizationNamespace}/policyAssignments/{policyAssignmentName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults", validator: validate_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_564208,
    base: "",
    url: url_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_564209,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForResource_564227 = ref object of OpenApiRestCall_563556
proc url_PolicyEventsListQueryResultsForResource_564229(protocol: Scheme;
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

proc validate_PolicyEventsListQueryResultsForResource_564228(path: JsonNode;
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
  var valid_564230 = path.getOrDefault("policyEventsResource")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = newJString("default"))
  if valid_564230 != nil:
    section.add "policyEventsResource", valid_564230
  var valid_564231 = path.getOrDefault("resourceId")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "resourceId", valid_564231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564232 = query.getOrDefault("api-version")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "api-version", valid_564232
  var valid_564233 = query.getOrDefault("$top")
  valid_564233 = validateParameter(valid_564233, JInt, required = false, default = nil)
  if valid_564233 != nil:
    section.add "$top", valid_564233
  var valid_564234 = query.getOrDefault("$select")
  valid_564234 = validateParameter(valid_564234, JString, required = false,
                                 default = nil)
  if valid_564234 != nil:
    section.add "$select", valid_564234
  var valid_564235 = query.getOrDefault("$to")
  valid_564235 = validateParameter(valid_564235, JString, required = false,
                                 default = nil)
  if valid_564235 != nil:
    section.add "$to", valid_564235
  var valid_564236 = query.getOrDefault("$orderby")
  valid_564236 = validateParameter(valid_564236, JString, required = false,
                                 default = nil)
  if valid_564236 != nil:
    section.add "$orderby", valid_564236
  var valid_564237 = query.getOrDefault("$apply")
  valid_564237 = validateParameter(valid_564237, JString, required = false,
                                 default = nil)
  if valid_564237 != nil:
    section.add "$apply", valid_564237
  var valid_564238 = query.getOrDefault("$filter")
  valid_564238 = validateParameter(valid_564238, JString, required = false,
                                 default = nil)
  if valid_564238 != nil:
    section.add "$filter", valid_564238
  var valid_564239 = query.getOrDefault("$from")
  valid_564239 = validateParameter(valid_564239, JString, required = false,
                                 default = nil)
  if valid_564239 != nil:
    section.add "$from", valid_564239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564240: Call_PolicyEventsListQueryResultsForResource_564227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resource.
  ## 
  let valid = call_564240.validator(path, query, header, formData, body)
  let scheme = call_564240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564240.url(scheme.get, call_564240.host, call_564240.base,
                         call_564240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564240, url, valid)

proc call*(call_564241: Call_PolicyEventsListQueryResultsForResource_564227;
          apiVersion: string; resourceId: string;
          policyEventsResource: string = "default"; Top: int = 0; Select: string = "";
          To: string = ""; Orderby: string = ""; Apply: string = ""; Filter: string = "";
          From: string = ""): Recallable =
  ## policyEventsListQueryResultsForResource
  ## Queries policy events for the resource.
  ##   policyEventsResource: string (required)
  ##                       : The name of the virtual resource under PolicyEvents resource type; only "default" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   resourceId: string (required)
  ##             : Resource ID.
  var path_564242 = newJObject()
  var query_564243 = newJObject()
  add(path_564242, "policyEventsResource", newJString(policyEventsResource))
  add(query_564243, "api-version", newJString(apiVersion))
  add(query_564243, "$top", newJInt(Top))
  add(query_564243, "$select", newJString(Select))
  add(query_564243, "$to", newJString(To))
  add(query_564243, "$orderby", newJString(Orderby))
  add(query_564243, "$apply", newJString(Apply))
  add(query_564243, "$filter", newJString(Filter))
  add(query_564243, "$from", newJString(From))
  add(path_564242, "resourceId", newJString(resourceId))
  result = call_564241.call(path_564242, query_564243, nil, nil, nil)

var policyEventsListQueryResultsForResource* = Call_PolicyEventsListQueryResultsForResource_564227(
    name: "policyEventsListQueryResultsForResource", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForResource_564228, base: "",
    url: url_PolicyEventsListQueryResultsForResource_564229,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsGetMetadata_564244 = ref object of OpenApiRestCall_563556
proc url_PolicyEventsGetMetadata_564246(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyEventsGetMetadata_564245(path: JsonNode; query: JsonNode;
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
  var valid_564247 = path.getOrDefault("scope")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "scope", valid_564247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564248 = query.getOrDefault("api-version")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "api-version", valid_564248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564249: Call_PolicyEventsGetMetadata_564244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets OData metadata XML document.
  ## 
  let valid = call_564249.validator(path, query, header, formData, body)
  let scheme = call_564249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564249.url(scheme.get, call_564249.host, call_564249.base,
                         call_564249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564249, url, valid)

proc call*(call_564250: Call_PolicyEventsGetMetadata_564244; apiVersion: string;
          scope: string): Recallable =
  ## policyEventsGetMetadata
  ## Gets OData metadata XML document.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   scope: string (required)
  ##        : A valid scope, i.e. management group, subscription, resource group, or resource ID. Scope used has no effect on metadata returned.
  var path_564251 = newJObject()
  var query_564252 = newJObject()
  add(query_564252, "api-version", newJString(apiVersion))
  add(path_564251, "scope", newJString(scope))
  result = call_564250.call(path_564251, query_564252, nil, nil, nil)

var policyEventsGetMetadata* = Call_PolicyEventsGetMetadata_564244(
    name: "policyEventsGetMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.PolicyInsights/policyEvents/$metadata",
    validator: validate_PolicyEventsGetMetadata_564245, base: "",
    url: url_PolicyEventsGetMetadata_564246, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
