
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: PolicyEventsClient
## version: 2017-08-09-preview
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
  ##                            : The namespace for Microsoft Management resource provider; only "Microsoft.Management" is allowed.
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
  ##                            : The namespace for Microsoft Management resource provider; only "Microsoft.Management" is allowed.
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
  Call_PolicyEventsListQueryResultsForResourceGroup_568232 = ref object of OpenApiRestCall_567658
proc url_PolicyEventsListQueryResultsForResourceGroup_568234(protocol: Scheme;
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

proc validate_PolicyEventsListQueryResultsForResourceGroup_568233(path: JsonNode;
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
  var valid_568235 = path.getOrDefault("resourceGroupName")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "resourceGroupName", valid_568235
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
  var valid_568238 = query.getOrDefault("$orderby")
  valid_568238 = validateParameter(valid_568238, JString, required = false,
                                 default = nil)
  if valid_568238 != nil:
    section.add "$orderby", valid_568238
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568239 = query.getOrDefault("api-version")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "api-version", valid_568239
  var valid_568240 = query.getOrDefault("$from")
  valid_568240 = validateParameter(valid_568240, JString, required = false,
                                 default = nil)
  if valid_568240 != nil:
    section.add "$from", valid_568240
  var valid_568241 = query.getOrDefault("$top")
  valid_568241 = validateParameter(valid_568241, JInt, required = false, default = nil)
  if valid_568241 != nil:
    section.add "$top", valid_568241
  var valid_568242 = query.getOrDefault("$select")
  valid_568242 = validateParameter(valid_568242, JString, required = false,
                                 default = nil)
  if valid_568242 != nil:
    section.add "$select", valid_568242
  var valid_568243 = query.getOrDefault("$to")
  valid_568243 = validateParameter(valid_568243, JString, required = false,
                                 default = nil)
  if valid_568243 != nil:
    section.add "$to", valid_568243
  var valid_568244 = query.getOrDefault("$apply")
  valid_568244 = validateParameter(valid_568244, JString, required = false,
                                 default = nil)
  if valid_568244 != nil:
    section.add "$apply", valid_568244
  var valid_568245 = query.getOrDefault("$filter")
  valid_568245 = validateParameter(valid_568245, JString, required = false,
                                 default = nil)
  if valid_568245 != nil:
    section.add "$filter", valid_568245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568246: Call_PolicyEventsListQueryResultsForResourceGroup_568232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resources under the resource group.
  ## 
  let valid = call_568246.validator(path, query, header, formData, body)
  let scheme = call_568246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568246.url(scheme.get, call_568246.host, call_568246.base,
                         call_568246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568246, url, valid)

proc call*(call_568247: Call_PolicyEventsListQueryResultsForResourceGroup_568232;
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
  var path_568248 = newJObject()
  var query_568249 = newJObject()
  add(query_568249, "$orderby", newJString(Orderby))
  add(path_568248, "resourceGroupName", newJString(resourceGroupName))
  add(query_568249, "api-version", newJString(apiVersion))
  add(query_568249, "$from", newJString(From))
  add(path_568248, "policyEventsResource", newJString(policyEventsResource))
  add(path_568248, "subscriptionId", newJString(subscriptionId))
  add(query_568249, "$top", newJInt(Top))
  add(query_568249, "$select", newJString(Select))
  add(query_568249, "$to", newJString(To))
  add(query_568249, "$apply", newJString(Apply))
  add(query_568249, "$filter", newJString(Filter))
  result = call_568247.call(path_568248, query_568249, nil, nil, nil)

var policyEventsListQueryResultsForResourceGroup* = Call_PolicyEventsListQueryResultsForResourceGroup_568232(
    name: "policyEventsListQueryResultsForResourceGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForResourceGroup_568233,
    base: "", url: url_PolicyEventsListQueryResultsForResourceGroup_568234,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForResource_568250 = ref object of OpenApiRestCall_567658
proc url_PolicyEventsListQueryResultsForResource_568252(protocol: Scheme;
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

proc validate_PolicyEventsListQueryResultsForResource_568251(path: JsonNode;
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
  var valid_568253 = path.getOrDefault("policyEventsResource")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = newJString("default"))
  if valid_568253 != nil:
    section.add "policyEventsResource", valid_568253
  var valid_568254 = path.getOrDefault("resourceId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "resourceId", valid_568254
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
  var valid_568255 = query.getOrDefault("$orderby")
  valid_568255 = validateParameter(valid_568255, JString, required = false,
                                 default = nil)
  if valid_568255 != nil:
    section.add "$orderby", valid_568255
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568256 = query.getOrDefault("api-version")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "api-version", valid_568256
  var valid_568257 = query.getOrDefault("$from")
  valid_568257 = validateParameter(valid_568257, JString, required = false,
                                 default = nil)
  if valid_568257 != nil:
    section.add "$from", valid_568257
  var valid_568258 = query.getOrDefault("$top")
  valid_568258 = validateParameter(valid_568258, JInt, required = false, default = nil)
  if valid_568258 != nil:
    section.add "$top", valid_568258
  var valid_568259 = query.getOrDefault("$select")
  valid_568259 = validateParameter(valid_568259, JString, required = false,
                                 default = nil)
  if valid_568259 != nil:
    section.add "$select", valid_568259
  var valid_568260 = query.getOrDefault("$to")
  valid_568260 = validateParameter(valid_568260, JString, required = false,
                                 default = nil)
  if valid_568260 != nil:
    section.add "$to", valid_568260
  var valid_568261 = query.getOrDefault("$apply")
  valid_568261 = validateParameter(valid_568261, JString, required = false,
                                 default = nil)
  if valid_568261 != nil:
    section.add "$apply", valid_568261
  var valid_568262 = query.getOrDefault("$filter")
  valid_568262 = validateParameter(valid_568262, JString, required = false,
                                 default = nil)
  if valid_568262 != nil:
    section.add "$filter", valid_568262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568263: Call_PolicyEventsListQueryResultsForResource_568250;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resource.
  ## 
  let valid = call_568263.validator(path, query, header, formData, body)
  let scheme = call_568263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568263.url(scheme.get, call_568263.host, call_568263.base,
                         call_568263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568263, url, valid)

proc call*(call_568264: Call_PolicyEventsListQueryResultsForResource_568250;
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
  var path_568265 = newJObject()
  var query_568266 = newJObject()
  add(query_568266, "$orderby", newJString(Orderby))
  add(query_568266, "api-version", newJString(apiVersion))
  add(query_568266, "$from", newJString(From))
  add(path_568265, "policyEventsResource", newJString(policyEventsResource))
  add(query_568266, "$top", newJInt(Top))
  add(query_568266, "$select", newJString(Select))
  add(path_568265, "resourceId", newJString(resourceId))
  add(query_568266, "$to", newJString(To))
  add(query_568266, "$apply", newJString(Apply))
  add(query_568266, "$filter", newJString(Filter))
  result = call_568264.call(path_568265, query_568266, nil, nil, nil)

var policyEventsListQueryResultsForResource* = Call_PolicyEventsListQueryResultsForResource_568250(
    name: "policyEventsListQueryResultsForResource", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForResource_568251, base: "",
    url: url_PolicyEventsListQueryResultsForResource_568252,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
