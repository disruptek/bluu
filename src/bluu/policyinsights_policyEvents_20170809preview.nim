
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  ##                            : The namespace for Microsoft Management resource provider; only "Microsoft.Management" is allowed.
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
  Call_PolicyEventsListQueryResultsForResourceGroup_593999 = ref object of OpenApiRestCall_593425
proc url_PolicyEventsListQueryResultsForResourceGroup_594001(protocol: Scheme;
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

proc validate_PolicyEventsListQueryResultsForResourceGroup_594000(path: JsonNode;
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
  var valid_594002 = path.getOrDefault("resourceGroupName")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "resourceGroupName", valid_594002
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
  var valid_594005 = query.getOrDefault("$orderby")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "$orderby", valid_594005
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594006 = query.getOrDefault("api-version")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "api-version", valid_594006
  var valid_594007 = query.getOrDefault("$from")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "$from", valid_594007
  var valid_594008 = query.getOrDefault("$top")
  valid_594008 = validateParameter(valid_594008, JInt, required = false, default = nil)
  if valid_594008 != nil:
    section.add "$top", valid_594008
  var valid_594009 = query.getOrDefault("$select")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "$select", valid_594009
  var valid_594010 = query.getOrDefault("$to")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "$to", valid_594010
  var valid_594011 = query.getOrDefault("$apply")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "$apply", valid_594011
  var valid_594012 = query.getOrDefault("$filter")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "$filter", valid_594012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594013: Call_PolicyEventsListQueryResultsForResourceGroup_593999;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resources under the resource group.
  ## 
  let valid = call_594013.validator(path, query, header, formData, body)
  let scheme = call_594013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594013.url(scheme.get, call_594013.host, call_594013.base,
                         call_594013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594013, url, valid)

proc call*(call_594014: Call_PolicyEventsListQueryResultsForResourceGroup_593999;
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
  var path_594015 = newJObject()
  var query_594016 = newJObject()
  add(query_594016, "$orderby", newJString(Orderby))
  add(path_594015, "resourceGroupName", newJString(resourceGroupName))
  add(query_594016, "api-version", newJString(apiVersion))
  add(query_594016, "$from", newJString(From))
  add(path_594015, "policyEventsResource", newJString(policyEventsResource))
  add(path_594015, "subscriptionId", newJString(subscriptionId))
  add(query_594016, "$top", newJInt(Top))
  add(query_594016, "$select", newJString(Select))
  add(query_594016, "$to", newJString(To))
  add(query_594016, "$apply", newJString(Apply))
  add(query_594016, "$filter", newJString(Filter))
  result = call_594014.call(path_594015, query_594016, nil, nil, nil)

var policyEventsListQueryResultsForResourceGroup* = Call_PolicyEventsListQueryResultsForResourceGroup_593999(
    name: "policyEventsListQueryResultsForResourceGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForResourceGroup_594000,
    base: "", url: url_PolicyEventsListQueryResultsForResourceGroup_594001,
    schemes: {Scheme.Https})
type
  Call_PolicyEventsListQueryResultsForResource_594017 = ref object of OpenApiRestCall_593425
proc url_PolicyEventsListQueryResultsForResource_594019(protocol: Scheme;
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

proc validate_PolicyEventsListQueryResultsForResource_594018(path: JsonNode;
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
  var valid_594020 = path.getOrDefault("policyEventsResource")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = newJString("default"))
  if valid_594020 != nil:
    section.add "policyEventsResource", valid_594020
  var valid_594021 = path.getOrDefault("resourceId")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "resourceId", valid_594021
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
  var valid_594022 = query.getOrDefault("$orderby")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "$orderby", valid_594022
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594023 = query.getOrDefault("api-version")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "api-version", valid_594023
  var valid_594024 = query.getOrDefault("$from")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "$from", valid_594024
  var valid_594025 = query.getOrDefault("$top")
  valid_594025 = validateParameter(valid_594025, JInt, required = false, default = nil)
  if valid_594025 != nil:
    section.add "$top", valid_594025
  var valid_594026 = query.getOrDefault("$select")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "$select", valid_594026
  var valid_594027 = query.getOrDefault("$to")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "$to", valid_594027
  var valid_594028 = query.getOrDefault("$apply")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "$apply", valid_594028
  var valid_594029 = query.getOrDefault("$filter")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "$filter", valid_594029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594030: Call_PolicyEventsListQueryResultsForResource_594017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy events for the resource.
  ## 
  let valid = call_594030.validator(path, query, header, formData, body)
  let scheme = call_594030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594030.url(scheme.get, call_594030.host, call_594030.base,
                         call_594030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594030, url, valid)

proc call*(call_594031: Call_PolicyEventsListQueryResultsForResource_594017;
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
  var path_594032 = newJObject()
  var query_594033 = newJObject()
  add(query_594033, "$orderby", newJString(Orderby))
  add(query_594033, "api-version", newJString(apiVersion))
  add(query_594033, "$from", newJString(From))
  add(path_594032, "policyEventsResource", newJString(policyEventsResource))
  add(query_594033, "$top", newJInt(Top))
  add(query_594033, "$select", newJString(Select))
  add(path_594032, "resourceId", newJString(resourceId))
  add(query_594033, "$to", newJString(To))
  add(query_594033, "$apply", newJString(Apply))
  add(query_594033, "$filter", newJString(Filter))
  result = call_594031.call(path_594032, query_594033, nil, nil, nil)

var policyEventsListQueryResultsForResource* = Call_PolicyEventsListQueryResultsForResource_594017(
    name: "policyEventsListQueryResultsForResource", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/policyEvents/{policyEventsResource}/queryResults",
    validator: validate_PolicyEventsListQueryResultsForResource_594018, base: "",
    url: url_PolicyEventsListQueryResultsForResource_594019,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
