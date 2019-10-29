
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: PolicyStatesClient
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
  macServiceName = "policyinsights-policyStates"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563778 = ref object of OpenApiRestCall_563556
proc url_OperationsList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563779(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists available operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563941 = query.getOrDefault("api-version")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "api-version", valid_563941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563964: Call_OperationsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations.
  ## 
  let valid = call_563964.validator(path, query, header, formData, body)
  let scheme = call_563964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563964.url(scheme.get, call_563964.host, call_563964.base,
                         call_563964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563964, url, valid)

proc call*(call_564035: Call_OperationsList_563778; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  var query_564036 = newJObject()
  add(query_564036, "api-version", newJString(apiVersion))
  result = call_564035.call(nil, query_564036, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.PolicyInsights/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForManagementGroup_564076 = ref object of OpenApiRestCall_563556
proc url_PolicyStatesListQueryResultsForManagementGroup_564078(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupsNamespace" in path,
        "`managementGroupsNamespace` is a required path parameter"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "policyStatesResource" in path,
        "`policyStatesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "managementGroupsNamespace"),
               (kind: ConstantSegment, value: "/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesListQueryResultsForManagementGroup_564077(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy states for the resources under the management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupName: JString (required)
  ##                      : Management group name.
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupName` field"
  var valid_564094 = path.getOrDefault("managementGroupName")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "managementGroupName", valid_564094
  var valid_564108 = path.getOrDefault("policyStatesResource")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = newJString("default"))
  if valid_564108 != nil:
    section.add "policyStatesResource", valid_564108
  var valid_564109 = path.getOrDefault("managementGroupsNamespace")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_564109 != nil:
    section.add "managementGroupsNamespace", valid_564109
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
  var valid_564110 = query.getOrDefault("api-version")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "api-version", valid_564110
  var valid_564111 = query.getOrDefault("$top")
  valid_564111 = validateParameter(valid_564111, JInt, required = false, default = nil)
  if valid_564111 != nil:
    section.add "$top", valid_564111
  var valid_564112 = query.getOrDefault("$select")
  valid_564112 = validateParameter(valid_564112, JString, required = false,
                                 default = nil)
  if valid_564112 != nil:
    section.add "$select", valid_564112
  var valid_564113 = query.getOrDefault("$to")
  valid_564113 = validateParameter(valid_564113, JString, required = false,
                                 default = nil)
  if valid_564113 != nil:
    section.add "$to", valid_564113
  var valid_564114 = query.getOrDefault("$orderby")
  valid_564114 = validateParameter(valid_564114, JString, required = false,
                                 default = nil)
  if valid_564114 != nil:
    section.add "$orderby", valid_564114
  var valid_564115 = query.getOrDefault("$apply")
  valid_564115 = validateParameter(valid_564115, JString, required = false,
                                 default = nil)
  if valid_564115 != nil:
    section.add "$apply", valid_564115
  var valid_564116 = query.getOrDefault("$filter")
  valid_564116 = validateParameter(valid_564116, JString, required = false,
                                 default = nil)
  if valid_564116 != nil:
    section.add "$filter", valid_564116
  var valid_564117 = query.getOrDefault("$from")
  valid_564117 = validateParameter(valid_564117, JString, required = false,
                                 default = nil)
  if valid_564117 != nil:
    section.add "$from", valid_564117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564118: Call_PolicyStatesListQueryResultsForManagementGroup_564076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resources under the management group.
  ## 
  let valid = call_564118.validator(path, query, header, formData, body)
  let scheme = call_564118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564118.url(scheme.get, call_564118.host, call_564118.base,
                         call_564118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564118, url, valid)

proc call*(call_564119: Call_PolicyStatesListQueryResultsForManagementGroup_564076;
          apiVersion: string; managementGroupName: string; Top: int = 0;
          Select: string = ""; policyStatesResource: string = "default";
          To: string = ""; Orderby: string = "";
          managementGroupsNamespace: string = "Microsoft.Management";
          Apply: string = ""; Filter: string = ""; From: string = ""): Recallable =
  ## policyStatesListQueryResultsForManagementGroup
  ## Queries policy states for the resources under the management group.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   managementGroupName: string (required)
  ##                      : Management group name.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
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
  var path_564120 = newJObject()
  var query_564121 = newJObject()
  add(query_564121, "api-version", newJString(apiVersion))
  add(path_564120, "managementGroupName", newJString(managementGroupName))
  add(query_564121, "$top", newJInt(Top))
  add(query_564121, "$select", newJString(Select))
  add(path_564120, "policyStatesResource", newJString(policyStatesResource))
  add(query_564121, "$to", newJString(To))
  add(query_564121, "$orderby", newJString(Orderby))
  add(path_564120, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_564121, "$apply", newJString(Apply))
  add(query_564121, "$filter", newJString(Filter))
  add(query_564121, "$from", newJString(From))
  result = call_564119.call(path_564120, query_564121, nil, nil, nil)

var policyStatesListQueryResultsForManagementGroup* = Call_PolicyStatesListQueryResultsForManagementGroup_564076(
    name: "policyStatesListQueryResultsForManagementGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForManagementGroup_564077,
    base: "", url: url_PolicyStatesListQueryResultsForManagementGroup_564078,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForManagementGroup_564122 = ref object of OpenApiRestCall_563556
proc url_PolicyStatesSummarizeForManagementGroup_564124(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupsNamespace" in path,
        "`managementGroupsNamespace` is a required path parameter"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "policyStatesSummaryResource" in path,
        "`policyStatesSummaryResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "managementGroupsNamespace"),
               (kind: ConstantSegment, value: "/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesSummaryResource"),
               (kind: ConstantSegment, value: "/summarize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesSummarizeForManagementGroup_564123(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Summarizes policy states for the resources under the management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupName: JString (required)
  ##                      : Management group name.
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   policyStatesSummaryResource: JString (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupName` field"
  var valid_564125 = path.getOrDefault("managementGroupName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "managementGroupName", valid_564125
  var valid_564126 = path.getOrDefault("managementGroupsNamespace")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_564126 != nil:
    section.add "managementGroupsNamespace", valid_564126
  var valid_564127 = path.getOrDefault("policyStatesSummaryResource")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = newJString("latest"))
  if valid_564127 != nil:
    section.add "policyStatesSummaryResource", valid_564127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $filter: JString
  ##          : OData filter expression.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564128 = query.getOrDefault("api-version")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "api-version", valid_564128
  var valid_564129 = query.getOrDefault("$top")
  valid_564129 = validateParameter(valid_564129, JInt, required = false, default = nil)
  if valid_564129 != nil:
    section.add "$top", valid_564129
  var valid_564130 = query.getOrDefault("$to")
  valid_564130 = validateParameter(valid_564130, JString, required = false,
                                 default = nil)
  if valid_564130 != nil:
    section.add "$to", valid_564130
  var valid_564131 = query.getOrDefault("$filter")
  valid_564131 = validateParameter(valid_564131, JString, required = false,
                                 default = nil)
  if valid_564131 != nil:
    section.add "$filter", valid_564131
  var valid_564132 = query.getOrDefault("$from")
  valid_564132 = validateParameter(valid_564132, JString, required = false,
                                 default = nil)
  if valid_564132 != nil:
    section.add "$from", valid_564132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564133: Call_PolicyStatesSummarizeForManagementGroup_564122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the resources under the management group.
  ## 
  let valid = call_564133.validator(path, query, header, formData, body)
  let scheme = call_564133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564133.url(scheme.get, call_564133.host, call_564133.base,
                         call_564133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564133, url, valid)

proc call*(call_564134: Call_PolicyStatesSummarizeForManagementGroup_564122;
          apiVersion: string; managementGroupName: string; Top: int = 0;
          To: string = "";
          managementGroupsNamespace: string = "Microsoft.Management";
          Filter: string = ""; From: string = "";
          policyStatesSummaryResource: string = "latest"): Recallable =
  ## policyStatesSummarizeForManagementGroup
  ## Summarizes policy states for the resources under the management group.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   managementGroupName: string (required)
  ##                      : Management group name.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   Filter: string
  ##         : OData filter expression.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   policyStatesSummaryResource: string (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  var path_564135 = newJObject()
  var query_564136 = newJObject()
  add(query_564136, "api-version", newJString(apiVersion))
  add(path_564135, "managementGroupName", newJString(managementGroupName))
  add(query_564136, "$top", newJInt(Top))
  add(query_564136, "$to", newJString(To))
  add(path_564135, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_564136, "$filter", newJString(Filter))
  add(query_564136, "$from", newJString(From))
  add(path_564135, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  result = call_564134.call(path_564135, query_564136, nil, nil, nil)

var policyStatesSummarizeForManagementGroup* = Call_PolicyStatesSummarizeForManagementGroup_564122(
    name: "policyStatesSummarizeForManagementGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize",
    validator: validate_PolicyStatesSummarizeForManagementGroup_564123, base: "",
    url: url_PolicyStatesSummarizeForManagementGroup_564124,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForSubscription_564137 = ref object of OpenApiRestCall_563556
proc url_PolicyStatesListQueryResultsForSubscription_564139(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "policyStatesResource" in path,
        "`policyStatesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesListQueryResultsForSubscription_564138(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queries policy states for the resources under the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyStatesResource` field"
  var valid_564140 = path.getOrDefault("policyStatesResource")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = newJString("default"))
  if valid_564140 != nil:
    section.add "policyStatesResource", valid_564140
  var valid_564141 = path.getOrDefault("subscriptionId")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "subscriptionId", valid_564141
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
  var valid_564142 = query.getOrDefault("api-version")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "api-version", valid_564142
  var valid_564143 = query.getOrDefault("$top")
  valid_564143 = validateParameter(valid_564143, JInt, required = false, default = nil)
  if valid_564143 != nil:
    section.add "$top", valid_564143
  var valid_564144 = query.getOrDefault("$select")
  valid_564144 = validateParameter(valid_564144, JString, required = false,
                                 default = nil)
  if valid_564144 != nil:
    section.add "$select", valid_564144
  var valid_564145 = query.getOrDefault("$to")
  valid_564145 = validateParameter(valid_564145, JString, required = false,
                                 default = nil)
  if valid_564145 != nil:
    section.add "$to", valid_564145
  var valid_564146 = query.getOrDefault("$orderby")
  valid_564146 = validateParameter(valid_564146, JString, required = false,
                                 default = nil)
  if valid_564146 != nil:
    section.add "$orderby", valid_564146
  var valid_564147 = query.getOrDefault("$apply")
  valid_564147 = validateParameter(valid_564147, JString, required = false,
                                 default = nil)
  if valid_564147 != nil:
    section.add "$apply", valid_564147
  var valid_564148 = query.getOrDefault("$filter")
  valid_564148 = validateParameter(valid_564148, JString, required = false,
                                 default = nil)
  if valid_564148 != nil:
    section.add "$filter", valid_564148
  var valid_564149 = query.getOrDefault("$from")
  valid_564149 = validateParameter(valid_564149, JString, required = false,
                                 default = nil)
  if valid_564149 != nil:
    section.add "$from", valid_564149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564150: Call_PolicyStatesListQueryResultsForSubscription_564137;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resources under the subscription.
  ## 
  let valid = call_564150.validator(path, query, header, formData, body)
  let scheme = call_564150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564150.url(scheme.get, call_564150.host, call_564150.base,
                         call_564150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564150, url, valid)

proc call*(call_564151: Call_PolicyStatesListQueryResultsForSubscription_564137;
          apiVersion: string; subscriptionId: string; Top: int = 0; Select: string = "";
          policyStatesResource: string = "default"; To: string = "";
          Orderby: string = ""; Apply: string = ""; Filter: string = ""; From: string = ""): Recallable =
  ## policyStatesListQueryResultsForSubscription
  ## Queries policy states for the resources under the subscription.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
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
  var path_564152 = newJObject()
  var query_564153 = newJObject()
  add(query_564153, "api-version", newJString(apiVersion))
  add(query_564153, "$top", newJInt(Top))
  add(query_564153, "$select", newJString(Select))
  add(path_564152, "policyStatesResource", newJString(policyStatesResource))
  add(path_564152, "subscriptionId", newJString(subscriptionId))
  add(query_564153, "$to", newJString(To))
  add(query_564153, "$orderby", newJString(Orderby))
  add(query_564153, "$apply", newJString(Apply))
  add(query_564153, "$filter", newJString(Filter))
  add(query_564153, "$from", newJString(From))
  result = call_564151.call(path_564152, query_564153, nil, nil, nil)

var policyStatesListQueryResultsForSubscription* = Call_PolicyStatesListQueryResultsForSubscription_564137(
    name: "policyStatesListQueryResultsForSubscription",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForSubscription_564138,
    base: "", url: url_PolicyStatesListQueryResultsForSubscription_564139,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForSubscription_564154 = ref object of OpenApiRestCall_563556
proc url_PolicyStatesSummarizeForSubscription_564156(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "policyStatesSummaryResource" in path,
        "`policyStatesSummaryResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesSummaryResource"),
               (kind: ConstantSegment, value: "/summarize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesSummarizeForSubscription_564155(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Summarizes policy states for the resources under the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policyStatesSummaryResource: JString (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564157 = path.getOrDefault("subscriptionId")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "subscriptionId", valid_564157
  var valid_564158 = path.getOrDefault("policyStatesSummaryResource")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = newJString("latest"))
  if valid_564158 != nil:
    section.add "policyStatesSummaryResource", valid_564158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $filter: JString
  ##          : OData filter expression.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564159 = query.getOrDefault("api-version")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "api-version", valid_564159
  var valid_564160 = query.getOrDefault("$top")
  valid_564160 = validateParameter(valid_564160, JInt, required = false, default = nil)
  if valid_564160 != nil:
    section.add "$top", valid_564160
  var valid_564161 = query.getOrDefault("$to")
  valid_564161 = validateParameter(valid_564161, JString, required = false,
                                 default = nil)
  if valid_564161 != nil:
    section.add "$to", valid_564161
  var valid_564162 = query.getOrDefault("$filter")
  valid_564162 = validateParameter(valid_564162, JString, required = false,
                                 default = nil)
  if valid_564162 != nil:
    section.add "$filter", valid_564162
  var valid_564163 = query.getOrDefault("$from")
  valid_564163 = validateParameter(valid_564163, JString, required = false,
                                 default = nil)
  if valid_564163 != nil:
    section.add "$from", valid_564163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564164: Call_PolicyStatesSummarizeForSubscription_564154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the resources under the subscription.
  ## 
  let valid = call_564164.validator(path, query, header, formData, body)
  let scheme = call_564164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564164.url(scheme.get, call_564164.host, call_564164.base,
                         call_564164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564164, url, valid)

proc call*(call_564165: Call_PolicyStatesSummarizeForSubscription_564154;
          apiVersion: string; subscriptionId: string; Top: int = 0; To: string = "";
          Filter: string = ""; From: string = "";
          policyStatesSummaryResource: string = "latest"): Recallable =
  ## policyStatesSummarizeForSubscription
  ## Summarizes policy states for the resources under the subscription.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Filter: string
  ##         : OData filter expression.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   policyStatesSummaryResource: string (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  var path_564166 = newJObject()
  var query_564167 = newJObject()
  add(query_564167, "api-version", newJString(apiVersion))
  add(query_564167, "$top", newJInt(Top))
  add(path_564166, "subscriptionId", newJString(subscriptionId))
  add(query_564167, "$to", newJString(To))
  add(query_564167, "$filter", newJString(Filter))
  add(query_564167, "$from", newJString(From))
  add(path_564166, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  result = call_564165.call(path_564166, query_564167, nil, nil, nil)

var policyStatesSummarizeForSubscription* = Call_PolicyStatesSummarizeForSubscription_564154(
    name: "policyStatesSummarizeForSubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize",
    validator: validate_PolicyStatesSummarizeForSubscription_564155, base: "",
    url: url_PolicyStatesSummarizeForSubscription_564156, schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_564168 = ref object of OpenApiRestCall_563556
proc url_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_564170(
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
  assert "policyStatesResource" in path,
        "`policyStatesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "authorizationNamespace"),
               (kind: ConstantSegment, value: "/policyAssignments/"),
               (kind: VariableSegment, value: "policyAssignmentName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_564169(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy states for the subscription level policy assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   policyAssignmentName: JString (required)
  ##                       : Policy assignment name.
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationNamespace` field"
  var valid_564171 = path.getOrDefault("authorizationNamespace")
  valid_564171 = validateParameter(valid_564171, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_564171 != nil:
    section.add "authorizationNamespace", valid_564171
  var valid_564172 = path.getOrDefault("policyAssignmentName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "policyAssignmentName", valid_564172
  var valid_564173 = path.getOrDefault("policyStatesResource")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = newJString("default"))
  if valid_564173 != nil:
    section.add "policyStatesResource", valid_564173
  var valid_564174 = path.getOrDefault("subscriptionId")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "subscriptionId", valid_564174
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
  var valid_564175 = query.getOrDefault("api-version")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "api-version", valid_564175
  var valid_564176 = query.getOrDefault("$top")
  valid_564176 = validateParameter(valid_564176, JInt, required = false, default = nil)
  if valid_564176 != nil:
    section.add "$top", valid_564176
  var valid_564177 = query.getOrDefault("$select")
  valid_564177 = validateParameter(valid_564177, JString, required = false,
                                 default = nil)
  if valid_564177 != nil:
    section.add "$select", valid_564177
  var valid_564178 = query.getOrDefault("$to")
  valid_564178 = validateParameter(valid_564178, JString, required = false,
                                 default = nil)
  if valid_564178 != nil:
    section.add "$to", valid_564178
  var valid_564179 = query.getOrDefault("$orderby")
  valid_564179 = validateParameter(valid_564179, JString, required = false,
                                 default = nil)
  if valid_564179 != nil:
    section.add "$orderby", valid_564179
  var valid_564180 = query.getOrDefault("$apply")
  valid_564180 = validateParameter(valid_564180, JString, required = false,
                                 default = nil)
  if valid_564180 != nil:
    section.add "$apply", valid_564180
  var valid_564181 = query.getOrDefault("$filter")
  valid_564181 = validateParameter(valid_564181, JString, required = false,
                                 default = nil)
  if valid_564181 != nil:
    section.add "$filter", valid_564181
  var valid_564182 = query.getOrDefault("$from")
  valid_564182 = validateParameter(valid_564182, JString, required = false,
                                 default = nil)
  if valid_564182 != nil:
    section.add "$from", valid_564182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564183: Call_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_564168;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the subscription level policy assignment.
  ## 
  let valid = call_564183.validator(path, query, header, formData, body)
  let scheme = call_564183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564183.url(scheme.get, call_564183.host, call_564183.base,
                         call_564183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564183, url, valid)

proc call*(call_564184: Call_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_564168;
          apiVersion: string; policyAssignmentName: string; subscriptionId: string;
          authorizationNamespace: string = "Microsoft.Authorization"; Top: int = 0;
          Select: string = ""; policyStatesResource: string = "default";
          To: string = ""; Orderby: string = ""; Apply: string = ""; Filter: string = "";
          From: string = ""): Recallable =
  ## policyStatesListQueryResultsForSubscriptionLevelPolicyAssignment
  ## Queries policy states for the subscription level policy assignment.
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
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
  var path_564185 = newJObject()
  var query_564186 = newJObject()
  add(path_564185, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_564186, "api-version", newJString(apiVersion))
  add(query_564186, "$top", newJInt(Top))
  add(path_564185, "policyAssignmentName", newJString(policyAssignmentName))
  add(query_564186, "$select", newJString(Select))
  add(path_564185, "policyStatesResource", newJString(policyStatesResource))
  add(path_564185, "subscriptionId", newJString(subscriptionId))
  add(query_564186, "$to", newJString(To))
  add(query_564186, "$orderby", newJString(Orderby))
  add(query_564186, "$apply", newJString(Apply))
  add(query_564186, "$filter", newJString(Filter))
  add(query_564186, "$from", newJString(From))
  result = call_564184.call(path_564185, query_564186, nil, nil, nil)

var policyStatesListQueryResultsForSubscriptionLevelPolicyAssignment* = Call_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_564168(
    name: "policyStatesListQueryResultsForSubscriptionLevelPolicyAssignment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policyAssignments/{policyAssignmentName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults", validator: validate_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_564169,
    base: "",
    url: url_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_564170,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_564187 = ref object of OpenApiRestCall_563556
proc url_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_564189(
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
  assert "policyStatesSummaryResource" in path,
        "`policyStatesSummaryResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "authorizationNamespace"),
               (kind: ConstantSegment, value: "/policyAssignments/"),
               (kind: VariableSegment, value: "policyAssignmentName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesSummaryResource"),
               (kind: ConstantSegment, value: "/summarize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_564188(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Summarizes policy states for the subscription level policy assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   policyAssignmentName: JString (required)
  ##                       : Policy assignment name.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policyStatesSummaryResource: JString (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationNamespace` field"
  var valid_564190 = path.getOrDefault("authorizationNamespace")
  valid_564190 = validateParameter(valid_564190, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_564190 != nil:
    section.add "authorizationNamespace", valid_564190
  var valid_564191 = path.getOrDefault("policyAssignmentName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "policyAssignmentName", valid_564191
  var valid_564192 = path.getOrDefault("subscriptionId")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "subscriptionId", valid_564192
  var valid_564193 = path.getOrDefault("policyStatesSummaryResource")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = newJString("latest"))
  if valid_564193 != nil:
    section.add "policyStatesSummaryResource", valid_564193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $filter: JString
  ##          : OData filter expression.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564194 = query.getOrDefault("api-version")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "api-version", valid_564194
  var valid_564195 = query.getOrDefault("$top")
  valid_564195 = validateParameter(valid_564195, JInt, required = false, default = nil)
  if valid_564195 != nil:
    section.add "$top", valid_564195
  var valid_564196 = query.getOrDefault("$to")
  valid_564196 = validateParameter(valid_564196, JString, required = false,
                                 default = nil)
  if valid_564196 != nil:
    section.add "$to", valid_564196
  var valid_564197 = query.getOrDefault("$filter")
  valid_564197 = validateParameter(valid_564197, JString, required = false,
                                 default = nil)
  if valid_564197 != nil:
    section.add "$filter", valid_564197
  var valid_564198 = query.getOrDefault("$from")
  valid_564198 = validateParameter(valid_564198, JString, required = false,
                                 default = nil)
  if valid_564198 != nil:
    section.add "$from", valid_564198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564199: Call_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_564187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the subscription level policy assignment.
  ## 
  let valid = call_564199.validator(path, query, header, formData, body)
  let scheme = call_564199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564199.url(scheme.get, call_564199.host, call_564199.base,
                         call_564199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564199, url, valid)

proc call*(call_564200: Call_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_564187;
          apiVersion: string; policyAssignmentName: string; subscriptionId: string;
          authorizationNamespace: string = "Microsoft.Authorization"; Top: int = 0;
          To: string = ""; Filter: string = ""; From: string = "";
          policyStatesSummaryResource: string = "latest"): Recallable =
  ## policyStatesSummarizeForSubscriptionLevelPolicyAssignment
  ## Summarizes policy states for the subscription level policy assignment.
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Filter: string
  ##         : OData filter expression.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   policyStatesSummaryResource: string (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  var path_564201 = newJObject()
  var query_564202 = newJObject()
  add(path_564201, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_564202, "api-version", newJString(apiVersion))
  add(query_564202, "$top", newJInt(Top))
  add(path_564201, "policyAssignmentName", newJString(policyAssignmentName))
  add(path_564201, "subscriptionId", newJString(subscriptionId))
  add(query_564202, "$to", newJString(To))
  add(query_564202, "$filter", newJString(Filter))
  add(query_564202, "$from", newJString(From))
  add(path_564201, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  result = call_564200.call(path_564201, query_564202, nil, nil, nil)

var policyStatesSummarizeForSubscriptionLevelPolicyAssignment* = Call_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_564187(
    name: "policyStatesSummarizeForSubscriptionLevelPolicyAssignment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policyAssignments/{policyAssignmentName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize", validator: validate_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_564188,
    base: "", url: url_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_564189,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForPolicyDefinition_564203 = ref object of OpenApiRestCall_563556
proc url_PolicyStatesListQueryResultsForPolicyDefinition_564205(protocol: Scheme;
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
  assert "policyStatesResource" in path,
        "`policyStatesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "authorizationNamespace"),
               (kind: ConstantSegment, value: "/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesListQueryResultsForPolicyDefinition_564204(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy states for the subscription level policy definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policyDefinitionName: JString (required)
  ##                       : Policy definition name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationNamespace` field"
  var valid_564206 = path.getOrDefault("authorizationNamespace")
  valid_564206 = validateParameter(valid_564206, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_564206 != nil:
    section.add "authorizationNamespace", valid_564206
  var valid_564207 = path.getOrDefault("policyStatesResource")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = newJString("default"))
  if valid_564207 != nil:
    section.add "policyStatesResource", valid_564207
  var valid_564208 = path.getOrDefault("subscriptionId")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "subscriptionId", valid_564208
  var valid_564209 = path.getOrDefault("policyDefinitionName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "policyDefinitionName", valid_564209
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
  var valid_564210 = query.getOrDefault("api-version")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "api-version", valid_564210
  var valid_564211 = query.getOrDefault("$top")
  valid_564211 = validateParameter(valid_564211, JInt, required = false, default = nil)
  if valid_564211 != nil:
    section.add "$top", valid_564211
  var valid_564212 = query.getOrDefault("$select")
  valid_564212 = validateParameter(valid_564212, JString, required = false,
                                 default = nil)
  if valid_564212 != nil:
    section.add "$select", valid_564212
  var valid_564213 = query.getOrDefault("$to")
  valid_564213 = validateParameter(valid_564213, JString, required = false,
                                 default = nil)
  if valid_564213 != nil:
    section.add "$to", valid_564213
  var valid_564214 = query.getOrDefault("$orderby")
  valid_564214 = validateParameter(valid_564214, JString, required = false,
                                 default = nil)
  if valid_564214 != nil:
    section.add "$orderby", valid_564214
  var valid_564215 = query.getOrDefault("$apply")
  valid_564215 = validateParameter(valid_564215, JString, required = false,
                                 default = nil)
  if valid_564215 != nil:
    section.add "$apply", valid_564215
  var valid_564216 = query.getOrDefault("$filter")
  valid_564216 = validateParameter(valid_564216, JString, required = false,
                                 default = nil)
  if valid_564216 != nil:
    section.add "$filter", valid_564216
  var valid_564217 = query.getOrDefault("$from")
  valid_564217 = validateParameter(valid_564217, JString, required = false,
                                 default = nil)
  if valid_564217 != nil:
    section.add "$from", valid_564217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564218: Call_PolicyStatesListQueryResultsForPolicyDefinition_564203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the subscription level policy definition.
  ## 
  let valid = call_564218.validator(path, query, header, formData, body)
  let scheme = call_564218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564218.url(scheme.get, call_564218.host, call_564218.base,
                         call_564218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564218, url, valid)

proc call*(call_564219: Call_PolicyStatesListQueryResultsForPolicyDefinition_564203;
          apiVersion: string; subscriptionId: string; policyDefinitionName: string;
          authorizationNamespace: string = "Microsoft.Authorization"; Top: int = 0;
          Select: string = ""; policyStatesResource: string = "default";
          To: string = ""; Orderby: string = ""; Apply: string = ""; Filter: string = "";
          From: string = ""): Recallable =
  ## policyStatesListQueryResultsForPolicyDefinition
  ## Queries policy states for the subscription level policy definition.
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
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
  var path_564220 = newJObject()
  var query_564221 = newJObject()
  add(path_564220, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_564221, "api-version", newJString(apiVersion))
  add(query_564221, "$top", newJInt(Top))
  add(query_564221, "$select", newJString(Select))
  add(path_564220, "policyStatesResource", newJString(policyStatesResource))
  add(path_564220, "subscriptionId", newJString(subscriptionId))
  add(query_564221, "$to", newJString(To))
  add(query_564221, "$orderby", newJString(Orderby))
  add(query_564221, "$apply", newJString(Apply))
  add(path_564220, "policyDefinitionName", newJString(policyDefinitionName))
  add(query_564221, "$filter", newJString(Filter))
  add(query_564221, "$from", newJString(From))
  result = call_564219.call(path_564220, query_564221, nil, nil, nil)

var policyStatesListQueryResultsForPolicyDefinition* = Call_PolicyStatesListQueryResultsForPolicyDefinition_564203(
    name: "policyStatesListQueryResultsForPolicyDefinition",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policyDefinitions/{policyDefinitionName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForPolicyDefinition_564204,
    base: "", url: url_PolicyStatesListQueryResultsForPolicyDefinition_564205,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForPolicyDefinition_564222 = ref object of OpenApiRestCall_563556
proc url_PolicyStatesSummarizeForPolicyDefinition_564224(protocol: Scheme;
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
  assert "policyStatesSummaryResource" in path,
        "`policyStatesSummaryResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "authorizationNamespace"),
               (kind: ConstantSegment, value: "/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesSummaryResource"),
               (kind: ConstantSegment, value: "/summarize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesSummarizeForPolicyDefinition_564223(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Summarizes policy states for the subscription level policy definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policyDefinitionName: JString (required)
  ##                       : Policy definition name.
  ##   policyStatesSummaryResource: JString (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationNamespace` field"
  var valid_564225 = path.getOrDefault("authorizationNamespace")
  valid_564225 = validateParameter(valid_564225, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_564225 != nil:
    section.add "authorizationNamespace", valid_564225
  var valid_564226 = path.getOrDefault("subscriptionId")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "subscriptionId", valid_564226
  var valid_564227 = path.getOrDefault("policyDefinitionName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "policyDefinitionName", valid_564227
  var valid_564228 = path.getOrDefault("policyStatesSummaryResource")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = newJString("latest"))
  if valid_564228 != nil:
    section.add "policyStatesSummaryResource", valid_564228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $filter: JString
  ##          : OData filter expression.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564229 = query.getOrDefault("api-version")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "api-version", valid_564229
  var valid_564230 = query.getOrDefault("$top")
  valid_564230 = validateParameter(valid_564230, JInt, required = false, default = nil)
  if valid_564230 != nil:
    section.add "$top", valid_564230
  var valid_564231 = query.getOrDefault("$to")
  valid_564231 = validateParameter(valid_564231, JString, required = false,
                                 default = nil)
  if valid_564231 != nil:
    section.add "$to", valid_564231
  var valid_564232 = query.getOrDefault("$filter")
  valid_564232 = validateParameter(valid_564232, JString, required = false,
                                 default = nil)
  if valid_564232 != nil:
    section.add "$filter", valid_564232
  var valid_564233 = query.getOrDefault("$from")
  valid_564233 = validateParameter(valid_564233, JString, required = false,
                                 default = nil)
  if valid_564233 != nil:
    section.add "$from", valid_564233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564234: Call_PolicyStatesSummarizeForPolicyDefinition_564222;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the subscription level policy definition.
  ## 
  let valid = call_564234.validator(path, query, header, formData, body)
  let scheme = call_564234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564234.url(scheme.get, call_564234.host, call_564234.base,
                         call_564234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564234, url, valid)

proc call*(call_564235: Call_PolicyStatesSummarizeForPolicyDefinition_564222;
          apiVersion: string; subscriptionId: string; policyDefinitionName: string;
          authorizationNamespace: string = "Microsoft.Authorization"; Top: int = 0;
          To: string = ""; Filter: string = ""; From: string = "";
          policyStatesSummaryResource: string = "latest"): Recallable =
  ## policyStatesSummarizeForPolicyDefinition
  ## Summarizes policy states for the subscription level policy definition.
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   policyDefinitionName: string (required)
  ##                       : Policy definition name.
  ##   Filter: string
  ##         : OData filter expression.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   policyStatesSummaryResource: string (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  var path_564236 = newJObject()
  var query_564237 = newJObject()
  add(path_564236, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_564237, "api-version", newJString(apiVersion))
  add(query_564237, "$top", newJInt(Top))
  add(path_564236, "subscriptionId", newJString(subscriptionId))
  add(query_564237, "$to", newJString(To))
  add(path_564236, "policyDefinitionName", newJString(policyDefinitionName))
  add(query_564237, "$filter", newJString(Filter))
  add(query_564237, "$from", newJString(From))
  add(path_564236, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  result = call_564235.call(path_564236, query_564237, nil, nil, nil)

var policyStatesSummarizeForPolicyDefinition* = Call_PolicyStatesSummarizeForPolicyDefinition_564222(
    name: "policyStatesSummarizeForPolicyDefinition", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policyDefinitions/{policyDefinitionName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize",
    validator: validate_PolicyStatesSummarizeForPolicyDefinition_564223, base: "",
    url: url_PolicyStatesSummarizeForPolicyDefinition_564224,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForPolicySetDefinition_564238 = ref object of OpenApiRestCall_563556
proc url_PolicyStatesListQueryResultsForPolicySetDefinition_564240(
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
  assert "policyStatesResource" in path,
        "`policyStatesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "authorizationNamespace"),
               (kind: ConstantSegment, value: "/policySetDefinitions/"),
               (kind: VariableSegment, value: "policySetDefinitionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesListQueryResultsForPolicySetDefinition_564239(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy states for the subscription level policy set definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policySetDefinitionName: JString (required)
  ##                          : Policy set definition name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationNamespace` field"
  var valid_564241 = path.getOrDefault("authorizationNamespace")
  valid_564241 = validateParameter(valid_564241, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_564241 != nil:
    section.add "authorizationNamespace", valid_564241
  var valid_564242 = path.getOrDefault("policyStatesResource")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = newJString("default"))
  if valid_564242 != nil:
    section.add "policyStatesResource", valid_564242
  var valid_564243 = path.getOrDefault("subscriptionId")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "subscriptionId", valid_564243
  var valid_564244 = path.getOrDefault("policySetDefinitionName")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "policySetDefinitionName", valid_564244
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
  var valid_564245 = query.getOrDefault("api-version")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "api-version", valid_564245
  var valid_564246 = query.getOrDefault("$top")
  valid_564246 = validateParameter(valid_564246, JInt, required = false, default = nil)
  if valid_564246 != nil:
    section.add "$top", valid_564246
  var valid_564247 = query.getOrDefault("$select")
  valid_564247 = validateParameter(valid_564247, JString, required = false,
                                 default = nil)
  if valid_564247 != nil:
    section.add "$select", valid_564247
  var valid_564248 = query.getOrDefault("$to")
  valid_564248 = validateParameter(valid_564248, JString, required = false,
                                 default = nil)
  if valid_564248 != nil:
    section.add "$to", valid_564248
  var valid_564249 = query.getOrDefault("$orderby")
  valid_564249 = validateParameter(valid_564249, JString, required = false,
                                 default = nil)
  if valid_564249 != nil:
    section.add "$orderby", valid_564249
  var valid_564250 = query.getOrDefault("$apply")
  valid_564250 = validateParameter(valid_564250, JString, required = false,
                                 default = nil)
  if valid_564250 != nil:
    section.add "$apply", valid_564250
  var valid_564251 = query.getOrDefault("$filter")
  valid_564251 = validateParameter(valid_564251, JString, required = false,
                                 default = nil)
  if valid_564251 != nil:
    section.add "$filter", valid_564251
  var valid_564252 = query.getOrDefault("$from")
  valid_564252 = validateParameter(valid_564252, JString, required = false,
                                 default = nil)
  if valid_564252 != nil:
    section.add "$from", valid_564252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564253: Call_PolicyStatesListQueryResultsForPolicySetDefinition_564238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the subscription level policy set definition.
  ## 
  let valid = call_564253.validator(path, query, header, formData, body)
  let scheme = call_564253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564253.url(scheme.get, call_564253.host, call_564253.base,
                         call_564253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564253, url, valid)

proc call*(call_564254: Call_PolicyStatesListQueryResultsForPolicySetDefinition_564238;
          apiVersion: string; subscriptionId: string;
          policySetDefinitionName: string;
          authorizationNamespace: string = "Microsoft.Authorization"; Top: int = 0;
          Select: string = ""; policyStatesResource: string = "default";
          To: string = ""; Orderby: string = ""; Apply: string = ""; Filter: string = "";
          From: string = ""): Recallable =
  ## policyStatesListQueryResultsForPolicySetDefinition
  ## Queries policy states for the subscription level policy set definition.
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
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
  var path_564255 = newJObject()
  var query_564256 = newJObject()
  add(path_564255, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_564256, "api-version", newJString(apiVersion))
  add(query_564256, "$top", newJInt(Top))
  add(query_564256, "$select", newJString(Select))
  add(path_564255, "policyStatesResource", newJString(policyStatesResource))
  add(path_564255, "subscriptionId", newJString(subscriptionId))
  add(query_564256, "$to", newJString(To))
  add(query_564256, "$orderby", newJString(Orderby))
  add(path_564255, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_564256, "$apply", newJString(Apply))
  add(query_564256, "$filter", newJString(Filter))
  add(query_564256, "$from", newJString(From))
  result = call_564254.call(path_564255, query_564256, nil, nil, nil)

var policyStatesListQueryResultsForPolicySetDefinition* = Call_PolicyStatesListQueryResultsForPolicySetDefinition_564238(
    name: "policyStatesListQueryResultsForPolicySetDefinition",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policySetDefinitions/{policySetDefinitionName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForPolicySetDefinition_564239,
    base: "", url: url_PolicyStatesListQueryResultsForPolicySetDefinition_564240,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForPolicySetDefinition_564257 = ref object of OpenApiRestCall_563556
proc url_PolicyStatesSummarizeForPolicySetDefinition_564259(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "authorizationNamespace" in path,
        "`authorizationNamespace` is a required path parameter"
  assert "policySetDefinitionName" in path,
        "`policySetDefinitionName` is a required path parameter"
  assert "policyStatesSummaryResource" in path,
        "`policyStatesSummaryResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "authorizationNamespace"),
               (kind: ConstantSegment, value: "/policySetDefinitions/"),
               (kind: VariableSegment, value: "policySetDefinitionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesSummaryResource"),
               (kind: ConstantSegment, value: "/summarize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesSummarizeForPolicySetDefinition_564258(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Summarizes policy states for the subscription level policy set definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policySetDefinitionName: JString (required)
  ##                          : Policy set definition name.
  ##   policyStatesSummaryResource: JString (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationNamespace` field"
  var valid_564260 = path.getOrDefault("authorizationNamespace")
  valid_564260 = validateParameter(valid_564260, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_564260 != nil:
    section.add "authorizationNamespace", valid_564260
  var valid_564261 = path.getOrDefault("subscriptionId")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "subscriptionId", valid_564261
  var valid_564262 = path.getOrDefault("policySetDefinitionName")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "policySetDefinitionName", valid_564262
  var valid_564263 = path.getOrDefault("policyStatesSummaryResource")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = newJString("latest"))
  if valid_564263 != nil:
    section.add "policyStatesSummaryResource", valid_564263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $filter: JString
  ##          : OData filter expression.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564264 = query.getOrDefault("api-version")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "api-version", valid_564264
  var valid_564265 = query.getOrDefault("$top")
  valid_564265 = validateParameter(valid_564265, JInt, required = false, default = nil)
  if valid_564265 != nil:
    section.add "$top", valid_564265
  var valid_564266 = query.getOrDefault("$to")
  valid_564266 = validateParameter(valid_564266, JString, required = false,
                                 default = nil)
  if valid_564266 != nil:
    section.add "$to", valid_564266
  var valid_564267 = query.getOrDefault("$filter")
  valid_564267 = validateParameter(valid_564267, JString, required = false,
                                 default = nil)
  if valid_564267 != nil:
    section.add "$filter", valid_564267
  var valid_564268 = query.getOrDefault("$from")
  valid_564268 = validateParameter(valid_564268, JString, required = false,
                                 default = nil)
  if valid_564268 != nil:
    section.add "$from", valid_564268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564269: Call_PolicyStatesSummarizeForPolicySetDefinition_564257;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the subscription level policy set definition.
  ## 
  let valid = call_564269.validator(path, query, header, formData, body)
  let scheme = call_564269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564269.url(scheme.get, call_564269.host, call_564269.base,
                         call_564269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564269, url, valid)

proc call*(call_564270: Call_PolicyStatesSummarizeForPolicySetDefinition_564257;
          apiVersion: string; subscriptionId: string;
          policySetDefinitionName: string;
          authorizationNamespace: string = "Microsoft.Authorization"; Top: int = 0;
          To: string = ""; Filter: string = ""; From: string = "";
          policyStatesSummaryResource: string = "latest"): Recallable =
  ## policyStatesSummarizeForPolicySetDefinition
  ## Summarizes policy states for the subscription level policy set definition.
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   policySetDefinitionName: string (required)
  ##                          : Policy set definition name.
  ##   Filter: string
  ##         : OData filter expression.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   policyStatesSummaryResource: string (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  var path_564271 = newJObject()
  var query_564272 = newJObject()
  add(path_564271, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_564272, "api-version", newJString(apiVersion))
  add(query_564272, "$top", newJInt(Top))
  add(path_564271, "subscriptionId", newJString(subscriptionId))
  add(query_564272, "$to", newJString(To))
  add(path_564271, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_564272, "$filter", newJString(Filter))
  add(query_564272, "$from", newJString(From))
  add(path_564271, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  result = call_564270.call(path_564271, query_564272, nil, nil, nil)

var policyStatesSummarizeForPolicySetDefinition* = Call_PolicyStatesSummarizeForPolicySetDefinition_564257(
    name: "policyStatesSummarizeForPolicySetDefinition",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policySetDefinitions/{policySetDefinitionName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize",
    validator: validate_PolicyStatesSummarizeForPolicySetDefinition_564258,
    base: "", url: url_PolicyStatesSummarizeForPolicySetDefinition_564259,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForResourceGroup_564273 = ref object of OpenApiRestCall_563556
proc url_PolicyStatesListQueryResultsForResourceGroup_564275(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "policyStatesResource" in path,
        "`policyStatesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesListQueryResultsForResourceGroup_564274(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queries policy states for the resources under the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyStatesResource` field"
  var valid_564276 = path.getOrDefault("policyStatesResource")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = newJString("default"))
  if valid_564276 != nil:
    section.add "policyStatesResource", valid_564276
  var valid_564277 = path.getOrDefault("subscriptionId")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "subscriptionId", valid_564277
  var valid_564278 = path.getOrDefault("resourceGroupName")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "resourceGroupName", valid_564278
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
  var valid_564279 = query.getOrDefault("api-version")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "api-version", valid_564279
  var valid_564280 = query.getOrDefault("$top")
  valid_564280 = validateParameter(valid_564280, JInt, required = false, default = nil)
  if valid_564280 != nil:
    section.add "$top", valid_564280
  var valid_564281 = query.getOrDefault("$select")
  valid_564281 = validateParameter(valid_564281, JString, required = false,
                                 default = nil)
  if valid_564281 != nil:
    section.add "$select", valid_564281
  var valid_564282 = query.getOrDefault("$to")
  valid_564282 = validateParameter(valid_564282, JString, required = false,
                                 default = nil)
  if valid_564282 != nil:
    section.add "$to", valid_564282
  var valid_564283 = query.getOrDefault("$orderby")
  valid_564283 = validateParameter(valid_564283, JString, required = false,
                                 default = nil)
  if valid_564283 != nil:
    section.add "$orderby", valid_564283
  var valid_564284 = query.getOrDefault("$apply")
  valid_564284 = validateParameter(valid_564284, JString, required = false,
                                 default = nil)
  if valid_564284 != nil:
    section.add "$apply", valid_564284
  var valid_564285 = query.getOrDefault("$filter")
  valid_564285 = validateParameter(valid_564285, JString, required = false,
                                 default = nil)
  if valid_564285 != nil:
    section.add "$filter", valid_564285
  var valid_564286 = query.getOrDefault("$from")
  valid_564286 = validateParameter(valid_564286, JString, required = false,
                                 default = nil)
  if valid_564286 != nil:
    section.add "$from", valid_564286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564287: Call_PolicyStatesListQueryResultsForResourceGroup_564273;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resources under the resource group.
  ## 
  let valid = call_564287.validator(path, query, header, formData, body)
  let scheme = call_564287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564287.url(scheme.get, call_564287.host, call_564287.base,
                         call_564287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564287, url, valid)

proc call*(call_564288: Call_PolicyStatesListQueryResultsForResourceGroup_564273;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; Select: string = ""; policyStatesResource: string = "default";
          To: string = ""; Orderby: string = ""; Apply: string = ""; Filter: string = "";
          From: string = ""): Recallable =
  ## policyStatesListQueryResultsForResourceGroup
  ## Queries policy states for the resources under the resource group.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
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
  var path_564289 = newJObject()
  var query_564290 = newJObject()
  add(query_564290, "api-version", newJString(apiVersion))
  add(query_564290, "$top", newJInt(Top))
  add(query_564290, "$select", newJString(Select))
  add(path_564289, "policyStatesResource", newJString(policyStatesResource))
  add(path_564289, "subscriptionId", newJString(subscriptionId))
  add(query_564290, "$to", newJString(To))
  add(query_564290, "$orderby", newJString(Orderby))
  add(query_564290, "$apply", newJString(Apply))
  add(path_564289, "resourceGroupName", newJString(resourceGroupName))
  add(query_564290, "$filter", newJString(Filter))
  add(query_564290, "$from", newJString(From))
  result = call_564288.call(path_564289, query_564290, nil, nil, nil)

var policyStatesListQueryResultsForResourceGroup* = Call_PolicyStatesListQueryResultsForResourceGroup_564273(
    name: "policyStatesListQueryResultsForResourceGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForResourceGroup_564274,
    base: "", url: url_PolicyStatesListQueryResultsForResourceGroup_564275,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForResourceGroup_564291 = ref object of OpenApiRestCall_563556
proc url_PolicyStatesSummarizeForResourceGroup_564293(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "policyStatesSummaryResource" in path,
        "`policyStatesSummaryResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesSummaryResource"),
               (kind: ConstantSegment, value: "/summarize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesSummarizeForResourceGroup_564292(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Summarizes policy states for the resources under the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   policyStatesSummaryResource: JString (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564294 = path.getOrDefault("subscriptionId")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "subscriptionId", valid_564294
  var valid_564295 = path.getOrDefault("resourceGroupName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "resourceGroupName", valid_564295
  var valid_564296 = path.getOrDefault("policyStatesSummaryResource")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = newJString("latest"))
  if valid_564296 != nil:
    section.add "policyStatesSummaryResource", valid_564296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $filter: JString
  ##          : OData filter expression.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564297 = query.getOrDefault("api-version")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "api-version", valid_564297
  var valid_564298 = query.getOrDefault("$top")
  valid_564298 = validateParameter(valid_564298, JInt, required = false, default = nil)
  if valid_564298 != nil:
    section.add "$top", valid_564298
  var valid_564299 = query.getOrDefault("$to")
  valid_564299 = validateParameter(valid_564299, JString, required = false,
                                 default = nil)
  if valid_564299 != nil:
    section.add "$to", valid_564299
  var valid_564300 = query.getOrDefault("$filter")
  valid_564300 = validateParameter(valid_564300, JString, required = false,
                                 default = nil)
  if valid_564300 != nil:
    section.add "$filter", valid_564300
  var valid_564301 = query.getOrDefault("$from")
  valid_564301 = validateParameter(valid_564301, JString, required = false,
                                 default = nil)
  if valid_564301 != nil:
    section.add "$from", valid_564301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564302: Call_PolicyStatesSummarizeForResourceGroup_564291;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the resources under the resource group.
  ## 
  let valid = call_564302.validator(path, query, header, formData, body)
  let scheme = call_564302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564302.url(scheme.get, call_564302.host, call_564302.base,
                         call_564302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564302, url, valid)

proc call*(call_564303: Call_PolicyStatesSummarizeForResourceGroup_564291;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; To: string = ""; Filter: string = ""; From: string = "";
          policyStatesSummaryResource: string = "latest"): Recallable =
  ## policyStatesSummarizeForResourceGroup
  ## Summarizes policy states for the resources under the resource group.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   Filter: string
  ##         : OData filter expression.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   policyStatesSummaryResource: string (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  var path_564304 = newJObject()
  var query_564305 = newJObject()
  add(query_564305, "api-version", newJString(apiVersion))
  add(query_564305, "$top", newJInt(Top))
  add(path_564304, "subscriptionId", newJString(subscriptionId))
  add(query_564305, "$to", newJString(To))
  add(path_564304, "resourceGroupName", newJString(resourceGroupName))
  add(query_564305, "$filter", newJString(Filter))
  add(query_564305, "$from", newJString(From))
  add(path_564304, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  result = call_564303.call(path_564304, query_564305, nil, nil, nil)

var policyStatesSummarizeForResourceGroup* = Call_PolicyStatesSummarizeForResourceGroup_564291(
    name: "policyStatesSummarizeForResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize",
    validator: validate_PolicyStatesSummarizeForResourceGroup_564292, base: "",
    url: url_PolicyStatesSummarizeForResourceGroup_564293, schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_564306 = ref object of OpenApiRestCall_563556
proc url_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_564308(
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
  assert "policyStatesResource" in path,
        "`policyStatesResource` is a required path parameter"
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
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_564307(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy states for the resource group level policy assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   policyAssignmentName: JString (required)
  ##                       : Policy assignment name.
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationNamespace` field"
  var valid_564309 = path.getOrDefault("authorizationNamespace")
  valid_564309 = validateParameter(valid_564309, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_564309 != nil:
    section.add "authorizationNamespace", valid_564309
  var valid_564310 = path.getOrDefault("policyAssignmentName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "policyAssignmentName", valid_564310
  var valid_564311 = path.getOrDefault("policyStatesResource")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = newJString("default"))
  if valid_564311 != nil:
    section.add "policyStatesResource", valid_564311
  var valid_564312 = path.getOrDefault("subscriptionId")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "subscriptionId", valid_564312
  var valid_564313 = path.getOrDefault("resourceGroupName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "resourceGroupName", valid_564313
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
  var valid_564314 = query.getOrDefault("api-version")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "api-version", valid_564314
  var valid_564315 = query.getOrDefault("$top")
  valid_564315 = validateParameter(valid_564315, JInt, required = false, default = nil)
  if valid_564315 != nil:
    section.add "$top", valid_564315
  var valid_564316 = query.getOrDefault("$select")
  valid_564316 = validateParameter(valid_564316, JString, required = false,
                                 default = nil)
  if valid_564316 != nil:
    section.add "$select", valid_564316
  var valid_564317 = query.getOrDefault("$to")
  valid_564317 = validateParameter(valid_564317, JString, required = false,
                                 default = nil)
  if valid_564317 != nil:
    section.add "$to", valid_564317
  var valid_564318 = query.getOrDefault("$orderby")
  valid_564318 = validateParameter(valid_564318, JString, required = false,
                                 default = nil)
  if valid_564318 != nil:
    section.add "$orderby", valid_564318
  var valid_564319 = query.getOrDefault("$apply")
  valid_564319 = validateParameter(valid_564319, JString, required = false,
                                 default = nil)
  if valid_564319 != nil:
    section.add "$apply", valid_564319
  var valid_564320 = query.getOrDefault("$filter")
  valid_564320 = validateParameter(valid_564320, JString, required = false,
                                 default = nil)
  if valid_564320 != nil:
    section.add "$filter", valid_564320
  var valid_564321 = query.getOrDefault("$from")
  valid_564321 = validateParameter(valid_564321, JString, required = false,
                                 default = nil)
  if valid_564321 != nil:
    section.add "$from", valid_564321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564322: Call_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_564306;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resource group level policy assignment.
  ## 
  let valid = call_564322.validator(path, query, header, formData, body)
  let scheme = call_564322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564322.url(scheme.get, call_564322.host, call_564322.base,
                         call_564322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564322, url, valid)

proc call*(call_564323: Call_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_564306;
          apiVersion: string; policyAssignmentName: string; subscriptionId: string;
          resourceGroupName: string;
          authorizationNamespace: string = "Microsoft.Authorization"; Top: int = 0;
          Select: string = ""; policyStatesResource: string = "default";
          To: string = ""; Orderby: string = ""; Apply: string = ""; Filter: string = "";
          From: string = ""): Recallable =
  ## policyStatesListQueryResultsForResourceGroupLevelPolicyAssignment
  ## Queries policy states for the resource group level policy assignment.
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
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
  var path_564324 = newJObject()
  var query_564325 = newJObject()
  add(path_564324, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_564325, "api-version", newJString(apiVersion))
  add(query_564325, "$top", newJInt(Top))
  add(path_564324, "policyAssignmentName", newJString(policyAssignmentName))
  add(query_564325, "$select", newJString(Select))
  add(path_564324, "policyStatesResource", newJString(policyStatesResource))
  add(path_564324, "subscriptionId", newJString(subscriptionId))
  add(query_564325, "$to", newJString(To))
  add(query_564325, "$orderby", newJString(Orderby))
  add(query_564325, "$apply", newJString(Apply))
  add(path_564324, "resourceGroupName", newJString(resourceGroupName))
  add(query_564325, "$filter", newJString(Filter))
  add(query_564325, "$from", newJString(From))
  result = call_564323.call(path_564324, query_564325, nil, nil, nil)

var policyStatesListQueryResultsForResourceGroupLevelPolicyAssignment* = Call_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_564306(
    name: "policyStatesListQueryResultsForResourceGroupLevelPolicyAssignment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{authorizationNamespace}/policyAssignments/{policyAssignmentName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults", validator: validate_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_564307,
    base: "",
    url: url_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_564308,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_564326 = ref object of OpenApiRestCall_563556
proc url_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_564328(
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
  assert "policyStatesSummaryResource" in path,
        "`policyStatesSummaryResource` is a required path parameter"
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
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesSummaryResource"),
               (kind: ConstantSegment, value: "/summarize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_564327(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Summarizes policy states for the resource group level policy assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   policyAssignmentName: JString (required)
  ##                       : Policy assignment name.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   policyStatesSummaryResource: JString (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationNamespace` field"
  var valid_564329 = path.getOrDefault("authorizationNamespace")
  valid_564329 = validateParameter(valid_564329, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_564329 != nil:
    section.add "authorizationNamespace", valid_564329
  var valid_564330 = path.getOrDefault("policyAssignmentName")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "policyAssignmentName", valid_564330
  var valid_564331 = path.getOrDefault("subscriptionId")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "subscriptionId", valid_564331
  var valid_564332 = path.getOrDefault("resourceGroupName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "resourceGroupName", valid_564332
  var valid_564333 = path.getOrDefault("policyStatesSummaryResource")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = newJString("latest"))
  if valid_564333 != nil:
    section.add "policyStatesSummaryResource", valid_564333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $filter: JString
  ##          : OData filter expression.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564334 = query.getOrDefault("api-version")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "api-version", valid_564334
  var valid_564335 = query.getOrDefault("$top")
  valid_564335 = validateParameter(valid_564335, JInt, required = false, default = nil)
  if valid_564335 != nil:
    section.add "$top", valid_564335
  var valid_564336 = query.getOrDefault("$to")
  valid_564336 = validateParameter(valid_564336, JString, required = false,
                                 default = nil)
  if valid_564336 != nil:
    section.add "$to", valid_564336
  var valid_564337 = query.getOrDefault("$filter")
  valid_564337 = validateParameter(valid_564337, JString, required = false,
                                 default = nil)
  if valid_564337 != nil:
    section.add "$filter", valid_564337
  var valid_564338 = query.getOrDefault("$from")
  valid_564338 = validateParameter(valid_564338, JString, required = false,
                                 default = nil)
  if valid_564338 != nil:
    section.add "$from", valid_564338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564339: Call_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_564326;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the resource group level policy assignment.
  ## 
  let valid = call_564339.validator(path, query, header, formData, body)
  let scheme = call_564339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564339.url(scheme.get, call_564339.host, call_564339.base,
                         call_564339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564339, url, valid)

proc call*(call_564340: Call_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_564326;
          apiVersion: string; policyAssignmentName: string; subscriptionId: string;
          resourceGroupName: string;
          authorizationNamespace: string = "Microsoft.Authorization"; Top: int = 0;
          To: string = ""; Filter: string = ""; From: string = "";
          policyStatesSummaryResource: string = "latest"): Recallable =
  ## policyStatesSummarizeForResourceGroupLevelPolicyAssignment
  ## Summarizes policy states for the resource group level policy assignment.
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   Filter: string
  ##         : OData filter expression.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   policyStatesSummaryResource: string (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  var path_564341 = newJObject()
  var query_564342 = newJObject()
  add(path_564341, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_564342, "api-version", newJString(apiVersion))
  add(query_564342, "$top", newJInt(Top))
  add(path_564341, "policyAssignmentName", newJString(policyAssignmentName))
  add(path_564341, "subscriptionId", newJString(subscriptionId))
  add(query_564342, "$to", newJString(To))
  add(path_564341, "resourceGroupName", newJString(resourceGroupName))
  add(query_564342, "$filter", newJString(Filter))
  add(query_564342, "$from", newJString(From))
  add(path_564341, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  result = call_564340.call(path_564341, query_564342, nil, nil, nil)

var policyStatesSummarizeForResourceGroupLevelPolicyAssignment* = Call_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_564326(
    name: "policyStatesSummarizeForResourceGroupLevelPolicyAssignment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{authorizationNamespace}/policyAssignments/{policyAssignmentName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize", validator: validate_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_564327,
    base: "", url: url_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_564328,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForResource_564343 = ref object of OpenApiRestCall_563556
proc url_PolicyStatesListQueryResultsForResource_564345(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "policyStatesResource" in path,
        "`policyStatesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesListQueryResultsForResource_564344(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queries policy states for the resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   resourceId: JString (required)
  ##             : Resource ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyStatesResource` field"
  var valid_564346 = path.getOrDefault("policyStatesResource")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = newJString("default"))
  if valid_564346 != nil:
    section.add "policyStatesResource", valid_564346
  var valid_564347 = path.getOrDefault("resourceId")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "resourceId", valid_564347
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
  var valid_564348 = query.getOrDefault("api-version")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "api-version", valid_564348
  var valid_564349 = query.getOrDefault("$top")
  valid_564349 = validateParameter(valid_564349, JInt, required = false, default = nil)
  if valid_564349 != nil:
    section.add "$top", valid_564349
  var valid_564350 = query.getOrDefault("$select")
  valid_564350 = validateParameter(valid_564350, JString, required = false,
                                 default = nil)
  if valid_564350 != nil:
    section.add "$select", valid_564350
  var valid_564351 = query.getOrDefault("$to")
  valid_564351 = validateParameter(valid_564351, JString, required = false,
                                 default = nil)
  if valid_564351 != nil:
    section.add "$to", valid_564351
  var valid_564352 = query.getOrDefault("$orderby")
  valid_564352 = validateParameter(valid_564352, JString, required = false,
                                 default = nil)
  if valid_564352 != nil:
    section.add "$orderby", valid_564352
  var valid_564353 = query.getOrDefault("$apply")
  valid_564353 = validateParameter(valid_564353, JString, required = false,
                                 default = nil)
  if valid_564353 != nil:
    section.add "$apply", valid_564353
  var valid_564354 = query.getOrDefault("$filter")
  valid_564354 = validateParameter(valid_564354, JString, required = false,
                                 default = nil)
  if valid_564354 != nil:
    section.add "$filter", valid_564354
  var valid_564355 = query.getOrDefault("$from")
  valid_564355 = validateParameter(valid_564355, JString, required = false,
                                 default = nil)
  if valid_564355 != nil:
    section.add "$from", valid_564355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564356: Call_PolicyStatesListQueryResultsForResource_564343;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resource.
  ## 
  let valid = call_564356.validator(path, query, header, formData, body)
  let scheme = call_564356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564356.url(scheme.get, call_564356.host, call_564356.base,
                         call_564356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564356, url, valid)

proc call*(call_564357: Call_PolicyStatesListQueryResultsForResource_564343;
          apiVersion: string; resourceId: string; Top: int = 0; Select: string = "";
          policyStatesResource: string = "default"; To: string = "";
          Orderby: string = ""; Apply: string = ""; Filter: string = ""; From: string = ""): Recallable =
  ## policyStatesListQueryResultsForResource
  ## Queries policy states for the resource.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
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
  var path_564358 = newJObject()
  var query_564359 = newJObject()
  add(query_564359, "api-version", newJString(apiVersion))
  add(query_564359, "$top", newJInt(Top))
  add(query_564359, "$select", newJString(Select))
  add(path_564358, "policyStatesResource", newJString(policyStatesResource))
  add(query_564359, "$to", newJString(To))
  add(query_564359, "$orderby", newJString(Orderby))
  add(query_564359, "$apply", newJString(Apply))
  add(query_564359, "$filter", newJString(Filter))
  add(query_564359, "$from", newJString(From))
  add(path_564358, "resourceId", newJString(resourceId))
  result = call_564357.call(path_564358, query_564359, nil, nil, nil)

var policyStatesListQueryResultsForResource* = Call_PolicyStatesListQueryResultsForResource_564343(
    name: "policyStatesListQueryResultsForResource", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForResource_564344, base: "",
    url: url_PolicyStatesListQueryResultsForResource_564345,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForResource_564360 = ref object of OpenApiRestCall_563556
proc url_PolicyStatesSummarizeForResource_564362(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "policyStatesSummaryResource" in path,
        "`policyStatesSummaryResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesSummaryResource"),
               (kind: ConstantSegment, value: "/summarize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesSummarizeForResource_564361(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Summarizes policy states for the resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyStatesSummaryResource: JString (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  ##   resourceId: JString (required)
  ##             : Resource ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyStatesSummaryResource` field"
  var valid_564363 = path.getOrDefault("policyStatesSummaryResource")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = newJString("latest"))
  if valid_564363 != nil:
    section.add "policyStatesSummaryResource", valid_564363
  var valid_564364 = path.getOrDefault("resourceId")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "resourceId", valid_564364
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $filter: JString
  ##          : OData filter expression.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564365 = query.getOrDefault("api-version")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "api-version", valid_564365
  var valid_564366 = query.getOrDefault("$top")
  valid_564366 = validateParameter(valid_564366, JInt, required = false, default = nil)
  if valid_564366 != nil:
    section.add "$top", valid_564366
  var valid_564367 = query.getOrDefault("$to")
  valid_564367 = validateParameter(valid_564367, JString, required = false,
                                 default = nil)
  if valid_564367 != nil:
    section.add "$to", valid_564367
  var valid_564368 = query.getOrDefault("$filter")
  valid_564368 = validateParameter(valid_564368, JString, required = false,
                                 default = nil)
  if valid_564368 != nil:
    section.add "$filter", valid_564368
  var valid_564369 = query.getOrDefault("$from")
  valid_564369 = validateParameter(valid_564369, JString, required = false,
                                 default = nil)
  if valid_564369 != nil:
    section.add "$from", valid_564369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564370: Call_PolicyStatesSummarizeForResource_564360;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the resource.
  ## 
  let valid = call_564370.validator(path, query, header, formData, body)
  let scheme = call_564370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564370.url(scheme.get, call_564370.host, call_564370.base,
                         call_564370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564370, url, valid)

proc call*(call_564371: Call_PolicyStatesSummarizeForResource_564360;
          apiVersion: string; resourceId: string; Top: int = 0; To: string = "";
          Filter: string = ""; From: string = "";
          policyStatesSummaryResource: string = "latest"): Recallable =
  ## policyStatesSummarizeForResource
  ## Summarizes policy states for the resource.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Filter: string
  ##         : OData filter expression.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   policyStatesSummaryResource: string (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  ##   resourceId: string (required)
  ##             : Resource ID.
  var path_564372 = newJObject()
  var query_564373 = newJObject()
  add(query_564373, "api-version", newJString(apiVersion))
  add(query_564373, "$top", newJInt(Top))
  add(query_564373, "$to", newJString(To))
  add(query_564373, "$filter", newJString(Filter))
  add(query_564373, "$from", newJString(From))
  add(path_564372, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  add(path_564372, "resourceId", newJString(resourceId))
  result = call_564371.call(path_564372, query_564373, nil, nil, nil)

var policyStatesSummarizeForResource* = Call_PolicyStatesSummarizeForResource_564360(
    name: "policyStatesSummarizeForResource", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize",
    validator: validate_PolicyStatesSummarizeForResource_564361, base: "",
    url: url_PolicyStatesSummarizeForResource_564362, schemes: {Scheme.Https})
type
  Call_PolicyStatesGetMetadata_564374 = ref object of OpenApiRestCall_563556
proc url_PolicyStatesGetMetadata_564376(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.PolicyInsights/policyStates/$metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesGetMetadata_564375(path: JsonNode; query: JsonNode;
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
  var valid_564377 = path.getOrDefault("scope")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "scope", valid_564377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564378 = query.getOrDefault("api-version")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "api-version", valid_564378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564379: Call_PolicyStatesGetMetadata_564374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets OData metadata XML document.
  ## 
  let valid = call_564379.validator(path, query, header, formData, body)
  let scheme = call_564379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564379.url(scheme.get, call_564379.host, call_564379.base,
                         call_564379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564379, url, valid)

proc call*(call_564380: Call_PolicyStatesGetMetadata_564374; apiVersion: string;
          scope: string): Recallable =
  ## policyStatesGetMetadata
  ## Gets OData metadata XML document.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   scope: string (required)
  ##        : A valid scope, i.e. management group, subscription, resource group, or resource ID. Scope used has no effect on metadata returned.
  var path_564381 = newJObject()
  var query_564382 = newJObject()
  add(query_564382, "api-version", newJString(apiVersion))
  add(path_564381, "scope", newJString(scope))
  result = call_564380.call(path_564381, query_564382, nil, nil, nil)

var policyStatesGetMetadata* = Call_PolicyStatesGetMetadata_564374(
    name: "policyStatesGetMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.PolicyInsights/policyStates/$metadata",
    validator: validate_PolicyStatesGetMetadata_564375, base: "",
    url: url_PolicyStatesGetMetadata_564376, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
