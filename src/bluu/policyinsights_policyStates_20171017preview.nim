
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: PolicyStatesClient
## version: 2017-10-17-preview
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
  macServiceName = "policyinsights-policyStates"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567880 = ref object of OpenApiRestCall_567658
proc url_OperationsList_567882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567881(path: JsonNode; query: JsonNode;
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
  var valid_568041 = query.getOrDefault("api-version")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "api-version", valid_568041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568064: Call_OperationsList_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations.
  ## 
  let valid = call_568064.validator(path, query, header, formData, body)
  let scheme = call_568064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568064.url(scheme.get, call_568064.host, call_568064.base,
                         call_568064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568064, url, valid)

proc call*(call_568135: Call_OperationsList_567880; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  result = call_568135.call(nil, query_568136, nil, nil, nil)

var operationsList* = Call_OperationsList_567880(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.PolicyInsights/operations",
    validator: validate_OperationsList_567881, base: "", url: url_OperationsList_567882,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForManagementGroup_568176 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesListQueryResultsForManagementGroup_568178(protocol: Scheme;
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

proc validate_PolicyStatesListQueryResultsForManagementGroup_568177(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy states for the resources under the management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupName: JString (required)
  ##                      : Management group name.
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management resource provider; only "Microsoft.Management" is allowed.
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupName` field"
  var valid_568194 = path.getOrDefault("managementGroupName")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "managementGroupName", valid_568194
  var valid_568208 = path.getOrDefault("managementGroupsNamespace")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_568208 != nil:
    section.add "managementGroupsNamespace", valid_568208
  var valid_568209 = path.getOrDefault("policyStatesResource")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = newJString("default"))
  if valid_568209 != nil:
    section.add "policyStatesResource", valid_568209
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
  var valid_568210 = query.getOrDefault("$orderby")
  valid_568210 = validateParameter(valid_568210, JString, required = false,
                                 default = nil)
  if valid_568210 != nil:
    section.add "$orderby", valid_568210
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568211 = query.getOrDefault("api-version")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "api-version", valid_568211
  var valid_568212 = query.getOrDefault("$from")
  valid_568212 = validateParameter(valid_568212, JString, required = false,
                                 default = nil)
  if valid_568212 != nil:
    section.add "$from", valid_568212
  var valid_568213 = query.getOrDefault("$top")
  valid_568213 = validateParameter(valid_568213, JInt, required = false, default = nil)
  if valid_568213 != nil:
    section.add "$top", valid_568213
  var valid_568214 = query.getOrDefault("$select")
  valid_568214 = validateParameter(valid_568214, JString, required = false,
                                 default = nil)
  if valid_568214 != nil:
    section.add "$select", valid_568214
  var valid_568215 = query.getOrDefault("$to")
  valid_568215 = validateParameter(valid_568215, JString, required = false,
                                 default = nil)
  if valid_568215 != nil:
    section.add "$to", valid_568215
  var valid_568216 = query.getOrDefault("$apply")
  valid_568216 = validateParameter(valid_568216, JString, required = false,
                                 default = nil)
  if valid_568216 != nil:
    section.add "$apply", valid_568216
  var valid_568217 = query.getOrDefault("$filter")
  valid_568217 = validateParameter(valid_568217, JString, required = false,
                                 default = nil)
  if valid_568217 != nil:
    section.add "$filter", valid_568217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568218: Call_PolicyStatesListQueryResultsForManagementGroup_568176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resources under the management group.
  ## 
  let valid = call_568218.validator(path, query, header, formData, body)
  let scheme = call_568218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568218.url(scheme.get, call_568218.host, call_568218.base,
                         call_568218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568218, url, valid)

proc call*(call_568219: Call_PolicyStatesListQueryResultsForManagementGroup_568176;
          managementGroupName: string; apiVersion: string;
          managementGroupsNamespace: string = "Microsoft.Management";
          Orderby: string = ""; From: string = ""; Top: int = 0; Select: string = "";
          policyStatesResource: string = "default"; To: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## policyStatesListQueryResultsForManagementGroup
  ## Queries policy states for the resources under the management group.
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
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568220 = newJObject()
  var query_568221 = newJObject()
  add(path_568220, "managementGroupName", newJString(managementGroupName))
  add(path_568220, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_568221, "$orderby", newJString(Orderby))
  add(query_568221, "api-version", newJString(apiVersion))
  add(query_568221, "$from", newJString(From))
  add(query_568221, "$top", newJInt(Top))
  add(query_568221, "$select", newJString(Select))
  add(path_568220, "policyStatesResource", newJString(policyStatesResource))
  add(query_568221, "$to", newJString(To))
  add(query_568221, "$apply", newJString(Apply))
  add(query_568221, "$filter", newJString(Filter))
  result = call_568219.call(path_568220, query_568221, nil, nil, nil)

var policyStatesListQueryResultsForManagementGroup* = Call_PolicyStatesListQueryResultsForManagementGroup_568176(
    name: "policyStatesListQueryResultsForManagementGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForManagementGroup_568177,
    base: "", url: url_PolicyStatesListQueryResultsForManagementGroup_568178,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForSubscription_568222 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesListQueryResultsForSubscription_568224(protocol: Scheme;
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

proc validate_PolicyStatesListQueryResultsForSubscription_568223(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queries policy states for the resources under the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568225 = path.getOrDefault("subscriptionId")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "subscriptionId", valid_568225
  var valid_568226 = path.getOrDefault("policyStatesResource")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = newJString("default"))
  if valid_568226 != nil:
    section.add "policyStatesResource", valid_568226
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
  var valid_568227 = query.getOrDefault("$orderby")
  valid_568227 = validateParameter(valid_568227, JString, required = false,
                                 default = nil)
  if valid_568227 != nil:
    section.add "$orderby", valid_568227
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568228 = query.getOrDefault("api-version")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "api-version", valid_568228
  var valid_568229 = query.getOrDefault("$from")
  valid_568229 = validateParameter(valid_568229, JString, required = false,
                                 default = nil)
  if valid_568229 != nil:
    section.add "$from", valid_568229
  var valid_568230 = query.getOrDefault("$top")
  valid_568230 = validateParameter(valid_568230, JInt, required = false, default = nil)
  if valid_568230 != nil:
    section.add "$top", valid_568230
  var valid_568231 = query.getOrDefault("$select")
  valid_568231 = validateParameter(valid_568231, JString, required = false,
                                 default = nil)
  if valid_568231 != nil:
    section.add "$select", valid_568231
  var valid_568232 = query.getOrDefault("$to")
  valid_568232 = validateParameter(valid_568232, JString, required = false,
                                 default = nil)
  if valid_568232 != nil:
    section.add "$to", valid_568232
  var valid_568233 = query.getOrDefault("$apply")
  valid_568233 = validateParameter(valid_568233, JString, required = false,
                                 default = nil)
  if valid_568233 != nil:
    section.add "$apply", valid_568233
  var valid_568234 = query.getOrDefault("$filter")
  valid_568234 = validateParameter(valid_568234, JString, required = false,
                                 default = nil)
  if valid_568234 != nil:
    section.add "$filter", valid_568234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568235: Call_PolicyStatesListQueryResultsForSubscription_568222;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resources under the subscription.
  ## 
  let valid = call_568235.validator(path, query, header, formData, body)
  let scheme = call_568235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568235.url(scheme.get, call_568235.host, call_568235.base,
                         call_568235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568235, url, valid)

proc call*(call_568236: Call_PolicyStatesListQueryResultsForSubscription_568222;
          apiVersion: string; subscriptionId: string; Orderby: string = "";
          From: string = ""; Top: int = 0; Select: string = "";
          policyStatesResource: string = "default"; To: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## policyStatesListQueryResultsForSubscription
  ## Queries policy states for the resources under the subscription.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568237 = newJObject()
  var query_568238 = newJObject()
  add(query_568238, "$orderby", newJString(Orderby))
  add(query_568238, "api-version", newJString(apiVersion))
  add(query_568238, "$from", newJString(From))
  add(path_568237, "subscriptionId", newJString(subscriptionId))
  add(query_568238, "$top", newJInt(Top))
  add(query_568238, "$select", newJString(Select))
  add(path_568237, "policyStatesResource", newJString(policyStatesResource))
  add(query_568238, "$to", newJString(To))
  add(query_568238, "$apply", newJString(Apply))
  add(query_568238, "$filter", newJString(Filter))
  result = call_568236.call(path_568237, query_568238, nil, nil, nil)

var policyStatesListQueryResultsForSubscription* = Call_PolicyStatesListQueryResultsForSubscription_568222(
    name: "policyStatesListQueryResultsForSubscription",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForSubscription_568223,
    base: "", url: url_PolicyStatesListQueryResultsForSubscription_568224,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForResourceGroup_568239 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesListQueryResultsForResourceGroup_568241(protocol: Scheme;
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

proc validate_PolicyStatesListQueryResultsForResourceGroup_568240(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queries policy states for the resources under the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568242 = path.getOrDefault("resourceGroupName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "resourceGroupName", valid_568242
  var valid_568243 = path.getOrDefault("subscriptionId")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "subscriptionId", valid_568243
  var valid_568244 = path.getOrDefault("policyStatesResource")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = newJString("default"))
  if valid_568244 != nil:
    section.add "policyStatesResource", valid_568244
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
  var valid_568245 = query.getOrDefault("$orderby")
  valid_568245 = validateParameter(valid_568245, JString, required = false,
                                 default = nil)
  if valid_568245 != nil:
    section.add "$orderby", valid_568245
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568246 = query.getOrDefault("api-version")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "api-version", valid_568246
  var valid_568247 = query.getOrDefault("$from")
  valid_568247 = validateParameter(valid_568247, JString, required = false,
                                 default = nil)
  if valid_568247 != nil:
    section.add "$from", valid_568247
  var valid_568248 = query.getOrDefault("$top")
  valid_568248 = validateParameter(valid_568248, JInt, required = false, default = nil)
  if valid_568248 != nil:
    section.add "$top", valid_568248
  var valid_568249 = query.getOrDefault("$select")
  valid_568249 = validateParameter(valid_568249, JString, required = false,
                                 default = nil)
  if valid_568249 != nil:
    section.add "$select", valid_568249
  var valid_568250 = query.getOrDefault("$to")
  valid_568250 = validateParameter(valid_568250, JString, required = false,
                                 default = nil)
  if valid_568250 != nil:
    section.add "$to", valid_568250
  var valid_568251 = query.getOrDefault("$apply")
  valid_568251 = validateParameter(valid_568251, JString, required = false,
                                 default = nil)
  if valid_568251 != nil:
    section.add "$apply", valid_568251
  var valid_568252 = query.getOrDefault("$filter")
  valid_568252 = validateParameter(valid_568252, JString, required = false,
                                 default = nil)
  if valid_568252 != nil:
    section.add "$filter", valid_568252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568253: Call_PolicyStatesListQueryResultsForResourceGroup_568239;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resources under the resource group.
  ## 
  let valid = call_568253.validator(path, query, header, formData, body)
  let scheme = call_568253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568253.url(scheme.get, call_568253.host, call_568253.base,
                         call_568253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568253, url, valid)

proc call*(call_568254: Call_PolicyStatesListQueryResultsForResourceGroup_568239;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Orderby: string = ""; From: string = ""; Top: int = 0; Select: string = "";
          policyStatesResource: string = "default"; To: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## policyStatesListQueryResultsForResourceGroup
  ## Queries policy states for the resources under the resource group.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568255 = newJObject()
  var query_568256 = newJObject()
  add(query_568256, "$orderby", newJString(Orderby))
  add(path_568255, "resourceGroupName", newJString(resourceGroupName))
  add(query_568256, "api-version", newJString(apiVersion))
  add(query_568256, "$from", newJString(From))
  add(path_568255, "subscriptionId", newJString(subscriptionId))
  add(query_568256, "$top", newJInt(Top))
  add(query_568256, "$select", newJString(Select))
  add(path_568255, "policyStatesResource", newJString(policyStatesResource))
  add(query_568256, "$to", newJString(To))
  add(query_568256, "$apply", newJString(Apply))
  add(query_568256, "$filter", newJString(Filter))
  result = call_568254.call(path_568255, query_568256, nil, nil, nil)

var policyStatesListQueryResultsForResourceGroup* = Call_PolicyStatesListQueryResultsForResourceGroup_568239(
    name: "policyStatesListQueryResultsForResourceGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForResourceGroup_568240,
    base: "", url: url_PolicyStatesListQueryResultsForResourceGroup_568241,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForResource_568257 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesListQueryResultsForResource_568259(protocol: Scheme;
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

proc validate_PolicyStatesListQueryResultsForResource_568258(path: JsonNode;
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
  var valid_568260 = path.getOrDefault("policyStatesResource")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = newJString("default"))
  if valid_568260 != nil:
    section.add "policyStatesResource", valid_568260
  var valid_568261 = path.getOrDefault("resourceId")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "resourceId", valid_568261
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
  var valid_568262 = query.getOrDefault("$orderby")
  valid_568262 = validateParameter(valid_568262, JString, required = false,
                                 default = nil)
  if valid_568262 != nil:
    section.add "$orderby", valid_568262
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568263 = query.getOrDefault("api-version")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "api-version", valid_568263
  var valid_568264 = query.getOrDefault("$from")
  valid_568264 = validateParameter(valid_568264, JString, required = false,
                                 default = nil)
  if valid_568264 != nil:
    section.add "$from", valid_568264
  var valid_568265 = query.getOrDefault("$top")
  valid_568265 = validateParameter(valid_568265, JInt, required = false, default = nil)
  if valid_568265 != nil:
    section.add "$top", valid_568265
  var valid_568266 = query.getOrDefault("$select")
  valid_568266 = validateParameter(valid_568266, JString, required = false,
                                 default = nil)
  if valid_568266 != nil:
    section.add "$select", valid_568266
  var valid_568267 = query.getOrDefault("$to")
  valid_568267 = validateParameter(valid_568267, JString, required = false,
                                 default = nil)
  if valid_568267 != nil:
    section.add "$to", valid_568267
  var valid_568268 = query.getOrDefault("$apply")
  valid_568268 = validateParameter(valid_568268, JString, required = false,
                                 default = nil)
  if valid_568268 != nil:
    section.add "$apply", valid_568268
  var valid_568269 = query.getOrDefault("$filter")
  valid_568269 = validateParameter(valid_568269, JString, required = false,
                                 default = nil)
  if valid_568269 != nil:
    section.add "$filter", valid_568269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568270: Call_PolicyStatesListQueryResultsForResource_568257;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resource.
  ## 
  let valid = call_568270.validator(path, query, header, formData, body)
  let scheme = call_568270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568270.url(scheme.get, call_568270.host, call_568270.base,
                         call_568270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568270, url, valid)

proc call*(call_568271: Call_PolicyStatesListQueryResultsForResource_568257;
          apiVersion: string; resourceId: string; Orderby: string = "";
          From: string = ""; Top: int = 0; Select: string = "";
          policyStatesResource: string = "default"; To: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## policyStatesListQueryResultsForResource
  ## Queries policy states for the resource.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   resourceId: string (required)
  ##             : Resource ID.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568272 = newJObject()
  var query_568273 = newJObject()
  add(query_568273, "$orderby", newJString(Orderby))
  add(query_568273, "api-version", newJString(apiVersion))
  add(query_568273, "$from", newJString(From))
  add(query_568273, "$top", newJInt(Top))
  add(query_568273, "$select", newJString(Select))
  add(path_568272, "policyStatesResource", newJString(policyStatesResource))
  add(path_568272, "resourceId", newJString(resourceId))
  add(query_568273, "$to", newJString(To))
  add(query_568273, "$apply", newJString(Apply))
  add(query_568273, "$filter", newJString(Filter))
  result = call_568271.call(path_568272, query_568273, nil, nil, nil)

var policyStatesListQueryResultsForResource* = Call_PolicyStatesListQueryResultsForResource_568257(
    name: "policyStatesListQueryResultsForResource", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForResource_568258, base: "",
    url: url_PolicyStatesListQueryResultsForResource_568259,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesGetMetadata_568274 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesGetMetadata_568276(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyStatesGetMetadata_568275(path: JsonNode; query: JsonNode;
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
  var valid_568277 = path.getOrDefault("scope")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "scope", valid_568277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version to use with the client requests.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568278 = query.getOrDefault("api-version")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "api-version", valid_568278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568279: Call_PolicyStatesGetMetadata_568274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets OData metadata XML document.
  ## 
  let valid = call_568279.validator(path, query, header, formData, body)
  let scheme = call_568279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568279.url(scheme.get, call_568279.host, call_568279.base,
                         call_568279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568279, url, valid)

proc call*(call_568280: Call_PolicyStatesGetMetadata_568274; apiVersion: string;
          scope: string): Recallable =
  ## policyStatesGetMetadata
  ## Gets OData metadata XML document.
  ##   apiVersion: string (required)
  ##             : API version to use with the client requests.
  ##   scope: string (required)
  ##        : A valid scope, i.e. management group, subscription, resource group, or resource ID. Scope used has no effect on metadata returned.
  var path_568281 = newJObject()
  var query_568282 = newJObject()
  add(query_568282, "api-version", newJString(apiVersion))
  add(path_568281, "scope", newJString(scope))
  result = call_568280.call(path_568281, query_568282, nil, nil, nil)

var policyStatesGetMetadata* = Call_PolicyStatesGetMetadata_568274(
    name: "policyStatesGetMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.PolicyInsights/policyStates/$metadata",
    validator: validate_PolicyStatesGetMetadata_568275, base: "",
    url: url_PolicyStatesGetMetadata_568276, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
