
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "policyinsights-policyTrackedResources"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicyTrackedResourcesListQueryResultsForManagementGroup_593646 = ref object of OpenApiRestCall_593424
proc url_PolicyTrackedResourcesListQueryResultsForManagementGroup_593648(
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

proc validate_PolicyTrackedResourcesListQueryResultsForManagementGroup_593647(
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
  var valid_593822 = path.getOrDefault("managementGroupName")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "managementGroupName", valid_593822
  var valid_593836 = path.getOrDefault("policyTrackedResourcesResource")
  valid_593836 = validateParameter(valid_593836, JString, required = true,
                                 default = newJString("default"))
  if valid_593836 != nil:
    section.add "policyTrackedResourcesResource", valid_593836
  var valid_593837 = path.getOrDefault("managementGroupsNamespace")
  valid_593837 = validateParameter(valid_593837, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_593837 != nil:
    section.add "managementGroupsNamespace", valid_593837
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
  var valid_593838 = query.getOrDefault("api-version")
  valid_593838 = validateParameter(valid_593838, JString, required = true,
                                 default = nil)
  if valid_593838 != nil:
    section.add "api-version", valid_593838
  var valid_593839 = query.getOrDefault("$top")
  valid_593839 = validateParameter(valid_593839, JInt, required = false, default = nil)
  if valid_593839 != nil:
    section.add "$top", valid_593839
  var valid_593840 = query.getOrDefault("$filter")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "$filter", valid_593840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593863: Call_PolicyTrackedResourcesListQueryResultsForManagementGroup_593646;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy tracked resources under the management group.
  ## 
  let valid = call_593863.validator(path, query, header, formData, body)
  let scheme = call_593863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593863.url(scheme.get, call_593863.host, call_593863.base,
                         call_593863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593863, url, valid)

proc call*(call_593934: Call_PolicyTrackedResourcesListQueryResultsForManagementGroup_593646;
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
  var path_593935 = newJObject()
  var query_593937 = newJObject()
  add(path_593935, "managementGroupName", newJString(managementGroupName))
  add(path_593935, "policyTrackedResourcesResource",
      newJString(policyTrackedResourcesResource))
  add(path_593935, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_593937, "api-version", newJString(apiVersion))
  add(query_593937, "$top", newJInt(Top))
  add(query_593937, "$filter", newJString(Filter))
  result = call_593934.call(path_593935, query_593937, nil, nil, nil)

var policyTrackedResourcesListQueryResultsForManagementGroup* = Call_PolicyTrackedResourcesListQueryResultsForManagementGroup_593646(
    name: "policyTrackedResourcesListQueryResultsForManagementGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupName}/providers/Microsoft.PolicyInsights/policyTrackedResources/{policyTrackedResourcesResource}/queryResults", validator: validate_PolicyTrackedResourcesListQueryResultsForManagementGroup_593647,
    base: "", url: url_PolicyTrackedResourcesListQueryResultsForManagementGroup_593648,
    schemes: {Scheme.Https})
type
  Call_PolicyTrackedResourcesListQueryResultsForSubscription_593976 = ref object of OpenApiRestCall_593424
proc url_PolicyTrackedResourcesListQueryResultsForSubscription_593978(
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

proc validate_PolicyTrackedResourcesListQueryResultsForSubscription_593977(
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
  var valid_593979 = path.getOrDefault("policyTrackedResourcesResource")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = newJString("default"))
  if valid_593979 != nil:
    section.add "policyTrackedResourcesResource", valid_593979
  var valid_593980 = path.getOrDefault("subscriptionId")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "subscriptionId", valid_593980
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
  var valid_593981 = query.getOrDefault("api-version")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "api-version", valid_593981
  var valid_593982 = query.getOrDefault("$top")
  valid_593982 = validateParameter(valid_593982, JInt, required = false, default = nil)
  if valid_593982 != nil:
    section.add "$top", valid_593982
  var valid_593983 = query.getOrDefault("$filter")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "$filter", valid_593983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593984: Call_PolicyTrackedResourcesListQueryResultsForSubscription_593976;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy tracked resources under the subscription.
  ## 
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_PolicyTrackedResourcesListQueryResultsForSubscription_593976;
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
  var path_593986 = newJObject()
  var query_593987 = newJObject()
  add(path_593986, "policyTrackedResourcesResource",
      newJString(policyTrackedResourcesResource))
  add(query_593987, "api-version", newJString(apiVersion))
  add(path_593986, "subscriptionId", newJString(subscriptionId))
  add(query_593987, "$top", newJInt(Top))
  add(query_593987, "$filter", newJString(Filter))
  result = call_593985.call(path_593986, query_593987, nil, nil, nil)

var policyTrackedResourcesListQueryResultsForSubscription* = Call_PolicyTrackedResourcesListQueryResultsForSubscription_593976(
    name: "policyTrackedResourcesListQueryResultsForSubscription",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/policyTrackedResources/{policyTrackedResourcesResource}/queryResults",
    validator: validate_PolicyTrackedResourcesListQueryResultsForSubscription_593977,
    base: "", url: url_PolicyTrackedResourcesListQueryResultsForSubscription_593978,
    schemes: {Scheme.Https})
type
  Call_PolicyTrackedResourcesListQueryResultsForResourceGroup_593988 = ref object of OpenApiRestCall_593424
proc url_PolicyTrackedResourcesListQueryResultsForResourceGroup_593990(
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

proc validate_PolicyTrackedResourcesListQueryResultsForResourceGroup_593989(
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
  var valid_593991 = path.getOrDefault("policyTrackedResourcesResource")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = newJString("default"))
  if valid_593991 != nil:
    section.add "policyTrackedResourcesResource", valid_593991
  var valid_593992 = path.getOrDefault("resourceGroupName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "resourceGroupName", valid_593992
  var valid_593993 = path.getOrDefault("subscriptionId")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "subscriptionId", valid_593993
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
  var valid_593994 = query.getOrDefault("api-version")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "api-version", valid_593994
  var valid_593995 = query.getOrDefault("$top")
  valid_593995 = validateParameter(valid_593995, JInt, required = false, default = nil)
  if valid_593995 != nil:
    section.add "$top", valid_593995
  var valid_593996 = query.getOrDefault("$filter")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "$filter", valid_593996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593997: Call_PolicyTrackedResourcesListQueryResultsForResourceGroup_593988;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy tracked resources under the resource group.
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_PolicyTrackedResourcesListQueryResultsForResourceGroup_593988;
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
  var path_593999 = newJObject()
  var query_594000 = newJObject()
  add(path_593999, "policyTrackedResourcesResource",
      newJString(policyTrackedResourcesResource))
  add(path_593999, "resourceGroupName", newJString(resourceGroupName))
  add(query_594000, "api-version", newJString(apiVersion))
  add(path_593999, "subscriptionId", newJString(subscriptionId))
  add(query_594000, "$top", newJInt(Top))
  add(query_594000, "$filter", newJString(Filter))
  result = call_593998.call(path_593999, query_594000, nil, nil, nil)

var policyTrackedResourcesListQueryResultsForResourceGroup* = Call_PolicyTrackedResourcesListQueryResultsForResourceGroup_593988(
    name: "policyTrackedResourcesListQueryResultsForResourceGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/policyTrackedResources/{policyTrackedResourcesResource}/queryResults",
    validator: validate_PolicyTrackedResourcesListQueryResultsForResourceGroup_593989,
    base: "", url: url_PolicyTrackedResourcesListQueryResultsForResourceGroup_593990,
    schemes: {Scheme.Https})
type
  Call_PolicyTrackedResourcesListQueryResultsForResource_594001 = ref object of OpenApiRestCall_593424
proc url_PolicyTrackedResourcesListQueryResultsForResource_594003(
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

proc validate_PolicyTrackedResourcesListQueryResultsForResource_594002(
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
  var valid_594004 = path.getOrDefault("policyTrackedResourcesResource")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = newJString("default"))
  if valid_594004 != nil:
    section.add "policyTrackedResourcesResource", valid_594004
  var valid_594005 = path.getOrDefault("resourceId")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "resourceId", valid_594005
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
  var valid_594006 = query.getOrDefault("api-version")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "api-version", valid_594006
  var valid_594007 = query.getOrDefault("$top")
  valid_594007 = validateParameter(valid_594007, JInt, required = false, default = nil)
  if valid_594007 != nil:
    section.add "$top", valid_594007
  var valid_594008 = query.getOrDefault("$filter")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "$filter", valid_594008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594009: Call_PolicyTrackedResourcesListQueryResultsForResource_594001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy tracked resources under the resource.
  ## 
  let valid = call_594009.validator(path, query, header, formData, body)
  let scheme = call_594009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594009.url(scheme.get, call_594009.host, call_594009.base,
                         call_594009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594009, url, valid)

proc call*(call_594010: Call_PolicyTrackedResourcesListQueryResultsForResource_594001;
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
  var path_594011 = newJObject()
  var query_594012 = newJObject()
  add(path_594011, "policyTrackedResourcesResource",
      newJString(policyTrackedResourcesResource))
  add(query_594012, "api-version", newJString(apiVersion))
  add(query_594012, "$top", newJInt(Top))
  add(path_594011, "resourceId", newJString(resourceId))
  add(query_594012, "$filter", newJString(Filter))
  result = call_594010.call(path_594011, query_594012, nil, nil, nil)

var policyTrackedResourcesListQueryResultsForResource* = Call_PolicyTrackedResourcesListQueryResultsForResource_594001(
    name: "policyTrackedResourcesListQueryResultsForResource",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/policyTrackedResources/{policyTrackedResourcesResource}/queryResults",
    validator: validate_PolicyTrackedResourcesListQueryResultsForResource_594002,
    base: "", url: url_PolicyTrackedResourcesListQueryResultsForResource_594003,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
