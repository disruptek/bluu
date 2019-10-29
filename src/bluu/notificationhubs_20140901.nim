
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NotificationHubsManagementClient
## version: 2014-09-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure NotificationHub client
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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  macServiceName = "notificationhubs"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_NamespacesCheckAvailability_563761 = ref object of OpenApiRestCall_563539
proc url_NamespacesCheckAvailability_563763(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.NotificationHubs/checkNamespaceAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCheckAvailability_563762(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks the availability of the given service namespace across all Windows Azure subscriptions. This is useful because the domain name is created based on the service namespace name.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj870968.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563955 = path.getOrDefault("subscriptionId")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "subscriptionId", valid_563955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563956 = query.getOrDefault("api-version")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "api-version", valid_563956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The namespace name.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_563980: Call_NamespacesCheckAvailability_563761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks the availability of the given service namespace across all Windows Azure subscriptions. This is useful because the domain name is created based on the service namespace name.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj870968.aspx
  let valid = call_563980.validator(path, query, header, formData, body)
  let scheme = call_563980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563980.url(scheme.get, call_563980.host, call_563980.base,
                         call_563980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563980, url, valid)

proc call*(call_564051: Call_NamespacesCheckAvailability_563761;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCheckAvailability
  ## Checks the availability of the given service namespace across all Windows Azure subscriptions. This is useful because the domain name is created based on the service namespace name.
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj870968.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The namespace name.
  var path_564052 = newJObject()
  var query_564054 = newJObject()
  var body_564055 = newJObject()
  add(query_564054, "api-version", newJString(apiVersion))
  add(path_564052, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564055 = parameters
  result = call_564051.call(path_564052, query_564054, nil, nil, body_564055)

var namespacesCheckAvailability* = Call_NamespacesCheckAvailability_563761(
    name: "namespacesCheckAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.NotificationHubs/checkNamespaceAvailability",
    validator: validate_NamespacesCheckAvailability_563762, base: "",
    url: url_NamespacesCheckAvailability_563763, schemes: {Scheme.Https})
type
  Call_NamespacesListAll_564094 = ref object of OpenApiRestCall_563539
proc url_NamespacesListAll_564096(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListAll_564095(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists all the available namespaces within the subscription irrespective of the resourceGroups.
  ## 
  ## http://msdn.microsoft.com/en-us/library/azure/hh780759.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564097 = path.getOrDefault("subscriptionId")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "subscriptionId", valid_564097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564098 = query.getOrDefault("api-version")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "api-version", valid_564098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564099: Call_NamespacesListAll_564094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available namespaces within the subscription irrespective of the resourceGroups.
  ## 
  ## http://msdn.microsoft.com/en-us/library/azure/hh780759.aspx
  let valid = call_564099.validator(path, query, header, formData, body)
  let scheme = call_564099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564099.url(scheme.get, call_564099.host, call_564099.base,
                         call_564099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564099, url, valid)

proc call*(call_564100: Call_NamespacesListAll_564094; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesListAll
  ## Lists all the available namespaces within the subscription irrespective of the resourceGroups.
  ## http://msdn.microsoft.com/en-us/library/azure/hh780759.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564101 = newJObject()
  var query_564102 = newJObject()
  add(query_564102, "api-version", newJString(apiVersion))
  add(path_564101, "subscriptionId", newJString(subscriptionId))
  result = call_564100.call(path_564101, query_564102, nil, nil, nil)

var namespacesListAll* = Call_NamespacesListAll_564094(name: "namespacesListAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.NotificationHubs/namespaces",
    validator: validate_NamespacesListAll_564095, base: "",
    url: url_NamespacesListAll_564096, schemes: {Scheme.Https})
type
  Call_NamespacesList_564103 = ref object of OpenApiRestCall_563539
proc url_NamespacesList_564105(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesList_564104(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists the available namespaces within a resourceGroup.
  ## 
  ## http://msdn.microsoft.com/en-us/library/azure/hh780759.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. If resourceGroupName value is null the method lists all the namespaces within subscription
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564106 = path.getOrDefault("subscriptionId")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "subscriptionId", valid_564106
  var valid_564107 = path.getOrDefault("resourceGroupName")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "resourceGroupName", valid_564107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564108 = query.getOrDefault("api-version")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "api-version", valid_564108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564109: Call_NamespacesList_564103; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available namespaces within a resourceGroup.
  ## 
  ## http://msdn.microsoft.com/en-us/library/azure/hh780759.aspx
  let valid = call_564109.validator(path, query, header, formData, body)
  let scheme = call_564109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564109.url(scheme.get, call_564109.host, call_564109.base,
                         call_564109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564109, url, valid)

proc call*(call_564110: Call_NamespacesList_564103; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## namespacesList
  ## Lists the available namespaces within a resourceGroup.
  ## http://msdn.microsoft.com/en-us/library/azure/hh780759.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. If resourceGroupName value is null the method lists all the namespaces within subscription
  var path_564111 = newJObject()
  var query_564112 = newJObject()
  add(query_564112, "api-version", newJString(apiVersion))
  add(path_564111, "subscriptionId", newJString(subscriptionId))
  add(path_564111, "resourceGroupName", newJString(resourceGroupName))
  result = call_564110.call(path_564111, query_564112, nil, nil, nil)

var namespacesList* = Call_NamespacesList_564103(name: "namespacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces",
    validator: validate_NamespacesList_564104, base: "", url: url_NamespacesList_564105,
    schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdate_564124 = ref object of OpenApiRestCall_563539
proc url_NamespacesCreateOrUpdate_564126(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdate_564125(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates/Updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856303.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564127 = path.getOrDefault("namespaceName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "namespaceName", valid_564127
  var valid_564128 = path.getOrDefault("subscriptionId")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "subscriptionId", valid_564128
  var valid_564129 = path.getOrDefault("resourceGroupName")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "resourceGroupName", valid_564129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564130 = query.getOrDefault("api-version")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "api-version", valid_564130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a Namespace Resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564132: Call_NamespacesCreateOrUpdate_564124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates/Updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856303.aspx
  let valid = call_564132.validator(path, query, header, formData, body)
  let scheme = call_564132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564132.url(scheme.get, call_564132.host, call_564132.base,
                         call_564132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564132, url, valid)

proc call*(call_564133: Call_NamespacesCreateOrUpdate_564124; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdate
  ## Creates/Updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856303.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a Namespace Resource.
  var path_564134 = newJObject()
  var query_564135 = newJObject()
  var body_564136 = newJObject()
  add(query_564135, "api-version", newJString(apiVersion))
  add(path_564134, "namespaceName", newJString(namespaceName))
  add(path_564134, "subscriptionId", newJString(subscriptionId))
  add(path_564134, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564136 = parameters
  result = call_564133.call(path_564134, query_564135, nil, nil, body_564136)

var namespacesCreateOrUpdate* = Call_NamespacesCreateOrUpdate_564124(
    name: "namespacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}",
    validator: validate_NamespacesCreateOrUpdate_564125, base: "",
    url: url_NamespacesCreateOrUpdate_564126, schemes: {Scheme.Https})
type
  Call_NamespacesGet_564113 = ref object of OpenApiRestCall_563539
proc url_NamespacesGet_564115(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGet_564114(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the description for the specified namespace.
  ## 
  ## http://msdn.microsoft.com/library/azure/dn140232.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564116 = path.getOrDefault("namespaceName")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "namespaceName", valid_564116
  var valid_564117 = path.getOrDefault("subscriptionId")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "subscriptionId", valid_564117
  var valid_564118 = path.getOrDefault("resourceGroupName")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "resourceGroupName", valid_564118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564119 = query.getOrDefault("api-version")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "api-version", valid_564119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564120: Call_NamespacesGet_564113; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the description for the specified namespace.
  ## 
  ## http://msdn.microsoft.com/library/azure/dn140232.aspx
  let valid = call_564120.validator(path, query, header, formData, body)
  let scheme = call_564120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564120.url(scheme.get, call_564120.host, call_564120.base,
                         call_564120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564120, url, valid)

proc call*(call_564121: Call_NamespacesGet_564113; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## namespacesGet
  ## Returns the description for the specified namespace.
  ## http://msdn.microsoft.com/library/azure/dn140232.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564122 = newJObject()
  var query_564123 = newJObject()
  add(query_564123, "api-version", newJString(apiVersion))
  add(path_564122, "namespaceName", newJString(namespaceName))
  add(path_564122, "subscriptionId", newJString(subscriptionId))
  add(path_564122, "resourceGroupName", newJString(resourceGroupName))
  result = call_564121.call(path_564122, query_564123, nil, nil, nil)

var namespacesGet* = Call_NamespacesGet_564113(name: "namespacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}",
    validator: validate_NamespacesGet_564114, base: "", url: url_NamespacesGet_564115,
    schemes: {Scheme.Https})
type
  Call_NamespacesDelete_564137 = ref object of OpenApiRestCall_563539
proc url_NamespacesDelete_564139(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesDelete_564138(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes an existing namespace. This operation also removes all associated notificationHubs under the namespace.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856296.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564140 = path.getOrDefault("namespaceName")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "namespaceName", valid_564140
  var valid_564141 = path.getOrDefault("subscriptionId")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "subscriptionId", valid_564141
  var valid_564142 = path.getOrDefault("resourceGroupName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "resourceGroupName", valid_564142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564143 = query.getOrDefault("api-version")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "api-version", valid_564143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564144: Call_NamespacesDelete_564137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing namespace. This operation also removes all associated notificationHubs under the namespace.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856296.aspx
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_NamespacesDelete_564137; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## namespacesDelete
  ## Deletes an existing namespace. This operation also removes all associated notificationHubs under the namespace.
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856296.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564146 = newJObject()
  var query_564147 = newJObject()
  add(query_564147, "api-version", newJString(apiVersion))
  add(path_564146, "namespaceName", newJString(namespaceName))
  add(path_564146, "subscriptionId", newJString(subscriptionId))
  add(path_564146, "resourceGroupName", newJString(resourceGroupName))
  result = call_564145.call(path_564146, query_564147, nil, nil, nil)

var namespacesDelete* = Call_NamespacesDelete_564137(name: "namespacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}",
    validator: validate_NamespacesDelete_564138, base: "",
    url: url_NamespacesDelete_564139, schemes: {Scheme.Https})
type
  Call_NamespacesListAuthorizationRules_564148 = ref object of OpenApiRestCall_563539
proc url_NamespacesListAuthorizationRules_564150(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListAuthorizationRules_564149(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the authorization rules for a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564151 = path.getOrDefault("namespaceName")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "namespaceName", valid_564151
  var valid_564152 = path.getOrDefault("subscriptionId")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "subscriptionId", valid_564152
  var valid_564153 = path.getOrDefault("resourceGroupName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "resourceGroupName", valid_564153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564154 = query.getOrDefault("api-version")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "api-version", valid_564154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564155: Call_NamespacesListAuthorizationRules_564148;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the authorization rules for a namespace.
  ## 
  let valid = call_564155.validator(path, query, header, formData, body)
  let scheme = call_564155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564155.url(scheme.get, call_564155.host, call_564155.base,
                         call_564155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564155, url, valid)

proc call*(call_564156: Call_NamespacesListAuthorizationRules_564148;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## namespacesListAuthorizationRules
  ## Gets the authorization rules for a namespace.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564157 = newJObject()
  var query_564158 = newJObject()
  add(query_564158, "api-version", newJString(apiVersion))
  add(path_564157, "namespaceName", newJString(namespaceName))
  add(path_564157, "subscriptionId", newJString(subscriptionId))
  add(path_564157, "resourceGroupName", newJString(resourceGroupName))
  result = call_564156.call(path_564157, query_564158, nil, nil, nil)

var namespacesListAuthorizationRules* = Call_NamespacesListAuthorizationRules_564148(
    name: "namespacesListAuthorizationRules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/AuthorizationRules",
    validator: validate_NamespacesListAuthorizationRules_564149, base: "",
    url: url_NamespacesListAuthorizationRules_564150, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateAuthorizationRule_564159 = ref object of OpenApiRestCall_563539
proc url_NamespacesCreateOrUpdateAuthorizationRule_564161(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdateAuthorizationRule_564160(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an authorization rule for a namespace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : Authorization Rule Name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564162 = path.getOrDefault("namespaceName")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "namespaceName", valid_564162
  var valid_564163 = path.getOrDefault("subscriptionId")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "subscriptionId", valid_564163
  var valid_564164 = path.getOrDefault("authorizationRuleName")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "authorizationRuleName", valid_564164
  var valid_564165 = path.getOrDefault("resourceGroupName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "resourceGroupName", valid_564165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564166 = query.getOrDefault("api-version")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "api-version", valid_564166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564168: Call_NamespacesCreateOrUpdateAuthorizationRule_564159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an authorization rule for a namespace
  ## 
  let valid = call_564168.validator(path, query, header, formData, body)
  let scheme = call_564168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564168.url(scheme.get, call_564168.host, call_564168.base,
                         call_564168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564168, url, valid)

proc call*(call_564169: Call_NamespacesCreateOrUpdateAuthorizationRule_564159;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateAuthorizationRule
  ## Creates an authorization rule for a namespace
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : Authorization Rule Name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  var path_564170 = newJObject()
  var query_564171 = newJObject()
  var body_564172 = newJObject()
  add(query_564171, "api-version", newJString(apiVersion))
  add(path_564170, "namespaceName", newJString(namespaceName))
  add(path_564170, "subscriptionId", newJString(subscriptionId))
  add(path_564170, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564170, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564172 = parameters
  result = call_564169.call(path_564170, query_564171, nil, nil, body_564172)

var namespacesCreateOrUpdateAuthorizationRule* = Call_NamespacesCreateOrUpdateAuthorizationRule_564159(
    name: "namespacesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesCreateOrUpdateAuthorizationRule_564160,
    base: "", url: url_NamespacesCreateOrUpdateAuthorizationRule_564161,
    schemes: {Scheme.Https})
type
  Call_NamespacesGetAuthorizationRule_564173 = ref object of OpenApiRestCall_563539
proc url_NamespacesGetAuthorizationRule_564175(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGetAuthorizationRule_564174(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an authorization rule for a namespace by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : Authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564176 = path.getOrDefault("namespaceName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "namespaceName", valid_564176
  var valid_564177 = path.getOrDefault("subscriptionId")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "subscriptionId", valid_564177
  var valid_564178 = path.getOrDefault("authorizationRuleName")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "authorizationRuleName", valid_564178
  var valid_564179 = path.getOrDefault("resourceGroupName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "resourceGroupName", valid_564179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564180 = query.getOrDefault("api-version")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "api-version", valid_564180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564181: Call_NamespacesGetAuthorizationRule_564173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an authorization rule for a namespace by name.
  ## 
  let valid = call_564181.validator(path, query, header, formData, body)
  let scheme = call_564181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564181.url(scheme.get, call_564181.host, call_564181.base,
                         call_564181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564181, url, valid)

proc call*(call_564182: Call_NamespacesGetAuthorizationRule_564173;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string): Recallable =
  ## namespacesGetAuthorizationRule
  ## Gets an authorization rule for a namespace by name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : Authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564183 = newJObject()
  var query_564184 = newJObject()
  add(query_564184, "api-version", newJString(apiVersion))
  add(path_564183, "namespaceName", newJString(namespaceName))
  add(path_564183, "subscriptionId", newJString(subscriptionId))
  add(path_564183, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564183, "resourceGroupName", newJString(resourceGroupName))
  result = call_564182.call(path_564183, query_564184, nil, nil, nil)

var namespacesGetAuthorizationRule* = Call_NamespacesGetAuthorizationRule_564173(
    name: "namespacesGetAuthorizationRule", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesGetAuthorizationRule_564174, base: "",
    url: url_NamespacesGetAuthorizationRule_564175, schemes: {Scheme.Https})
type
  Call_NamespacesDeleteAuthorizationRule_564185 = ref object of OpenApiRestCall_563539
proc url_NamespacesDeleteAuthorizationRule_564187(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesDeleteAuthorizationRule_564186(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a namespace authorization rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : Authorization Rule Name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564188 = path.getOrDefault("namespaceName")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "namespaceName", valid_564188
  var valid_564189 = path.getOrDefault("subscriptionId")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "subscriptionId", valid_564189
  var valid_564190 = path.getOrDefault("authorizationRuleName")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "authorizationRuleName", valid_564190
  var valid_564191 = path.getOrDefault("resourceGroupName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "resourceGroupName", valid_564191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564192 = query.getOrDefault("api-version")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "api-version", valid_564192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564193: Call_NamespacesDeleteAuthorizationRule_564185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a namespace authorization rule
  ## 
  let valid = call_564193.validator(path, query, header, formData, body)
  let scheme = call_564193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564193.url(scheme.get, call_564193.host, call_564193.base,
                         call_564193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564193, url, valid)

proc call*(call_564194: Call_NamespacesDeleteAuthorizationRule_564185;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string): Recallable =
  ## namespacesDeleteAuthorizationRule
  ## Deletes a namespace authorization rule
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : Authorization Rule Name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564195 = newJObject()
  var query_564196 = newJObject()
  add(query_564196, "api-version", newJString(apiVersion))
  add(path_564195, "namespaceName", newJString(namespaceName))
  add(path_564195, "subscriptionId", newJString(subscriptionId))
  add(path_564195, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564195, "resourceGroupName", newJString(resourceGroupName))
  result = call_564194.call(path_564195, query_564196, nil, nil, nil)

var namespacesDeleteAuthorizationRule* = Call_NamespacesDeleteAuthorizationRule_564185(
    name: "namespacesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesDeleteAuthorizationRule_564186, base: "",
    url: url_NamespacesDeleteAuthorizationRule_564187, schemes: {Scheme.Https})
type
  Call_NamespacesListKeys_564197 = ref object of OpenApiRestCall_563539
proc url_NamespacesListKeys_564199(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListKeys_564198(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the Primary and Secondary ConnectionStrings to the namespace 
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj873988.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The connection string of the namespace for the specified authorizationRule.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564200 = path.getOrDefault("namespaceName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "namespaceName", valid_564200
  var valid_564201 = path.getOrDefault("subscriptionId")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "subscriptionId", valid_564201
  var valid_564202 = path.getOrDefault("authorizationRuleName")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "authorizationRuleName", valid_564202
  var valid_564203 = path.getOrDefault("resourceGroupName")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "resourceGroupName", valid_564203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564204 = query.getOrDefault("api-version")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "api-version", valid_564204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564205: Call_NamespacesListKeys_564197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Primary and Secondary ConnectionStrings to the namespace 
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj873988.aspx
  let valid = call_564205.validator(path, query, header, formData, body)
  let scheme = call_564205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564205.url(scheme.get, call_564205.host, call_564205.base,
                         call_564205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564205, url, valid)

proc call*(call_564206: Call_NamespacesListKeys_564197; apiVersion: string;
          namespaceName: string; subscriptionId: string;
          authorizationRuleName: string; resourceGroupName: string): Recallable =
  ## namespacesListKeys
  ## Gets the Primary and Secondary ConnectionStrings to the namespace 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj873988.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The connection string of the namespace for the specified authorizationRule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564207 = newJObject()
  var query_564208 = newJObject()
  add(query_564208, "api-version", newJString(apiVersion))
  add(path_564207, "namespaceName", newJString(namespaceName))
  add(path_564207, "subscriptionId", newJString(subscriptionId))
  add(path_564207, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564207, "resourceGroupName", newJString(resourceGroupName))
  result = call_564206.call(path_564207, query_564208, nil, nil, nil)

var namespacesListKeys* = Call_NamespacesListKeys_564197(
    name: "namespacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_NamespacesListKeys_564198, base: "",
    url: url_NamespacesListKeys_564199, schemes: {Scheme.Https})
type
  Call_NotificationHubsCheckAvailability_564209 = ref object of OpenApiRestCall_563539
proc url_NotificationHubsCheckAvailability_564211(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"), (
        kind: ConstantSegment, value: "/checkNotificationHubAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsCheckAvailability_564210(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks the availability of the given notificationHub in a namespace.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj870968.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564212 = path.getOrDefault("namespaceName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "namespaceName", valid_564212
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
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564215 = query.getOrDefault("api-version")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "api-version", valid_564215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The notificationHub name.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564217: Call_NotificationHubsCheckAvailability_564209;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks the availability of the given notificationHub in a namespace.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj870968.aspx
  let valid = call_564217.validator(path, query, header, formData, body)
  let scheme = call_564217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564217.url(scheme.get, call_564217.host, call_564217.base,
                         call_564217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564217, url, valid)

proc call*(call_564218: Call_NotificationHubsCheckAvailability_564209;
          apiVersion: string; namespaceName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## notificationHubsCheckAvailability
  ## Checks the availability of the given notificationHub in a namespace.
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj870968.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : The notificationHub name.
  var path_564219 = newJObject()
  var query_564220 = newJObject()
  var body_564221 = newJObject()
  add(query_564220, "api-version", newJString(apiVersion))
  add(path_564219, "namespaceName", newJString(namespaceName))
  add(path_564219, "subscriptionId", newJString(subscriptionId))
  add(path_564219, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564221 = parameters
  result = call_564218.call(path_564219, query_564220, nil, nil, body_564221)

var notificationHubsCheckAvailability* = Call_NotificationHubsCheckAvailability_564209(
    name: "notificationHubsCheckAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/checkNotificationHubAvailability",
    validator: validate_NotificationHubsCheckAvailability_564210, base: "",
    url: url_NotificationHubsCheckAvailability_564211, schemes: {Scheme.Https})
type
  Call_NotificationHubsList_564222 = ref object of OpenApiRestCall_563539
proc url_NotificationHubsList_564224(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsList_564223(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the notification hubs associated with a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564225 = path.getOrDefault("namespaceName")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "namespaceName", valid_564225
  var valid_564226 = path.getOrDefault("subscriptionId")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "subscriptionId", valid_564226
  var valid_564227 = path.getOrDefault("resourceGroupName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "resourceGroupName", valid_564227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564228 = query.getOrDefault("api-version")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "api-version", valid_564228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564229: Call_NotificationHubsList_564222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the notification hubs associated with a namespace.
  ## 
  let valid = call_564229.validator(path, query, header, formData, body)
  let scheme = call_564229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564229.url(scheme.get, call_564229.host, call_564229.base,
                         call_564229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564229, url, valid)

proc call*(call_564230: Call_NotificationHubsList_564222; apiVersion: string;
          namespaceName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## notificationHubsList
  ## Lists the notification hubs associated with a namespace.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564231 = newJObject()
  var query_564232 = newJObject()
  add(query_564232, "api-version", newJString(apiVersion))
  add(path_564231, "namespaceName", newJString(namespaceName))
  add(path_564231, "subscriptionId", newJString(subscriptionId))
  add(path_564231, "resourceGroupName", newJString(resourceGroupName))
  result = call_564230.call(path_564231, query_564232, nil, nil, nil)

var notificationHubsList* = Call_NotificationHubsList_564222(
    name: "notificationHubsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs",
    validator: validate_NotificationHubsList_564223, base: "",
    url: url_NotificationHubsList_564224, schemes: {Scheme.Https})
type
  Call_NotificationHubsCreateOrUpdate_564245 = ref object of OpenApiRestCall_563539
proc url_NotificationHubsCreateOrUpdate_564247(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsCreateOrUpdate_564246(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates/Update a NotificationHub in a namespace.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856303.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564248 = path.getOrDefault("namespaceName")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "namespaceName", valid_564248
  var valid_564249 = path.getOrDefault("notificationHubName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "notificationHubName", valid_564249
  var valid_564250 = path.getOrDefault("subscriptionId")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "subscriptionId", valid_564250
  var valid_564251 = path.getOrDefault("resourceGroupName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "resourceGroupName", valid_564251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564252 = query.getOrDefault("api-version")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "api-version", valid_564252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update a NotificationHub Resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564254: Call_NotificationHubsCreateOrUpdate_564245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates/Update a NotificationHub in a namespace.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856303.aspx
  let valid = call_564254.validator(path, query, header, formData, body)
  let scheme = call_564254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564254.url(scheme.get, call_564254.host, call_564254.base,
                         call_564254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564254, url, valid)

proc call*(call_564255: Call_NotificationHubsCreateOrUpdate_564245;
          apiVersion: string; namespaceName: string; notificationHubName: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## notificationHubsCreateOrUpdate
  ## Creates/Update a NotificationHub in a namespace.
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856303.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update a NotificationHub Resource.
  var path_564256 = newJObject()
  var query_564257 = newJObject()
  var body_564258 = newJObject()
  add(query_564257, "api-version", newJString(apiVersion))
  add(path_564256, "namespaceName", newJString(namespaceName))
  add(path_564256, "notificationHubName", newJString(notificationHubName))
  add(path_564256, "subscriptionId", newJString(subscriptionId))
  add(path_564256, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564258 = parameters
  result = call_564255.call(path_564256, query_564257, nil, nil, body_564258)

var notificationHubsCreateOrUpdate* = Call_NotificationHubsCreateOrUpdate_564245(
    name: "notificationHubsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}",
    validator: validate_NotificationHubsCreateOrUpdate_564246, base: "",
    url: url_NotificationHubsCreateOrUpdate_564247, schemes: {Scheme.Https})
type
  Call_NotificationHubsGet_564233 = ref object of OpenApiRestCall_563539
proc url_NotificationHubsGet_564235(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsGet_564234(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists the notification hubs associated with a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564236 = path.getOrDefault("namespaceName")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "namespaceName", valid_564236
  var valid_564237 = path.getOrDefault("notificationHubName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "notificationHubName", valid_564237
  var valid_564238 = path.getOrDefault("subscriptionId")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "subscriptionId", valid_564238
  var valid_564239 = path.getOrDefault("resourceGroupName")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "resourceGroupName", valid_564239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564240 = query.getOrDefault("api-version")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "api-version", valid_564240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564241: Call_NotificationHubsGet_564233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the notification hubs associated with a namespace.
  ## 
  let valid = call_564241.validator(path, query, header, formData, body)
  let scheme = call_564241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564241.url(scheme.get, call_564241.host, call_564241.base,
                         call_564241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564241, url, valid)

proc call*(call_564242: Call_NotificationHubsGet_564233; apiVersion: string;
          namespaceName: string; notificationHubName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## notificationHubsGet
  ## Lists the notification hubs associated with a namespace.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564243 = newJObject()
  var query_564244 = newJObject()
  add(query_564244, "api-version", newJString(apiVersion))
  add(path_564243, "namespaceName", newJString(namespaceName))
  add(path_564243, "notificationHubName", newJString(notificationHubName))
  add(path_564243, "subscriptionId", newJString(subscriptionId))
  add(path_564243, "resourceGroupName", newJString(resourceGroupName))
  result = call_564242.call(path_564243, query_564244, nil, nil, nil)

var notificationHubsGet* = Call_NotificationHubsGet_564233(
    name: "notificationHubsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}",
    validator: validate_NotificationHubsGet_564234, base: "",
    url: url_NotificationHubsGet_564235, schemes: {Scheme.Https})
type
  Call_NotificationHubsDelete_564259 = ref object of OpenApiRestCall_563539
proc url_NotificationHubsDelete_564261(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsDelete_564260(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a notification hub associated with a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564262 = path.getOrDefault("namespaceName")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "namespaceName", valid_564262
  var valid_564263 = path.getOrDefault("notificationHubName")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "notificationHubName", valid_564263
  var valid_564264 = path.getOrDefault("subscriptionId")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "subscriptionId", valid_564264
  var valid_564265 = path.getOrDefault("resourceGroupName")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "resourceGroupName", valid_564265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564266 = query.getOrDefault("api-version")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "api-version", valid_564266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564267: Call_NotificationHubsDelete_564259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a notification hub associated with a namespace.
  ## 
  let valid = call_564267.validator(path, query, header, formData, body)
  let scheme = call_564267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564267.url(scheme.get, call_564267.host, call_564267.base,
                         call_564267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564267, url, valid)

proc call*(call_564268: Call_NotificationHubsDelete_564259; apiVersion: string;
          namespaceName: string; notificationHubName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## notificationHubsDelete
  ## Deletes a notification hub associated with a namespace.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564269 = newJObject()
  var query_564270 = newJObject()
  add(query_564270, "api-version", newJString(apiVersion))
  add(path_564269, "namespaceName", newJString(namespaceName))
  add(path_564269, "notificationHubName", newJString(notificationHubName))
  add(path_564269, "subscriptionId", newJString(subscriptionId))
  add(path_564269, "resourceGroupName", newJString(resourceGroupName))
  result = call_564268.call(path_564269, query_564270, nil, nil, nil)

var notificationHubsDelete* = Call_NotificationHubsDelete_564259(
    name: "notificationHubsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}",
    validator: validate_NotificationHubsDelete_564260, base: "",
    url: url_NotificationHubsDelete_564261, schemes: {Scheme.Https})
type
  Call_NotificationHubsListAuthorizationRules_564271 = ref object of OpenApiRestCall_563539
proc url_NotificationHubsListAuthorizationRules_564273(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName"),
               (kind: ConstantSegment, value: "/AuthorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsListAuthorizationRules_564272(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the authorization rules for a NotificationHub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564274 = path.getOrDefault("namespaceName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "namespaceName", valid_564274
  var valid_564275 = path.getOrDefault("notificationHubName")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "notificationHubName", valid_564275
  var valid_564276 = path.getOrDefault("subscriptionId")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "subscriptionId", valid_564276
  var valid_564277 = path.getOrDefault("resourceGroupName")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "resourceGroupName", valid_564277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564278 = query.getOrDefault("api-version")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "api-version", valid_564278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564279: Call_NotificationHubsListAuthorizationRules_564271;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the authorization rules for a NotificationHub.
  ## 
  let valid = call_564279.validator(path, query, header, formData, body)
  let scheme = call_564279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564279.url(scheme.get, call_564279.host, call_564279.base,
                         call_564279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564279, url, valid)

proc call*(call_564280: Call_NotificationHubsListAuthorizationRules_564271;
          apiVersion: string; namespaceName: string; notificationHubName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## notificationHubsListAuthorizationRules
  ## Gets the authorization rules for a NotificationHub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564281 = newJObject()
  var query_564282 = newJObject()
  add(query_564282, "api-version", newJString(apiVersion))
  add(path_564281, "namespaceName", newJString(namespaceName))
  add(path_564281, "notificationHubName", newJString(notificationHubName))
  add(path_564281, "subscriptionId", newJString(subscriptionId))
  add(path_564281, "resourceGroupName", newJString(resourceGroupName))
  result = call_564280.call(path_564281, query_564282, nil, nil, nil)

var notificationHubsListAuthorizationRules* = Call_NotificationHubsListAuthorizationRules_564271(
    name: "notificationHubsListAuthorizationRules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/AuthorizationRules",
    validator: validate_NotificationHubsListAuthorizationRules_564272, base: "",
    url: url_NotificationHubsListAuthorizationRules_564273,
    schemes: {Scheme.Https})
type
  Call_NotificationHubsCreateOrUpdateAuthorizationRule_564283 = ref object of OpenApiRestCall_563539
proc url_NotificationHubsCreateOrUpdateAuthorizationRule_564285(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsCreateOrUpdateAuthorizationRule_564284(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates/Updates an authorization rule for a NotificationHub
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : Authorization Rule Name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564286 = path.getOrDefault("namespaceName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "namespaceName", valid_564286
  var valid_564287 = path.getOrDefault("notificationHubName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "notificationHubName", valid_564287
  var valid_564288 = path.getOrDefault("subscriptionId")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "subscriptionId", valid_564288
  var valid_564289 = path.getOrDefault("authorizationRuleName")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "authorizationRuleName", valid_564289
  var valid_564290 = path.getOrDefault("resourceGroupName")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "resourceGroupName", valid_564290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564291 = query.getOrDefault("api-version")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "api-version", valid_564291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564293: Call_NotificationHubsCreateOrUpdateAuthorizationRule_564283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates/Updates an authorization rule for a NotificationHub
  ## 
  let valid = call_564293.validator(path, query, header, formData, body)
  let scheme = call_564293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564293.url(scheme.get, call_564293.host, call_564293.base,
                         call_564293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564293, url, valid)

proc call*(call_564294: Call_NotificationHubsCreateOrUpdateAuthorizationRule_564283;
          apiVersion: string; namespaceName: string; notificationHubName: string;
          subscriptionId: string; authorizationRuleName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## notificationHubsCreateOrUpdateAuthorizationRule
  ## Creates/Updates an authorization rule for a NotificationHub
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : Authorization Rule Name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  var path_564295 = newJObject()
  var query_564296 = newJObject()
  var body_564297 = newJObject()
  add(query_564296, "api-version", newJString(apiVersion))
  add(path_564295, "namespaceName", newJString(namespaceName))
  add(path_564295, "notificationHubName", newJString(notificationHubName))
  add(path_564295, "subscriptionId", newJString(subscriptionId))
  add(path_564295, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564295, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564297 = parameters
  result = call_564294.call(path_564295, query_564296, nil, nil, body_564297)

var notificationHubsCreateOrUpdateAuthorizationRule* = Call_NotificationHubsCreateOrUpdateAuthorizationRule_564283(
    name: "notificationHubsCreateOrUpdateAuthorizationRule",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NotificationHubsCreateOrUpdateAuthorizationRule_564284,
    base: "", url: url_NotificationHubsCreateOrUpdateAuthorizationRule_564285,
    schemes: {Scheme.Https})
type
  Call_NotificationHubsGetAuthorizationRule_564298 = ref object of OpenApiRestCall_563539
proc url_NotificationHubsGetAuthorizationRule_564300(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsGetAuthorizationRule_564299(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an authorization rule for a NotificationHub by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : authorization rule name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564301 = path.getOrDefault("namespaceName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "namespaceName", valid_564301
  var valid_564302 = path.getOrDefault("notificationHubName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "notificationHubName", valid_564302
  var valid_564303 = path.getOrDefault("subscriptionId")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "subscriptionId", valid_564303
  var valid_564304 = path.getOrDefault("authorizationRuleName")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "authorizationRuleName", valid_564304
  var valid_564305 = path.getOrDefault("resourceGroupName")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "resourceGroupName", valid_564305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564306 = query.getOrDefault("api-version")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "api-version", valid_564306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564307: Call_NotificationHubsGetAuthorizationRule_564298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an authorization rule for a NotificationHub by name.
  ## 
  let valid = call_564307.validator(path, query, header, formData, body)
  let scheme = call_564307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564307.url(scheme.get, call_564307.host, call_564307.base,
                         call_564307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564307, url, valid)

proc call*(call_564308: Call_NotificationHubsGetAuthorizationRule_564298;
          apiVersion: string; namespaceName: string; notificationHubName: string;
          subscriptionId: string; authorizationRuleName: string;
          resourceGroupName: string): Recallable =
  ## notificationHubsGetAuthorizationRule
  ## Gets an authorization rule for a NotificationHub by name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : authorization rule name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564309 = newJObject()
  var query_564310 = newJObject()
  add(query_564310, "api-version", newJString(apiVersion))
  add(path_564309, "namespaceName", newJString(namespaceName))
  add(path_564309, "notificationHubName", newJString(notificationHubName))
  add(path_564309, "subscriptionId", newJString(subscriptionId))
  add(path_564309, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564309, "resourceGroupName", newJString(resourceGroupName))
  result = call_564308.call(path_564309, query_564310, nil, nil, nil)

var notificationHubsGetAuthorizationRule* = Call_NotificationHubsGetAuthorizationRule_564298(
    name: "notificationHubsGetAuthorizationRule", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NotificationHubsGetAuthorizationRule_564299, base: "",
    url: url_NotificationHubsGetAuthorizationRule_564300, schemes: {Scheme.Https})
type
  Call_NotificationHubsDeleteAuthorizationRule_564311 = ref object of OpenApiRestCall_563539
proc url_NotificationHubsDeleteAuthorizationRule_564313(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsDeleteAuthorizationRule_564312(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a notificationHub authorization rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : Authorization Rule Name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564314 = path.getOrDefault("namespaceName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "namespaceName", valid_564314
  var valid_564315 = path.getOrDefault("notificationHubName")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "notificationHubName", valid_564315
  var valid_564316 = path.getOrDefault("subscriptionId")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "subscriptionId", valid_564316
  var valid_564317 = path.getOrDefault("authorizationRuleName")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "authorizationRuleName", valid_564317
  var valid_564318 = path.getOrDefault("resourceGroupName")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "resourceGroupName", valid_564318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564319 = query.getOrDefault("api-version")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "api-version", valid_564319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564320: Call_NotificationHubsDeleteAuthorizationRule_564311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a notificationHub authorization rule
  ## 
  let valid = call_564320.validator(path, query, header, formData, body)
  let scheme = call_564320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564320.url(scheme.get, call_564320.host, call_564320.base,
                         call_564320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564320, url, valid)

proc call*(call_564321: Call_NotificationHubsDeleteAuthorizationRule_564311;
          apiVersion: string; namespaceName: string; notificationHubName: string;
          subscriptionId: string; authorizationRuleName: string;
          resourceGroupName: string): Recallable =
  ## notificationHubsDeleteAuthorizationRule
  ## Deletes a notificationHub authorization rule
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : Authorization Rule Name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564322 = newJObject()
  var query_564323 = newJObject()
  add(query_564323, "api-version", newJString(apiVersion))
  add(path_564322, "namespaceName", newJString(namespaceName))
  add(path_564322, "notificationHubName", newJString(notificationHubName))
  add(path_564322, "subscriptionId", newJString(subscriptionId))
  add(path_564322, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564322, "resourceGroupName", newJString(resourceGroupName))
  result = call_564321.call(path_564322, query_564323, nil, nil, nil)

var notificationHubsDeleteAuthorizationRule* = Call_NotificationHubsDeleteAuthorizationRule_564311(
    name: "notificationHubsDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NotificationHubsDeleteAuthorizationRule_564312, base: "",
    url: url_NotificationHubsDeleteAuthorizationRule_564313,
    schemes: {Scheme.Https})
type
  Call_NotificationHubsListKeys_564324 = ref object of OpenApiRestCall_563539
proc url_NotificationHubsListKeys_564326(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsListKeys_564325(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Primary and Secondary ConnectionStrings to the NotificationHub 
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj873988.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: JString (required)
  ##                        : The connection string of the NotificationHub for the specified authorizationRule.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564327 = path.getOrDefault("namespaceName")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "namespaceName", valid_564327
  var valid_564328 = path.getOrDefault("notificationHubName")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "notificationHubName", valid_564328
  var valid_564329 = path.getOrDefault("subscriptionId")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "subscriptionId", valid_564329
  var valid_564330 = path.getOrDefault("authorizationRuleName")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "authorizationRuleName", valid_564330
  var valid_564331 = path.getOrDefault("resourceGroupName")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "resourceGroupName", valid_564331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564332 = query.getOrDefault("api-version")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "api-version", valid_564332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564333: Call_NotificationHubsListKeys_564324; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Primary and Secondary ConnectionStrings to the NotificationHub 
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj873988.aspx
  let valid = call_564333.validator(path, query, header, formData, body)
  let scheme = call_564333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564333.url(scheme.get, call_564333.host, call_564333.base,
                         call_564333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564333, url, valid)

proc call*(call_564334: Call_NotificationHubsListKeys_564324; apiVersion: string;
          namespaceName: string; notificationHubName: string;
          subscriptionId: string; authorizationRuleName: string;
          resourceGroupName: string): Recallable =
  ## notificationHubsListKeys
  ## Gets the Primary and Secondary ConnectionStrings to the NotificationHub 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj873988.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationRuleName: string (required)
  ##                        : The connection string of the NotificationHub for the specified authorizationRule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564335 = newJObject()
  var query_564336 = newJObject()
  add(query_564336, "api-version", newJString(apiVersion))
  add(path_564335, "namespaceName", newJString(namespaceName))
  add(path_564335, "notificationHubName", newJString(notificationHubName))
  add(path_564335, "subscriptionId", newJString(subscriptionId))
  add(path_564335, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_564335, "resourceGroupName", newJString(resourceGroupName))
  result = call_564334.call(path_564335, query_564336, nil, nil, nil)

var notificationHubsListKeys* = Call_NotificationHubsListKeys_564324(
    name: "notificationHubsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/AuthorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_NotificationHubsListKeys_564325, base: "",
    url: url_NotificationHubsListKeys_564326, schemes: {Scheme.Https})
type
  Call_NotificationHubsGetPnsCredentials_564337 = ref object of OpenApiRestCall_563539
proc url_NotificationHubsGetPnsCredentials_564339(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName"),
               (kind: ConstantSegment, value: "/pnsCredentials")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsGetPnsCredentials_564338(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the PNS Credentials associated with a notification hub .
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_564340 = path.getOrDefault("namespaceName")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "namespaceName", valid_564340
  var valid_564341 = path.getOrDefault("notificationHubName")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "notificationHubName", valid_564341
  var valid_564342 = path.getOrDefault("subscriptionId")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "subscriptionId", valid_564342
  var valid_564343 = path.getOrDefault("resourceGroupName")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "resourceGroupName", valid_564343
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564344 = query.getOrDefault("api-version")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "api-version", valid_564344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564345: Call_NotificationHubsGetPnsCredentials_564337;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the PNS Credentials associated with a notification hub .
  ## 
  let valid = call_564345.validator(path, query, header, formData, body)
  let scheme = call_564345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564345.url(scheme.get, call_564345.host, call_564345.base,
                         call_564345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564345, url, valid)

proc call*(call_564346: Call_NotificationHubsGetPnsCredentials_564337;
          apiVersion: string; namespaceName: string; notificationHubName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## notificationHubsGetPnsCredentials
  ## Lists the PNS Credentials associated with a notification hub .
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564347 = newJObject()
  var query_564348 = newJObject()
  add(query_564348, "api-version", newJString(apiVersion))
  add(path_564347, "namespaceName", newJString(namespaceName))
  add(path_564347, "notificationHubName", newJString(notificationHubName))
  add(path_564347, "subscriptionId", newJString(subscriptionId))
  add(path_564347, "resourceGroupName", newJString(resourceGroupName))
  result = call_564346.call(path_564347, query_564348, nil, nil, nil)

var notificationHubsGetPnsCredentials* = Call_NotificationHubsGetPnsCredentials_564337(
    name: "notificationHubsGetPnsCredentials", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/pnsCredentials",
    validator: validate_NotificationHubsGetPnsCredentials_564338, base: "",
    url: url_NotificationHubsGetPnsCredentials_564339, schemes: {Scheme.Https})
type
  Call_NamespacesGetLongRunningOperationStatus_564349 = ref object of OpenApiRestCall_563539
proc url_NamespacesGetLongRunningOperationStatus_564351(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "operationStatusLink" in path,
        "`operationStatusLink` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "operationStatusLink")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGetLongRunningOperationStatus_564350(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get Operation Status operation returns the status of the specified operation. After calling an asynchronous operation, you can call Get Operation Status to determine whether the operation has succeeded, failed, or is still in progress.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationStatusLink: JString (required)
  ##                      : Location value returned by the Begin operation.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `operationStatusLink` field"
  var valid_564352 = path.getOrDefault("operationStatusLink")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "operationStatusLink", valid_564352
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564353: Call_NamespacesGetLongRunningOperationStatus_564349;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get Operation Status operation returns the status of the specified operation. After calling an asynchronous operation, you can call Get Operation Status to determine whether the operation has succeeded, failed, or is still in progress.
  ## 
  let valid = call_564353.validator(path, query, header, formData, body)
  let scheme = call_564353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564353.url(scheme.get, call_564353.host, call_564353.base,
                         call_564353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564353, url, valid)

proc call*(call_564354: Call_NamespacesGetLongRunningOperationStatus_564349;
          operationStatusLink: string): Recallable =
  ## namespacesGetLongRunningOperationStatus
  ## The Get Operation Status operation returns the status of the specified operation. After calling an asynchronous operation, you can call Get Operation Status to determine whether the operation has succeeded, failed, or is still in progress.
  ##   operationStatusLink: string (required)
  ##                      : Location value returned by the Begin operation.
  var path_564355 = newJObject()
  add(path_564355, "operationStatusLink", newJString(operationStatusLink))
  result = call_564354.call(path_564355, nil, nil, nil, nil)

var namespacesGetLongRunningOperationStatus* = Call_NamespacesGetLongRunningOperationStatus_564349(
    name: "namespacesGetLongRunningOperationStatus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{operationStatusLink}",
    validator: validate_NamespacesGetLongRunningOperationStatus_564350, base: "",
    url: url_NamespacesGetLongRunningOperationStatus_564351,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
