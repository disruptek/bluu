
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
  macServiceName = "policyinsights-policyEvents"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicyEventsListQueryResultsForManagementGroup_593647 = ref object of OpenApiRestCall_593425
proc url_PolicyEventsListQueryResultsForManagementGroup_593649(protocol: Scheme;
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

proc validate_PolicyEventsListQueryResultsForManagementGroup_593648(
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
  var valid_593823 = path.getOrDefault("managementGroupName")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "managementGroupName", valid_593823
  var valid_593837 = path.getOrDefault("managementGroupsNamespace")
  valid_593837 = validateParameter(valid_593837, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_593837 != nil:
    section.add "managementGroupsNamespace", valid_593837
  var valid_593838 = path.getOrDefault("policyEventsResource")
  valid_593838 = validateParameter(valid_593838, JString, required = true,
                                 default = newJString("default"))
  if valid_593838 != nil:
    section.add "policyEventsResource", valid_593838
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
  var valid_593839 = query.getOrDefault("$orderby")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "$orderby", valid_593839
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593840 = query.getOrDefault("api-version")
  valid_593840 = validateParameter(valid_593840, JString, required = true,
                                 default = nil)
  if valid_593840 != nil:
    section.add "api-version", valid_593840
  var valid_593841 = query.getOrDefault("$from")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = nil)
  if valid_593841 != nil:
    section.add "$from", valid_593841
  var valid_593842 = query.getOrDefault("$top")
  valid_593842 = validateParameter(valid_593842, JInt, required = false, default = nil)
  if valid_593842 != nil:
    section.add "$top", valid_593842
  var valid_593843 = query.getOrDefault("$select")
  valid_593843 = validateParameter(valid_593843, JString, required = false,
                                 default = nil)
  if valid_593843 != nil:
    section.add "$select", valid_593843
  var valid_593844 = query.getOrDefault("$to")
  valid_593844 = validateParameter(valid_593844, JString, required = false,
                                 default = nil)
  if valid_593844 != nil:
    section.add "$to", valid_593844
  var valid_593845 = query.getOrDefault("$apply")
  valid_593845 = validateParameter(valid_593845, JString, required = false,
                                 default = nil)
  if valid_593845 != nil:
    section.add "$apply", valid_593845
  var valid_593846 = query.getOrDefault("$filter")
  valid_593846 = validateParameter(valid_593846, JString, required = false,
                                 default = nil)
  if valid_593846 != nil:
    section.add "$filter", valid_593846
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593869: Call_PolicyEventsListQueryResultsForManagementGroup_593647;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resources under the management group.
  ## 
  let valid = call_593869.validator(path, query, header, formData, body)
  let scheme = call_593869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593869.url(scheme.get, call_593869.host, call_593869.base,
                         call_593869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593869, url, valid)

proc call*(call_593940: Call_PolicyEventsListQueryResultsForManagementGroup_593647;
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
  var path_593941 = newJObject()
  var query_593943 = newJObject()
  add(path_593941, "managementGroupName", newJString(managementGroupName))
  add(path_593941, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_593943, "$orderby", newJString(Orderby))
  add(query_593943, "api-version", newJString(apiVersion))
  add(query_593943, "$from", newJString(From))
  add(path_593941, "policyEventsResource", newJString(policyEventsResource))
  add(query_593943, "$top", newJInt(Top))
  add(query_593943, "$select", newJString(Select))
  add(query_593943, "$to", newJString(To))
  add(query_593943, "$apply", newJString(Apply))
  add(query_593943, "$filter", newJString(Filter))
  result = call_593940.call(path_593941, query_593943, nil, nil, nil)

var policyEventsListQueryResultsForManagementGroup* = Call_PolicyEventsListQueryResultsForManagementGroup_593647(
    name: "policyEventsListQueryResultsForManagementGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForManagementGroup_593648,
    base: "", url: url_PolicyEventsListQueryResultsForManagementGroup_593649,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForSubscription_593982 = ref object of OpenApiRestCall_593425
proc url_PolicyEventsListQueryResultsForSubscription_593984(protocol: Scheme;
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

proc validate_PolicyEventsListQueryResultsForSubscription_593983(path: JsonNode;
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
  var valid_593985 = path.getOrDefault("policyEventsResource")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = newJString("default"))
  if valid_593985 != nil:
    section.add "policyEventsResource", valid_593985
  var valid_593986 = path.getOrDefault("subscriptionId")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "subscriptionId", valid_593986
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
  var valid_593987 = query.getOrDefault("$orderby")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "$orderby", valid_593987
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593988 = query.getOrDefault("api-version")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "api-version", valid_593988
  var valid_593989 = query.getOrDefault("$from")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "$from", valid_593989
  var valid_593990 = query.getOrDefault("$top")
  valid_593990 = validateParameter(valid_593990, JInt, required = false, default = nil)
  if valid_593990 != nil:
    section.add "$top", valid_593990
  var valid_593991 = query.getOrDefault("$select")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "$select", valid_593991
  var valid_593992 = query.getOrDefault("$to")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "$to", valid_593992
  var valid_593993 = query.getOrDefault("$apply")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "$apply", valid_593993
  var valid_593994 = query.getOrDefault("$filter")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "$filter", valid_593994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593995: Call_PolicyEventsListQueryResultsForSubscription_593982;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resources under the subscription.
  ## 
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_PolicyEventsListQueryResultsForSubscription_593982;
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
  var path_593997 = newJObject()
  var query_593998 = newJObject()
  add(query_593998, "$orderby", newJString(Orderby))
  add(query_593998, "api-version", newJString(apiVersion))
  add(query_593998, "$from", newJString(From))
  add(path_593997, "policyEventsResource", newJString(policyEventsResource))
  add(path_593997, "subscriptionId", newJString(subscriptionId))
  add(query_593998, "$top", newJInt(Top))
  add(query_593998, "$select", newJString(Select))
  add(query_593998, "$to", newJString(To))
  add(query_593998, "$apply", newJString(Apply))
  add(query_593998, "$filter", newJString(Filter))
  result = call_593996.call(path_593997, query_593998, nil, nil, nil)

var policyEventsListQueryResultsForSubscription* = Call_PolicyEventsListQueryResultsForSubscription_593982(
    name: "policyEventsListQueryResultsForSubscription",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForSubscription_593983,
    base: "", url: url_PolicyEventsListQueryResultsForSubscription_593984,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_593999 = ref object of OpenApiRestCall_593425
proc url_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_594001(
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

proc validate_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_594000(
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
  var valid_594002 = path.getOrDefault("authorizationNamespace")
  valid_594002 = validateParameter(valid_594002, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_594002 != nil:
    section.add "authorizationNamespace", valid_594002
  var valid_594003 = path.getOrDefault("policyEventsResource")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = newJString("default"))
  if valid_594003 != nil:
    section.add "policyEventsResource", valid_594003
  var valid_594004 = path.getOrDefault("subscriptionId")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "subscriptionId", valid_594004
  var valid_594005 = path.getOrDefault("policyAssignmentName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "policyAssignmentName", valid_594005
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
  var valid_594006 = query.getOrDefault("$orderby")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "$orderby", valid_594006
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594007 = query.getOrDefault("api-version")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "api-version", valid_594007
  var valid_594008 = query.getOrDefault("$from")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "$from", valid_594008
  var valid_594009 = query.getOrDefault("$top")
  valid_594009 = validateParameter(valid_594009, JInt, required = false, default = nil)
  if valid_594009 != nil:
    section.add "$top", valid_594009
  var valid_594010 = query.getOrDefault("$select")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "$select", valid_594010
  var valid_594011 = query.getOrDefault("$to")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "$to", valid_594011
  var valid_594012 = query.getOrDefault("$apply")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "$apply", valid_594012
  var valid_594013 = query.getOrDefault("$filter")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "$filter", valid_594013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594014: Call_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_593999;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the subscription level policy assignment.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_593999;
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
  var path_594016 = newJObject()
  var query_594017 = newJObject()
  add(query_594017, "$orderby", newJString(Orderby))
  add(path_594016, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_594017, "api-version", newJString(apiVersion))
  add(query_594017, "$from", newJString(From))
  add(path_594016, "policyEventsResource", newJString(policyEventsResource))
  add(path_594016, "subscriptionId", newJString(subscriptionId))
  add(query_594017, "$top", newJInt(Top))
  add(query_594017, "$select", newJString(Select))
  add(path_594016, "policyAssignmentName", newJString(policyAssignmentName))
  add(query_594017, "$to", newJString(To))
  add(query_594017, "$apply", newJString(Apply))
  add(query_594017, "$filter", newJString(Filter))
  result = call_594015.call(path_594016, query_594017, nil, nil, nil)

var policyEventsListQueryResultsForSubscriptionLevelPolicyAssignment* = Call_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_593999(
    name: "policyEventsListQueryResultsForSubscriptionLevelPolicyAssignment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policyAssignments/{policyAssignmentName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults", validator: validate_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_594000,
    base: "",
    url: url_PolicyEventsListQueryResultsForSubscriptionLevelPolicyAssignment_594001,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForPolicyDefinition_594018 = ref object of OpenApiRestCall_593425
proc url_PolicyEventsListQueryResultsForPolicyDefinition_594020(protocol: Scheme;
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

proc validate_PolicyEventsListQueryResultsForPolicyDefinition_594019(
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
  var valid_594021 = path.getOrDefault("authorizationNamespace")
  valid_594021 = validateParameter(valid_594021, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_594021 != nil:
    section.add "authorizationNamespace", valid_594021
  var valid_594022 = path.getOrDefault("policyEventsResource")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = newJString("default"))
  if valid_594022 != nil:
    section.add "policyEventsResource", valid_594022
  var valid_594023 = path.getOrDefault("subscriptionId")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "subscriptionId", valid_594023
  var valid_594024 = path.getOrDefault("policyDefinitionName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "policyDefinitionName", valid_594024
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
  var valid_594025 = query.getOrDefault("$orderby")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "$orderby", valid_594025
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594026 = query.getOrDefault("api-version")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "api-version", valid_594026
  var valid_594027 = query.getOrDefault("$from")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "$from", valid_594027
  var valid_594028 = query.getOrDefault("$top")
  valid_594028 = validateParameter(valid_594028, JInt, required = false, default = nil)
  if valid_594028 != nil:
    section.add "$top", valid_594028
  var valid_594029 = query.getOrDefault("$select")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "$select", valid_594029
  var valid_594030 = query.getOrDefault("$to")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "$to", valid_594030
  var valid_594031 = query.getOrDefault("$apply")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "$apply", valid_594031
  var valid_594032 = query.getOrDefault("$filter")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "$filter", valid_594032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594033: Call_PolicyEventsListQueryResultsForPolicyDefinition_594018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the subscription level policy definition.
  ## 
  let valid = call_594033.validator(path, query, header, formData, body)
  let scheme = call_594033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594033.url(scheme.get, call_594033.host, call_594033.base,
                         call_594033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594033, url, valid)

proc call*(call_594034: Call_PolicyEventsListQueryResultsForPolicyDefinition_594018;
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
  var path_594035 = newJObject()
  var query_594036 = newJObject()
  add(query_594036, "$orderby", newJString(Orderby))
  add(path_594035, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_594036, "api-version", newJString(apiVersion))
  add(query_594036, "$from", newJString(From))
  add(path_594035, "policyEventsResource", newJString(policyEventsResource))
  add(path_594035, "subscriptionId", newJString(subscriptionId))
  add(query_594036, "$top", newJInt(Top))
  add(query_594036, "$select", newJString(Select))
  add(query_594036, "$to", newJString(To))
  add(query_594036, "$apply", newJString(Apply))
  add(path_594035, "policyDefinitionName", newJString(policyDefinitionName))
  add(query_594036, "$filter", newJString(Filter))
  result = call_594034.call(path_594035, query_594036, nil, nil, nil)

var policyEventsListQueryResultsForPolicyDefinition* = Call_PolicyEventsListQueryResultsForPolicyDefinition_594018(
    name: "policyEventsListQueryResultsForPolicyDefinition",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policyDefinitions/{policyDefinitionName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForPolicyDefinition_594019,
    base: "", url: url_PolicyEventsListQueryResultsForPolicyDefinition_594020,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForPolicySetDefinition_594037 = ref object of OpenApiRestCall_593425
proc url_PolicyEventsListQueryResultsForPolicySetDefinition_594039(
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

proc validate_PolicyEventsListQueryResultsForPolicySetDefinition_594038(
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
  var valid_594040 = path.getOrDefault("policySetDefinitionName")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "policySetDefinitionName", valid_594040
  var valid_594041 = path.getOrDefault("authorizationNamespace")
  valid_594041 = validateParameter(valid_594041, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_594041 != nil:
    section.add "authorizationNamespace", valid_594041
  var valid_594042 = path.getOrDefault("policyEventsResource")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = newJString("default"))
  if valid_594042 != nil:
    section.add "policyEventsResource", valid_594042
  var valid_594043 = path.getOrDefault("subscriptionId")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "subscriptionId", valid_594043
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
  var valid_594044 = query.getOrDefault("$orderby")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "$orderby", valid_594044
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594045 = query.getOrDefault("api-version")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "api-version", valid_594045
  var valid_594046 = query.getOrDefault("$from")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "$from", valid_594046
  var valid_594047 = query.getOrDefault("$top")
  valid_594047 = validateParameter(valid_594047, JInt, required = false, default = nil)
  if valid_594047 != nil:
    section.add "$top", valid_594047
  var valid_594048 = query.getOrDefault("$select")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "$select", valid_594048
  var valid_594049 = query.getOrDefault("$to")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "$to", valid_594049
  var valid_594050 = query.getOrDefault("$apply")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "$apply", valid_594050
  var valid_594051 = query.getOrDefault("$filter")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "$filter", valid_594051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594052: Call_PolicyEventsListQueryResultsForPolicySetDefinition_594037;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the subscription level policy set definition.
  ## 
  let valid = call_594052.validator(path, query, header, formData, body)
  let scheme = call_594052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594052.url(scheme.get, call_594052.host, call_594052.base,
                         call_594052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594052, url, valid)

proc call*(call_594053: Call_PolicyEventsListQueryResultsForPolicySetDefinition_594037;
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
  var path_594054 = newJObject()
  var query_594055 = newJObject()
  add(path_594054, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_594055, "$orderby", newJString(Orderby))
  add(path_594054, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_594055, "api-version", newJString(apiVersion))
  add(query_594055, "$from", newJString(From))
  add(path_594054, "policyEventsResource", newJString(policyEventsResource))
  add(path_594054, "subscriptionId", newJString(subscriptionId))
  add(query_594055, "$top", newJInt(Top))
  add(query_594055, "$select", newJString(Select))
  add(query_594055, "$to", newJString(To))
  add(query_594055, "$apply", newJString(Apply))
  add(query_594055, "$filter", newJString(Filter))
  result = call_594053.call(path_594054, query_594055, nil, nil, nil)

var policyEventsListQueryResultsForPolicySetDefinition* = Call_PolicyEventsListQueryResultsForPolicySetDefinition_594037(
    name: "policyEventsListQueryResultsForPolicySetDefinition",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policySetDefinitions/{policySetDefinitionName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForPolicySetDefinition_594038,
    base: "", url: url_PolicyEventsListQueryResultsForPolicySetDefinition_594039,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForResourceGroup_594056 = ref object of OpenApiRestCall_593425
proc url_PolicyEventsListQueryResultsForResourceGroup_594058(protocol: Scheme;
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

proc validate_PolicyEventsListQueryResultsForResourceGroup_594057(path: JsonNode;
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
  var valid_594059 = path.getOrDefault("resourceGroupName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "resourceGroupName", valid_594059
  var valid_594060 = path.getOrDefault("policyEventsResource")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = newJString("default"))
  if valid_594060 != nil:
    section.add "policyEventsResource", valid_594060
  var valid_594061 = path.getOrDefault("subscriptionId")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "subscriptionId", valid_594061
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
  var valid_594062 = query.getOrDefault("$orderby")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "$orderby", valid_594062
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594063 = query.getOrDefault("api-version")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "api-version", valid_594063
  var valid_594064 = query.getOrDefault("$from")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "$from", valid_594064
  var valid_594065 = query.getOrDefault("$top")
  valid_594065 = validateParameter(valid_594065, JInt, required = false, default = nil)
  if valid_594065 != nil:
    section.add "$top", valid_594065
  var valid_594066 = query.getOrDefault("$select")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "$select", valid_594066
  var valid_594067 = query.getOrDefault("$to")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "$to", valid_594067
  var valid_594068 = query.getOrDefault("$apply")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "$apply", valid_594068
  var valid_594069 = query.getOrDefault("$filter")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "$filter", valid_594069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594070: Call_PolicyEventsListQueryResultsForResourceGroup_594056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resources under the resource group.
  ## 
  let valid = call_594070.validator(path, query, header, formData, body)
  let scheme = call_594070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594070.url(scheme.get, call_594070.host, call_594070.base,
                         call_594070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594070, url, valid)

proc call*(call_594071: Call_PolicyEventsListQueryResultsForResourceGroup_594056;
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
  var path_594072 = newJObject()
  var query_594073 = newJObject()
  add(query_594073, "$orderby", newJString(Orderby))
  add(path_594072, "resourceGroupName", newJString(resourceGroupName))
  add(query_594073, "api-version", newJString(apiVersion))
  add(query_594073, "$from", newJString(From))
  add(path_594072, "policyEventsResource", newJString(policyEventsResource))
  add(path_594072, "subscriptionId", newJString(subscriptionId))
  add(query_594073, "$top", newJInt(Top))
  add(query_594073, "$select", newJString(Select))
  add(query_594073, "$to", newJString(To))
  add(query_594073, "$apply", newJString(Apply))
  add(query_594073, "$filter", newJString(Filter))
  result = call_594071.call(path_594072, query_594073, nil, nil, nil)

var policyEventsListQueryResultsForResourceGroup* = Call_PolicyEventsListQueryResultsForResourceGroup_594056(
    name: "policyEventsListQueryResultsForResourceGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForResourceGroup_594057,
    base: "", url: url_PolicyEventsListQueryResultsForResourceGroup_594058,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_594074 = ref object of OpenApiRestCall_593425
proc url_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_594076(
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

proc validate_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_594075(
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
  var valid_594077 = path.getOrDefault("resourceGroupName")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "resourceGroupName", valid_594077
  var valid_594078 = path.getOrDefault("authorizationNamespace")
  valid_594078 = validateParameter(valid_594078, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_594078 != nil:
    section.add "authorizationNamespace", valid_594078
  var valid_594079 = path.getOrDefault("policyEventsResource")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = newJString("default"))
  if valid_594079 != nil:
    section.add "policyEventsResource", valid_594079
  var valid_594080 = path.getOrDefault("subscriptionId")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "subscriptionId", valid_594080
  var valid_594081 = path.getOrDefault("policyAssignmentName")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "policyAssignmentName", valid_594081
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
  var valid_594082 = query.getOrDefault("$orderby")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "$orderby", valid_594082
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594083 = query.getOrDefault("api-version")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "api-version", valid_594083
  var valid_594084 = query.getOrDefault("$from")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "$from", valid_594084
  var valid_594085 = query.getOrDefault("$top")
  valid_594085 = validateParameter(valid_594085, JInt, required = false, default = nil)
  if valid_594085 != nil:
    section.add "$top", valid_594085
  var valid_594086 = query.getOrDefault("$select")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "$select", valid_594086
  var valid_594087 = query.getOrDefault("$to")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "$to", valid_594087
  var valid_594088 = query.getOrDefault("$apply")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "$apply", valid_594088
  var valid_594089 = query.getOrDefault("$filter")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "$filter", valid_594089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594090: Call_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_594074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resource group level policy assignment.
  ## 
  let valid = call_594090.validator(path, query, header, formData, body)
  let scheme = call_594090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594090.url(scheme.get, call_594090.host, call_594090.base,
                         call_594090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594090, url, valid)

proc call*(call_594091: Call_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_594074;
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
  var path_594092 = newJObject()
  var query_594093 = newJObject()
  add(query_594093, "$orderby", newJString(Orderby))
  add(path_594092, "resourceGroupName", newJString(resourceGroupName))
  add(path_594092, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_594093, "api-version", newJString(apiVersion))
  add(query_594093, "$from", newJString(From))
  add(path_594092, "policyEventsResource", newJString(policyEventsResource))
  add(path_594092, "subscriptionId", newJString(subscriptionId))
  add(query_594093, "$top", newJInt(Top))
  add(query_594093, "$select", newJString(Select))
  add(path_594092, "policyAssignmentName", newJString(policyAssignmentName))
  add(query_594093, "$to", newJString(To))
  add(query_594093, "$apply", newJString(Apply))
  add(query_594093, "$filter", newJString(Filter))
  result = call_594091.call(path_594092, query_594093, nil, nil, nil)

var policyEventsListQueryResultsForResourceGroupLevelPolicyAssignment* = Call_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_594074(
    name: "policyEventsListQueryResultsForResourceGroupLevelPolicyAssignment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{authorizationNamespace}/policyAssignments/{policyAssignmentName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults", validator: validate_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_594075,
    base: "",
    url: url_PolicyEventsListQueryResultsForResourceGroupLevelPolicyAssignment_594076,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForResource_594094 = ref object of OpenApiRestCall_593425
proc url_PolicyEventsListQueryResultsForResource_594096(protocol: Scheme;
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

proc validate_PolicyEventsListQueryResultsForResource_594095(path: JsonNode;
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
  var valid_594097 = path.getOrDefault("policyEventsResource")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = newJString("default"))
  if valid_594097 != nil:
    section.add "policyEventsResource", valid_594097
  var valid_594098 = path.getOrDefault("resourceId")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "resourceId", valid_594098
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
  var valid_594099 = query.getOrDefault("$orderby")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "$orderby", valid_594099
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594100 = query.getOrDefault("api-version")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "api-version", valid_594100
  var valid_594101 = query.getOrDefault("$from")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "$from", valid_594101
  var valid_594102 = query.getOrDefault("$top")
  valid_594102 = validateParameter(valid_594102, JInt, required = false, default = nil)
  if valid_594102 != nil:
    section.add "$top", valid_594102
  var valid_594103 = query.getOrDefault("$select")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "$select", valid_594103
  var valid_594104 = query.getOrDefault("$to")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "$to", valid_594104
  var valid_594105 = query.getOrDefault("$apply")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "$apply", valid_594105
  var valid_594106 = query.getOrDefault("$filter")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "$filter", valid_594106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594107: Call_PolicyEventsListQueryResultsForResource_594094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resource.
  ## 
  let valid = call_594107.validator(path, query, header, formData, body)
  let scheme = call_594107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594107.url(scheme.get, call_594107.host, call_594107.base,
                         call_594107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594107, url, valid)

proc call*(call_594108: Call_PolicyEventsListQueryResultsForResource_594094;
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
  var path_594109 = newJObject()
  var query_594110 = newJObject()
  add(query_594110, "$orderby", newJString(Orderby))
  add(query_594110, "api-version", newJString(apiVersion))
  add(query_594110, "$from", newJString(From))
  add(path_594109, "policyEventsResource", newJString(policyEventsResource))
  add(query_594110, "$top", newJInt(Top))
  add(query_594110, "$select", newJString(Select))
  add(path_594109, "resourceId", newJString(resourceId))
  add(query_594110, "$to", newJString(To))
  add(query_594110, "$apply", newJString(Apply))
  add(query_594110, "$filter", newJString(Filter))
  result = call_594108.call(path_594109, query_594110, nil, nil, nil)

var policyEventsListQueryResultsForResource* = Call_PolicyEventsListQueryResultsForResource_594094(
    name: "policyEventsListQueryResultsForResource", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForResource_594095, base: "",
    url: url_PolicyEventsListQueryResultsForResource_594096,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsGetMetadata_594111 = ref object of OpenApiRestCall_593425
proc url_PolicyEventsGetMetadata_594113(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyEventsGetMetadata_594112(path: JsonNode; query: JsonNode;
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
  var valid_594114 = path.getOrDefault("scope")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "scope", valid_594114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594115 = query.getOrDefault("api-version")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "api-version", valid_594115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594116: Call_PolicyEventsGetMetadata_594111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets OData metadata XML document.
  ## 
  let valid = call_594116.validator(path, query, header, formData, body)
  let scheme = call_594116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594116.url(scheme.get, call_594116.host, call_594116.base,
                         call_594116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594116, url, valid)

proc call*(call_594117: Call_PolicyEventsGetMetadata_594111; apiVersion: string;
          scope: string): Recallable =
  ## policyEventsGetMetadata
  ## Gets OData metadata XML document.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   scope: string (required)
  ##        : A valid scope, i.e. management group, subscription, resource group, or resource ID. Scope used has no effect on metadata returned.
  var path_594118 = newJObject()
  var query_594119 = newJObject()
  add(query_594119, "api-version", newJString(apiVersion))
  add(path_594118, "scope", newJString(scope))
  result = call_594117.call(path_594118, query_594119, nil, nil, nil)

var policyEventsGetMetadata* = Call_PolicyEventsGetMetadata_594111(
    name: "policyEventsGetMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.PolicyInsights/policyEvents/$metadata",
    validator: validate_PolicyEventsGetMetadata_594112, base: "",
    url: url_PolicyEventsGetMetadata_594113, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
