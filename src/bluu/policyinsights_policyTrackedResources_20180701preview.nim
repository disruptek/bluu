
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: PolicyTrackedResourcesClient
## version: 2018-07-01-preview
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "policyinsights-policyTrackedResources"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicyTrackedResourcesListQueryResultsForManagementGroup_563777 = ref object of OpenApiRestCall_563555
proc url_PolicyTrackedResourcesListQueryResultsForManagementGroup_563779(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupsNamespace" in path,
        "`managementGroupsNamespace` is a required path parameter"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "policyTrackedResourcesResource" in path,
        "`policyTrackedResourcesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "managementGroupsNamespace"),
               (kind: ConstantSegment, value: "/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyTrackedResources/"), (
        kind: VariableSegment, value: "policyTrackedResourcesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyTrackedResourcesListQueryResultsForManagementGroup_563778(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy tracked resources under the management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupName: JString (required)
  ##                      : Management group name.
  ##   policyTrackedResourcesResource: JString (required)
  ##                                 : The name of the virtual resource under PolicyTrackedResources resource type; only "default" is allowed.
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupName` field"
  var valid_563955 = path.getOrDefault("managementGroupName")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "managementGroupName", valid_563955
  var valid_563969 = path.getOrDefault("policyTrackedResourcesResource")
  valid_563969 = validateParameter(valid_563969, JString, required = true,
                                 default = newJString("default"))
  if valid_563969 != nil:
    section.add "policyTrackedResourcesResource", valid_563969
  var valid_563970 = path.getOrDefault("managementGroupsNamespace")
  valid_563970 = validateParameter(valid_563970, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_563970 != nil:
    section.add "managementGroupsNamespace", valid_563970
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_563971 = query.getOrDefault("$top")
  valid_563971 = validateParameter(valid_563971, JInt, required = false, default = nil)
  if valid_563971 != nil:
    section.add "$top", valid_563971
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563972 = query.getOrDefault("api-version")
  valid_563972 = validateParameter(valid_563972, JString, required = true,
                                 default = nil)
  if valid_563972 != nil:
    section.add "api-version", valid_563972
  var valid_563973 = query.getOrDefault("$filter")
  valid_563973 = validateParameter(valid_563973, JString, required = false,
                                 default = nil)
  if valid_563973 != nil:
    section.add "$filter", valid_563973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563996: Call_PolicyTrackedResourcesListQueryResultsForManagementGroup_563777;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy tracked resources under the management group.
  ## 
  let valid = call_563996.validator(path, query, header, formData, body)
  let scheme = call_563996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563996.url(scheme.get, call_563996.host, call_563996.base,
                         call_563996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563996, url, valid)

proc call*(call_564067: Call_PolicyTrackedResourcesListQueryResultsForManagementGroup_563777;
          managementGroupName: string; apiVersion: string; Top: int = 0;
          policyTrackedResourcesResource: string = "default";
          managementGroupsNamespace: string = "Microsoft.Management";
          Filter: string = ""): Recallable =
  ## policyTrackedResourcesListQueryResultsForManagementGroup
  ## Queries policy tracked resources under the management group.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   managementGroupName: string (required)
  ##                      : Management group name.
  ##   policyTrackedResourcesResource: string (required)
  ##                                 : The name of the virtual resource under PolicyTrackedResources resource type; only "default" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   Filter: string
  ##         : OData filter expression.
  var path_564068 = newJObject()
  var query_564070 = newJObject()
  add(query_564070, "$top", newJInt(Top))
  add(path_564068, "managementGroupName", newJString(managementGroupName))
  add(path_564068, "policyTrackedResourcesResource",
      newJString(policyTrackedResourcesResource))
  add(query_564070, "api-version", newJString(apiVersion))
  add(path_564068, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_564070, "$filter", newJString(Filter))
  result = call_564067.call(path_564068, query_564070, nil, nil, nil)

var policyTrackedResourcesListQueryResultsForManagementGroup* = Call_PolicyTrackedResourcesListQueryResultsForManagementGroup_563777(
    name: "policyTrackedResourcesListQueryResultsForManagementGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupName}/providers/Microsoft.PolicyInsights/policyTrackedResources/{policyTrackedResourcesResource}/queryResults", validator: validate_PolicyTrackedResourcesListQueryResultsForManagementGroup_563778,
    base: "", url: url_PolicyTrackedResourcesListQueryResultsForManagementGroup_563779,
    schemes: {Scheme.Https})
type
  Call_PolicyTrackedResourcesListQueryResultsForSubscription_564109 = ref object of OpenApiRestCall_563555
proc url_PolicyTrackedResourcesListQueryResultsForSubscription_564111(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "policyTrackedResourcesResource" in path,
        "`policyTrackedResourcesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyTrackedResources/"), (
        kind: VariableSegment, value: "policyTrackedResourcesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyTrackedResourcesListQueryResultsForSubscription_564110(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy tracked resources under the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyTrackedResourcesResource: JString (required)
  ##                                 : The name of the virtual resource under PolicyTrackedResources resource type; only "default" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyTrackedResourcesResource` field"
  var valid_564112 = path.getOrDefault("policyTrackedResourcesResource")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = newJString("default"))
  if valid_564112 != nil:
    section.add "policyTrackedResourcesResource", valid_564112
  var valid_564113 = path.getOrDefault("subscriptionId")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "subscriptionId", valid_564113
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_564114 = query.getOrDefault("$top")
  valid_564114 = validateParameter(valid_564114, JInt, required = false, default = nil)
  if valid_564114 != nil:
    section.add "$top", valid_564114
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564115 = query.getOrDefault("api-version")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "api-version", valid_564115
  var valid_564116 = query.getOrDefault("$filter")
  valid_564116 = validateParameter(valid_564116, JString, required = false,
                                 default = nil)
  if valid_564116 != nil:
    section.add "$filter", valid_564116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564117: Call_PolicyTrackedResourcesListQueryResultsForSubscription_564109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy tracked resources under the subscription.
  ## 
  let valid = call_564117.validator(path, query, header, formData, body)
  let scheme = call_564117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564117.url(scheme.get, call_564117.host, call_564117.base,
                         call_564117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564117, url, valid)

proc call*(call_564118: Call_PolicyTrackedResourcesListQueryResultsForSubscription_564109;
          apiVersion: string; subscriptionId: string; Top: int = 0;
          policyTrackedResourcesResource: string = "default"; Filter: string = ""): Recallable =
  ## policyTrackedResourcesListQueryResultsForSubscription
  ## Queries policy tracked resources under the subscription.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   policyTrackedResourcesResource: string (required)
  ##                                 : The name of the virtual resource under PolicyTrackedResources resource type; only "default" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Filter: string
  ##         : OData filter expression.
  var path_564119 = newJObject()
  var query_564120 = newJObject()
  add(query_564120, "$top", newJInt(Top))
  add(path_564119, "policyTrackedResourcesResource",
      newJString(policyTrackedResourcesResource))
  add(query_564120, "api-version", newJString(apiVersion))
  add(path_564119, "subscriptionId", newJString(subscriptionId))
  add(query_564120, "$filter", newJString(Filter))
  result = call_564118.call(path_564119, query_564120, nil, nil, nil)

var policyTrackedResourcesListQueryResultsForSubscription* = Call_PolicyTrackedResourcesListQueryResultsForSubscription_564109(
    name: "policyTrackedResourcesListQueryResultsForSubscription",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/policyTrackedResources/{policyTrackedResourcesResource}/queryResults",
    validator: validate_PolicyTrackedResourcesListQueryResultsForSubscription_564110,
    base: "", url: url_PolicyTrackedResourcesListQueryResultsForSubscription_564111,
    schemes: {Scheme.Https})
type
  Call_PolicyTrackedResourcesListQueryResultsForResourceGroup_564121 = ref object of OpenApiRestCall_563555
proc url_PolicyTrackedResourcesListQueryResultsForResourceGroup_564123(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "policyTrackedResourcesResource" in path,
        "`policyTrackedResourcesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyTrackedResources/"), (
        kind: VariableSegment, value: "policyTrackedResourcesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyTrackedResourcesListQueryResultsForResourceGroup_564122(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy tracked resources under the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyTrackedResourcesResource: JString (required)
  ##                                 : The name of the virtual resource under PolicyTrackedResources resource type; only "default" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyTrackedResourcesResource` field"
  var valid_564124 = path.getOrDefault("policyTrackedResourcesResource")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = newJString("default"))
  if valid_564124 != nil:
    section.add "policyTrackedResourcesResource", valid_564124
  var valid_564125 = path.getOrDefault("subscriptionId")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "subscriptionId", valid_564125
  var valid_564126 = path.getOrDefault("resourceGroupName")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "resourceGroupName", valid_564126
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_564127 = query.getOrDefault("$top")
  valid_564127 = validateParameter(valid_564127, JInt, required = false, default = nil)
  if valid_564127 != nil:
    section.add "$top", valid_564127
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564128 = query.getOrDefault("api-version")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "api-version", valid_564128
  var valid_564129 = query.getOrDefault("$filter")
  valid_564129 = validateParameter(valid_564129, JString, required = false,
                                 default = nil)
  if valid_564129 != nil:
    section.add "$filter", valid_564129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564130: Call_PolicyTrackedResourcesListQueryResultsForResourceGroup_564121;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy tracked resources under the resource group.
  ## 
  let valid = call_564130.validator(path, query, header, formData, body)
  let scheme = call_564130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564130.url(scheme.get, call_564130.host, call_564130.base,
                         call_564130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564130, url, valid)

proc call*(call_564131: Call_PolicyTrackedResourcesListQueryResultsForResourceGroup_564121;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; policyTrackedResourcesResource: string = "default";
          Filter: string = ""): Recallable =
  ## policyTrackedResourcesListQueryResultsForResourceGroup
  ## Queries policy tracked resources under the resource group.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   policyTrackedResourcesResource: string (required)
  ##                                 : The name of the virtual resource under PolicyTrackedResources resource type; only "default" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   Filter: string
  ##         : OData filter expression.
  var path_564132 = newJObject()
  var query_564133 = newJObject()
  add(query_564133, "$top", newJInt(Top))
  add(path_564132, "policyTrackedResourcesResource",
      newJString(policyTrackedResourcesResource))
  add(query_564133, "api-version", newJString(apiVersion))
  add(path_564132, "subscriptionId", newJString(subscriptionId))
  add(path_564132, "resourceGroupName", newJString(resourceGroupName))
  add(query_564133, "$filter", newJString(Filter))
  result = call_564131.call(path_564132, query_564133, nil, nil, nil)

var policyTrackedResourcesListQueryResultsForResourceGroup* = Call_PolicyTrackedResourcesListQueryResultsForResourceGroup_564121(
    name: "policyTrackedResourcesListQueryResultsForResourceGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/policyTrackedResources/{policyTrackedResourcesResource}/queryResults",
    validator: validate_PolicyTrackedResourcesListQueryResultsForResourceGroup_564122,
    base: "", url: url_PolicyTrackedResourcesListQueryResultsForResourceGroup_564123,
    schemes: {Scheme.Https})
type
  Call_PolicyTrackedResourcesListQueryResultsForResource_564134 = ref object of OpenApiRestCall_563555
proc url_PolicyTrackedResourcesListQueryResultsForResource_564136(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "policyTrackedResourcesResource" in path,
        "`policyTrackedResourcesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyTrackedResources/"), (
        kind: VariableSegment, value: "policyTrackedResourcesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyTrackedResourcesListQueryResultsForResource_564135(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy tracked resources under the resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyTrackedResourcesResource: JString (required)
  ##                                 : The name of the virtual resource under PolicyTrackedResources resource type; only "default" is allowed.
  ##   resourceId: JString (required)
  ##             : Resource ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyTrackedResourcesResource` field"
  var valid_564137 = path.getOrDefault("policyTrackedResourcesResource")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = newJString("default"))
  if valid_564137 != nil:
    section.add "policyTrackedResourcesResource", valid_564137
  var valid_564138 = path.getOrDefault("resourceId")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "resourceId", valid_564138
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_564139 = query.getOrDefault("$top")
  valid_564139 = validateParameter(valid_564139, JInt, required = false, default = nil)
  if valid_564139 != nil:
    section.add "$top", valid_564139
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564140 = query.getOrDefault("api-version")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "api-version", valid_564140
  var valid_564141 = query.getOrDefault("$filter")
  valid_564141 = validateParameter(valid_564141, JString, required = false,
                                 default = nil)
  if valid_564141 != nil:
    section.add "$filter", valid_564141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564142: Call_PolicyTrackedResourcesListQueryResultsForResource_564134;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy tracked resources under the resource.
  ## 
  let valid = call_564142.validator(path, query, header, formData, body)
  let scheme = call_564142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564142.url(scheme.get, call_564142.host, call_564142.base,
                         call_564142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564142, url, valid)

proc call*(call_564143: Call_PolicyTrackedResourcesListQueryResultsForResource_564134;
          apiVersion: string; resourceId: string; Top: int = 0;
          policyTrackedResourcesResource: string = "default"; Filter: string = ""): Recallable =
  ## policyTrackedResourcesListQueryResultsForResource
  ## Queries policy tracked resources under the resource.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   policyTrackedResourcesResource: string (required)
  ##                                 : The name of the virtual resource under PolicyTrackedResources resource type; only "default" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Filter: string
  ##         : OData filter expression.
  ##   resourceId: string (required)
  ##             : Resource ID.
  var path_564144 = newJObject()
  var query_564145 = newJObject()
  add(query_564145, "$top", newJInt(Top))
  add(path_564144, "policyTrackedResourcesResource",
      newJString(policyTrackedResourcesResource))
  add(query_564145, "api-version", newJString(apiVersion))
  add(query_564145, "$filter", newJString(Filter))
  add(path_564144, "resourceId", newJString(resourceId))
  result = call_564143.call(path_564144, query_564145, nil, nil, nil)

var policyTrackedResourcesListQueryResultsForResource* = Call_PolicyTrackedResourcesListQueryResultsForResource_564134(
    name: "policyTrackedResourcesListQueryResultsForResource",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/policyTrackedResources/{policyTrackedResourcesResource}/queryResults",
    validator: validate_PolicyTrackedResourcesListQueryResultsForResource_564135,
    base: "", url: url_PolicyTrackedResourcesListQueryResultsForResource_564136,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
