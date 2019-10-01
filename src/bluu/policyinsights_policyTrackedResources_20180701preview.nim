
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "policyinsights-policyTrackedResources"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicyTrackedResourcesListQueryResultsForManagementGroup_567879 = ref object of OpenApiRestCall_567657
proc url_PolicyTrackedResourcesListQueryResultsForManagementGroup_567881(
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

proc validate_PolicyTrackedResourcesListQueryResultsForManagementGroup_567880(
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
  var valid_568055 = path.getOrDefault("managementGroupName")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "managementGroupName", valid_568055
  var valid_568069 = path.getOrDefault("policyTrackedResourcesResource")
  valid_568069 = validateParameter(valid_568069, JString, required = true,
                                 default = newJString("default"))
  if valid_568069 != nil:
    section.add "policyTrackedResourcesResource", valid_568069
  var valid_568070 = path.getOrDefault("managementGroupsNamespace")
  valid_568070 = validateParameter(valid_568070, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_568070 != nil:
    section.add "managementGroupsNamespace", valid_568070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568071 = query.getOrDefault("api-version")
  valid_568071 = validateParameter(valid_568071, JString, required = true,
                                 default = nil)
  if valid_568071 != nil:
    section.add "api-version", valid_568071
  var valid_568072 = query.getOrDefault("$top")
  valid_568072 = validateParameter(valid_568072, JInt, required = false, default = nil)
  if valid_568072 != nil:
    section.add "$top", valid_568072
  var valid_568073 = query.getOrDefault("$filter")
  valid_568073 = validateParameter(valid_568073, JString, required = false,
                                 default = nil)
  if valid_568073 != nil:
    section.add "$filter", valid_568073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568096: Call_PolicyTrackedResourcesListQueryResultsForManagementGroup_567879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy tracked resources under the management group.
  ## 
  let valid = call_568096.validator(path, query, header, formData, body)
  let scheme = call_568096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568096.url(scheme.get, call_568096.host, call_568096.base,
                         call_568096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568096, url, valid)

proc call*(call_568167: Call_PolicyTrackedResourcesListQueryResultsForManagementGroup_567879;
          managementGroupName: string; apiVersion: string;
          policyTrackedResourcesResource: string = "default";
          managementGroupsNamespace: string = "Microsoft.Management"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## policyTrackedResourcesListQueryResultsForManagementGroup
  ## Queries policy tracked resources under the management group.
  ##   managementGroupName: string (required)
  ##                      : Management group name.
  ##   policyTrackedResourcesResource: string (required)
  ##                                 : The name of the virtual resource under PolicyTrackedResources resource type; only "default" is allowed.
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568168 = newJObject()
  var query_568170 = newJObject()
  add(path_568168, "managementGroupName", newJString(managementGroupName))
  add(path_568168, "policyTrackedResourcesResource",
      newJString(policyTrackedResourcesResource))
  add(path_568168, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_568170, "api-version", newJString(apiVersion))
  add(query_568170, "$top", newJInt(Top))
  add(query_568170, "$filter", newJString(Filter))
  result = call_568167.call(path_568168, query_568170, nil, nil, nil)

var policyTrackedResourcesListQueryResultsForManagementGroup* = Call_PolicyTrackedResourcesListQueryResultsForManagementGroup_567879(
    name: "policyTrackedResourcesListQueryResultsForManagementGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupName}/providers/Microsoft.PolicyInsights/policyTrackedResources/{policyTrackedResourcesResource}/queryResults", validator: validate_PolicyTrackedResourcesListQueryResultsForManagementGroup_567880,
    base: "", url: url_PolicyTrackedResourcesListQueryResultsForManagementGroup_567881,
    schemes: {Scheme.Https})
type
  Call_PolicyTrackedResourcesListQueryResultsForSubscription_568209 = ref object of OpenApiRestCall_567657
proc url_PolicyTrackedResourcesListQueryResultsForSubscription_568211(
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

proc validate_PolicyTrackedResourcesListQueryResultsForSubscription_568210(
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
  var valid_568212 = path.getOrDefault("policyTrackedResourcesResource")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = newJString("default"))
  if valid_568212 != nil:
    section.add "policyTrackedResourcesResource", valid_568212
  var valid_568213 = path.getOrDefault("subscriptionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "subscriptionId", valid_568213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568214 = query.getOrDefault("api-version")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "api-version", valid_568214
  var valid_568215 = query.getOrDefault("$top")
  valid_568215 = validateParameter(valid_568215, JInt, required = false, default = nil)
  if valid_568215 != nil:
    section.add "$top", valid_568215
  var valid_568216 = query.getOrDefault("$filter")
  valid_568216 = validateParameter(valid_568216, JString, required = false,
                                 default = nil)
  if valid_568216 != nil:
    section.add "$filter", valid_568216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568217: Call_PolicyTrackedResourcesListQueryResultsForSubscription_568209;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy tracked resources under the subscription.
  ## 
  let valid = call_568217.validator(path, query, header, formData, body)
  let scheme = call_568217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568217.url(scheme.get, call_568217.host, call_568217.base,
                         call_568217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568217, url, valid)

proc call*(call_568218: Call_PolicyTrackedResourcesListQueryResultsForSubscription_568209;
          apiVersion: string; subscriptionId: string;
          policyTrackedResourcesResource: string = "default"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## policyTrackedResourcesListQueryResultsForSubscription
  ## Queries policy tracked resources under the subscription.
  ##   policyTrackedResourcesResource: string (required)
  ##                                 : The name of the virtual resource under PolicyTrackedResources resource type; only "default" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568219 = newJObject()
  var query_568220 = newJObject()
  add(path_568219, "policyTrackedResourcesResource",
      newJString(policyTrackedResourcesResource))
  add(query_568220, "api-version", newJString(apiVersion))
  add(path_568219, "subscriptionId", newJString(subscriptionId))
  add(query_568220, "$top", newJInt(Top))
  add(query_568220, "$filter", newJString(Filter))
  result = call_568218.call(path_568219, query_568220, nil, nil, nil)

var policyTrackedResourcesListQueryResultsForSubscription* = Call_PolicyTrackedResourcesListQueryResultsForSubscription_568209(
    name: "policyTrackedResourcesListQueryResultsForSubscription",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/policyTrackedResources/{policyTrackedResourcesResource}/queryResults",
    validator: validate_PolicyTrackedResourcesListQueryResultsForSubscription_568210,
    base: "", url: url_PolicyTrackedResourcesListQueryResultsForSubscription_568211,
    schemes: {Scheme.Https})
type
  Call_PolicyTrackedResourcesListQueryResultsForResourceGroup_568221 = ref object of OpenApiRestCall_567657
proc url_PolicyTrackedResourcesListQueryResultsForResourceGroup_568223(
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

proc validate_PolicyTrackedResourcesListQueryResultsForResourceGroup_568222(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy tracked resources under the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyTrackedResourcesResource: JString (required)
  ##                                 : The name of the virtual resource under PolicyTrackedResources resource type; only "default" is allowed.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyTrackedResourcesResource` field"
  var valid_568224 = path.getOrDefault("policyTrackedResourcesResource")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = newJString("default"))
  if valid_568224 != nil:
    section.add "policyTrackedResourcesResource", valid_568224
  var valid_568225 = path.getOrDefault("resourceGroupName")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "resourceGroupName", valid_568225
  var valid_568226 = path.getOrDefault("subscriptionId")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "subscriptionId", valid_568226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568227 = query.getOrDefault("api-version")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "api-version", valid_568227
  var valid_568228 = query.getOrDefault("$top")
  valid_568228 = validateParameter(valid_568228, JInt, required = false, default = nil)
  if valid_568228 != nil:
    section.add "$top", valid_568228
  var valid_568229 = query.getOrDefault("$filter")
  valid_568229 = validateParameter(valid_568229, JString, required = false,
                                 default = nil)
  if valid_568229 != nil:
    section.add "$filter", valid_568229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568230: Call_PolicyTrackedResourcesListQueryResultsForResourceGroup_568221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy tracked resources under the resource group.
  ## 
  let valid = call_568230.validator(path, query, header, formData, body)
  let scheme = call_568230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568230.url(scheme.get, call_568230.host, call_568230.base,
                         call_568230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568230, url, valid)

proc call*(call_568231: Call_PolicyTrackedResourcesListQueryResultsForResourceGroup_568221;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyTrackedResourcesResource: string = "default"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## policyTrackedResourcesListQueryResultsForResourceGroup
  ## Queries policy tracked resources under the resource group.
  ##   policyTrackedResourcesResource: string (required)
  ##                                 : The name of the virtual resource under PolicyTrackedResources resource type; only "default" is allowed.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568232 = newJObject()
  var query_568233 = newJObject()
  add(path_568232, "policyTrackedResourcesResource",
      newJString(policyTrackedResourcesResource))
  add(path_568232, "resourceGroupName", newJString(resourceGroupName))
  add(query_568233, "api-version", newJString(apiVersion))
  add(path_568232, "subscriptionId", newJString(subscriptionId))
  add(query_568233, "$top", newJInt(Top))
  add(query_568233, "$filter", newJString(Filter))
  result = call_568231.call(path_568232, query_568233, nil, nil, nil)

var policyTrackedResourcesListQueryResultsForResourceGroup* = Call_PolicyTrackedResourcesListQueryResultsForResourceGroup_568221(
    name: "policyTrackedResourcesListQueryResultsForResourceGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/policyTrackedResources/{policyTrackedResourcesResource}/queryResults",
    validator: validate_PolicyTrackedResourcesListQueryResultsForResourceGroup_568222,
    base: "", url: url_PolicyTrackedResourcesListQueryResultsForResourceGroup_568223,
    schemes: {Scheme.Https})
type
  Call_PolicyTrackedResourcesListQueryResultsForResource_568234 = ref object of OpenApiRestCall_567657
proc url_PolicyTrackedResourcesListQueryResultsForResource_568236(
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

proc validate_PolicyTrackedResourcesListQueryResultsForResource_568235(
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
  var valid_568237 = path.getOrDefault("policyTrackedResourcesResource")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = newJString("default"))
  if valid_568237 != nil:
    section.add "policyTrackedResourcesResource", valid_568237
  var valid_568238 = path.getOrDefault("resourceId")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "resourceId", valid_568238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568239 = query.getOrDefault("api-version")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "api-version", valid_568239
  var valid_568240 = query.getOrDefault("$top")
  valid_568240 = validateParameter(valid_568240, JInt, required = false, default = nil)
  if valid_568240 != nil:
    section.add "$top", valid_568240
  var valid_568241 = query.getOrDefault("$filter")
  valid_568241 = validateParameter(valid_568241, JString, required = false,
                                 default = nil)
  if valid_568241 != nil:
    section.add "$filter", valid_568241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568242: Call_PolicyTrackedResourcesListQueryResultsForResource_568234;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy tracked resources under the resource.
  ## 
  let valid = call_568242.validator(path, query, header, formData, body)
  let scheme = call_568242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568242.url(scheme.get, call_568242.host, call_568242.base,
                         call_568242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568242, url, valid)

proc call*(call_568243: Call_PolicyTrackedResourcesListQueryResultsForResource_568234;
          apiVersion: string; resourceId: string;
          policyTrackedResourcesResource: string = "default"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## policyTrackedResourcesListQueryResultsForResource
  ## Queries policy tracked resources under the resource.
  ##   policyTrackedResourcesResource: string (required)
  ##                                 : The name of the virtual resource under PolicyTrackedResources resource type; only "default" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   resourceId: string (required)
  ##             : Resource ID.
  ##   Filter: string
  ##         : OData filter expression.
  var path_568244 = newJObject()
  var query_568245 = newJObject()
  add(path_568244, "policyTrackedResourcesResource",
      newJString(policyTrackedResourcesResource))
  add(query_568245, "api-version", newJString(apiVersion))
  add(query_568245, "$top", newJInt(Top))
  add(path_568244, "resourceId", newJString(resourceId))
  add(query_568245, "$filter", newJString(Filter))
  result = call_568243.call(path_568244, query_568245, nil, nil, nil)

var policyTrackedResourcesListQueryResultsForResource* = Call_PolicyTrackedResourcesListQueryResultsForResource_568234(
    name: "policyTrackedResourcesListQueryResultsForResource",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/policyTrackedResources/{policyTrackedResourcesResource}/queryResults",
    validator: validate_PolicyTrackedResourcesListQueryResultsForResource_568235,
    base: "", url: url_PolicyTrackedResourcesListQueryResultsForResource_568236,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
