
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NotificationHubsManagementClient
## version: 2016-03-01
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "notificationhubs"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_NamespacesCheckAvailability_567863 = ref object of OpenApiRestCall_567641
proc url_NamespacesCheckAvailability_567865(protocol: Scheme; host: string;
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

proc validate_NamespacesCheckAvailability_567864(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks the availability of the given service namespace across all Azure subscriptions. This is useful because the domain name is created based on the service namespace name.
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
  var valid_568055 = path.getOrDefault("subscriptionId")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "subscriptionId", valid_568055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568056 = query.getOrDefault("api-version")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "api-version", valid_568056
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

proc call*(call_568080: Call_NamespacesCheckAvailability_567863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks the availability of the given service namespace across all Azure subscriptions. This is useful because the domain name is created based on the service namespace name.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj870968.aspx
  let valid = call_568080.validator(path, query, header, formData, body)
  let scheme = call_568080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568080.url(scheme.get, call_568080.host, call_568080.base,
                         call_568080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568080, url, valid)

proc call*(call_568151: Call_NamespacesCheckAvailability_567863;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCheckAvailability
  ## Checks the availability of the given service namespace across all Azure subscriptions. This is useful because the domain name is created based on the service namespace name.
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj870968.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The namespace name.
  var path_568152 = newJObject()
  var query_568154 = newJObject()
  var body_568155 = newJObject()
  add(query_568154, "api-version", newJString(apiVersion))
  add(path_568152, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568155 = parameters
  result = call_568151.call(path_568152, query_568154, nil, nil, body_568155)

var namespacesCheckAvailability* = Call_NamespacesCheckAvailability_567863(
    name: "namespacesCheckAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.NotificationHubs/checkNamespaceAvailability",
    validator: validate_NamespacesCheckAvailability_567864, base: "",
    url: url_NamespacesCheckAvailability_567865, schemes: {Scheme.Https})
type
  Call_NamespacesListAll_568194 = ref object of OpenApiRestCall_567641
proc url_NamespacesListAll_568196(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesListAll_568195(path: JsonNode; query: JsonNode;
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
  var valid_568197 = path.getOrDefault("subscriptionId")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "subscriptionId", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568198 = query.getOrDefault("api-version")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "api-version", valid_568198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568199: Call_NamespacesListAll_568194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available namespaces within the subscription irrespective of the resourceGroups.
  ## 
  ## http://msdn.microsoft.com/en-us/library/azure/hh780759.aspx
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_NamespacesListAll_568194; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesListAll
  ## Lists all the available namespaces within the subscription irrespective of the resourceGroups.
  ## http://msdn.microsoft.com/en-us/library/azure/hh780759.aspx
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568201 = newJObject()
  var query_568202 = newJObject()
  add(query_568202, "api-version", newJString(apiVersion))
  add(path_568201, "subscriptionId", newJString(subscriptionId))
  result = call_568200.call(path_568201, query_568202, nil, nil, nil)

var namespacesListAll* = Call_NamespacesListAll_568194(name: "namespacesListAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.NotificationHubs/namespaces",
    validator: validate_NamespacesListAll_568195, base: "",
    url: url_NamespacesListAll_568196, schemes: {Scheme.Https})
type
  Call_NamespacesList_568203 = ref object of OpenApiRestCall_567641
proc url_NamespacesList_568205(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesList_568204(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists the available namespaces within a resourceGroup.
  ## 
  ## http://msdn.microsoft.com/en-us/library/azure/hh780759.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. If resourceGroupName value is null the method lists all the namespaces within subscription
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568206 = path.getOrDefault("resourceGroupName")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "resourceGroupName", valid_568206
  var valid_568207 = path.getOrDefault("subscriptionId")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "subscriptionId", valid_568207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568208 = query.getOrDefault("api-version")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "api-version", valid_568208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568209: Call_NamespacesList_568203; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available namespaces within a resourceGroup.
  ## 
  ## http://msdn.microsoft.com/en-us/library/azure/hh780759.aspx
  let valid = call_568209.validator(path, query, header, formData, body)
  let scheme = call_568209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568209.url(scheme.get, call_568209.host, call_568209.base,
                         call_568209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568209, url, valid)

proc call*(call_568210: Call_NamespacesList_568203; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesList
  ## Lists the available namespaces within a resourceGroup.
  ## http://msdn.microsoft.com/en-us/library/azure/hh780759.aspx
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. If resourceGroupName value is null the method lists all the namespaces within subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568211 = newJObject()
  var query_568212 = newJObject()
  add(path_568211, "resourceGroupName", newJString(resourceGroupName))
  add(query_568212, "api-version", newJString(apiVersion))
  add(path_568211, "subscriptionId", newJString(subscriptionId))
  result = call_568210.call(path_568211, query_568212, nil, nil, nil)

var namespacesList* = Call_NamespacesList_568203(name: "namespacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces",
    validator: validate_NamespacesList_568204, base: "", url: url_NamespacesList_568205,
    schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdate_568224 = ref object of OpenApiRestCall_567641
proc url_NamespacesCreateOrUpdate_568226(protocol: Scheme; host: string;
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

proc validate_NamespacesCreateOrUpdate_568225(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates/Updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856303.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568227 = path.getOrDefault("namespaceName")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "namespaceName", valid_568227
  var valid_568228 = path.getOrDefault("resourceGroupName")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "resourceGroupName", valid_568228
  var valid_568229 = path.getOrDefault("subscriptionId")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "subscriptionId", valid_568229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568230 = query.getOrDefault("api-version")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "api-version", valid_568230
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

proc call*(call_568232: Call_NamespacesCreateOrUpdate_568224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates/Updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856303.aspx
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_NamespacesCreateOrUpdate_568224;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdate
  ## Creates/Updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856303.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a Namespace Resource.
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  var body_568236 = newJObject()
  add(path_568234, "namespaceName", newJString(namespaceName))
  add(path_568234, "resourceGroupName", newJString(resourceGroupName))
  add(query_568235, "api-version", newJString(apiVersion))
  add(path_568234, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568236 = parameters
  result = call_568233.call(path_568234, query_568235, nil, nil, body_568236)

var namespacesCreateOrUpdate* = Call_NamespacesCreateOrUpdate_568224(
    name: "namespacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}",
    validator: validate_NamespacesCreateOrUpdate_568225, base: "",
    url: url_NamespacesCreateOrUpdate_568226, schemes: {Scheme.Https})
type
  Call_NamespacesGet_568213 = ref object of OpenApiRestCall_567641
proc url_NamespacesGet_568215(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesGet_568214(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the description for the specified namespace.
  ## 
  ## http://msdn.microsoft.com/library/azure/dn140232.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568216 = path.getOrDefault("namespaceName")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "namespaceName", valid_568216
  var valid_568217 = path.getOrDefault("resourceGroupName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "resourceGroupName", valid_568217
  var valid_568218 = path.getOrDefault("subscriptionId")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "subscriptionId", valid_568218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568219 = query.getOrDefault("api-version")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "api-version", valid_568219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568220: Call_NamespacesGet_568213; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the description for the specified namespace.
  ## 
  ## http://msdn.microsoft.com/library/azure/dn140232.aspx
  let valid = call_568220.validator(path, query, header, formData, body)
  let scheme = call_568220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568220.url(scheme.get, call_568220.host, call_568220.base,
                         call_568220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568220, url, valid)

proc call*(call_568221: Call_NamespacesGet_568213; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesGet
  ## Returns the description for the specified namespace.
  ## http://msdn.microsoft.com/library/azure/dn140232.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568222 = newJObject()
  var query_568223 = newJObject()
  add(path_568222, "namespaceName", newJString(namespaceName))
  add(path_568222, "resourceGroupName", newJString(resourceGroupName))
  add(query_568223, "api-version", newJString(apiVersion))
  add(path_568222, "subscriptionId", newJString(subscriptionId))
  result = call_568221.call(path_568222, query_568223, nil, nil, nil)

var namespacesGet* = Call_NamespacesGet_568213(name: "namespacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}",
    validator: validate_NamespacesGet_568214, base: "", url: url_NamespacesGet_568215,
    schemes: {Scheme.Https})
type
  Call_NamespacesPatch_568248 = ref object of OpenApiRestCall_567641
proc url_NamespacesPatch_568250(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesPatch_568249(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Patches the existing namespace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568251 = path.getOrDefault("namespaceName")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "namespaceName", valid_568251
  var valid_568252 = path.getOrDefault("resourceGroupName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "resourceGroupName", valid_568252
  var valid_568253 = path.getOrDefault("subscriptionId")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "subscriptionId", valid_568253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568254 = query.getOrDefault("api-version")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "api-version", valid_568254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to patch a Namespace Resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568256: Call_NamespacesPatch_568248; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches the existing namespace
  ## 
  let valid = call_568256.validator(path, query, header, formData, body)
  let scheme = call_568256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568256.url(scheme.get, call_568256.host, call_568256.base,
                         call_568256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568256, url, valid)

proc call*(call_568257: Call_NamespacesPatch_568248; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesPatch
  ## Patches the existing namespace
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to patch a Namespace Resource.
  var path_568258 = newJObject()
  var query_568259 = newJObject()
  var body_568260 = newJObject()
  add(path_568258, "namespaceName", newJString(namespaceName))
  add(path_568258, "resourceGroupName", newJString(resourceGroupName))
  add(query_568259, "api-version", newJString(apiVersion))
  add(path_568258, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568260 = parameters
  result = call_568257.call(path_568258, query_568259, nil, nil, body_568260)

var namespacesPatch* = Call_NamespacesPatch_568248(name: "namespacesPatch",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}",
    validator: validate_NamespacesPatch_568249, base: "", url: url_NamespacesPatch_568250,
    schemes: {Scheme.Https})
type
  Call_NamespacesDelete_568237 = ref object of OpenApiRestCall_567641
proc url_NamespacesDelete_568239(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesDelete_568238(path: JsonNode; query: JsonNode;
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
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568240 = path.getOrDefault("namespaceName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "namespaceName", valid_568240
  var valid_568241 = path.getOrDefault("resourceGroupName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "resourceGroupName", valid_568241
  var valid_568242 = path.getOrDefault("subscriptionId")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "subscriptionId", valid_568242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568243 = query.getOrDefault("api-version")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "api-version", valid_568243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568244: Call_NamespacesDelete_568237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing namespace. This operation also removes all associated notificationHubs under the namespace.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856296.aspx
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_NamespacesDelete_568237; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesDelete
  ## Deletes an existing namespace. This operation also removes all associated notificationHubs under the namespace.
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856296.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  add(path_568246, "namespaceName", newJString(namespaceName))
  add(path_568246, "resourceGroupName", newJString(resourceGroupName))
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  result = call_568245.call(path_568246, query_568247, nil, nil, nil)

var namespacesDelete* = Call_NamespacesDelete_568237(name: "namespacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}",
    validator: validate_NamespacesDelete_568238, base: "",
    url: url_NamespacesDelete_568239, schemes: {Scheme.Https})
type
  Call_NamespacesListAuthorizationRules_568261 = ref object of OpenApiRestCall_567641
proc url_NamespacesListAuthorizationRules_568263(protocol: Scheme; host: string;
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

proc validate_NamespacesListAuthorizationRules_568262(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the authorization rules for a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568264 = path.getOrDefault("namespaceName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "namespaceName", valid_568264
  var valid_568265 = path.getOrDefault("resourceGroupName")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "resourceGroupName", valid_568265
  var valid_568266 = path.getOrDefault("subscriptionId")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "subscriptionId", valid_568266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568267 = query.getOrDefault("api-version")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "api-version", valid_568267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568268: Call_NamespacesListAuthorizationRules_568261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the authorization rules for a namespace.
  ## 
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_NamespacesListAuthorizationRules_568261;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesListAuthorizationRules
  ## Gets the authorization rules for a namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  add(path_568270, "namespaceName", newJString(namespaceName))
  add(path_568270, "resourceGroupName", newJString(resourceGroupName))
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "subscriptionId", newJString(subscriptionId))
  result = call_568269.call(path_568270, query_568271, nil, nil, nil)

var namespacesListAuthorizationRules* = Call_NamespacesListAuthorizationRules_568261(
    name: "namespacesListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/AuthorizationRules",
    validator: validate_NamespacesListAuthorizationRules_568262, base: "",
    url: url_NamespacesListAuthorizationRules_568263, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateAuthorizationRule_568284 = ref object of OpenApiRestCall_567641
proc url_NamespacesCreateOrUpdateAuthorizationRule_568286(protocol: Scheme;
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

proc validate_NamespacesCreateOrUpdateAuthorizationRule_568285(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an authorization rule for a namespace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : Authorization Rule Name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568287 = path.getOrDefault("namespaceName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "namespaceName", valid_568287
  var valid_568288 = path.getOrDefault("resourceGroupName")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "resourceGroupName", valid_568288
  var valid_568289 = path.getOrDefault("authorizationRuleName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "authorizationRuleName", valid_568289
  var valid_568290 = path.getOrDefault("subscriptionId")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "subscriptionId", valid_568290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568291 = query.getOrDefault("api-version")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "api-version", valid_568291
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

proc call*(call_568293: Call_NamespacesCreateOrUpdateAuthorizationRule_568284;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an authorization rule for a namespace
  ## 
  let valid = call_568293.validator(path, query, header, formData, body)
  let scheme = call_568293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568293.url(scheme.get, call_568293.host, call_568293.base,
                         call_568293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568293, url, valid)

proc call*(call_568294: Call_NamespacesCreateOrUpdateAuthorizationRule_568284;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateAuthorizationRule
  ## Creates an authorization rule for a namespace
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : Authorization Rule Name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  var path_568295 = newJObject()
  var query_568296 = newJObject()
  var body_568297 = newJObject()
  add(path_568295, "namespaceName", newJString(namespaceName))
  add(path_568295, "resourceGroupName", newJString(resourceGroupName))
  add(query_568296, "api-version", newJString(apiVersion))
  add(path_568295, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568295, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568297 = parameters
  result = call_568294.call(path_568295, query_568296, nil, nil, body_568297)

var namespacesCreateOrUpdateAuthorizationRule* = Call_NamespacesCreateOrUpdateAuthorizationRule_568284(
    name: "namespacesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesCreateOrUpdateAuthorizationRule_568285,
    base: "", url: url_NamespacesCreateOrUpdateAuthorizationRule_568286,
    schemes: {Scheme.Https})
type
  Call_NamespacesGetAuthorizationRule_568272 = ref object of OpenApiRestCall_567641
proc url_NamespacesGetAuthorizationRule_568274(protocol: Scheme; host: string;
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

proc validate_NamespacesGetAuthorizationRule_568273(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an authorization rule for a namespace by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : Authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568275 = path.getOrDefault("namespaceName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "namespaceName", valid_568275
  var valid_568276 = path.getOrDefault("resourceGroupName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "resourceGroupName", valid_568276
  var valid_568277 = path.getOrDefault("authorizationRuleName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "authorizationRuleName", valid_568277
  var valid_568278 = path.getOrDefault("subscriptionId")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "subscriptionId", valid_568278
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568279 = query.getOrDefault("api-version")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "api-version", valid_568279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568280: Call_NamespacesGetAuthorizationRule_568272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an authorization rule for a namespace by name.
  ## 
  let valid = call_568280.validator(path, query, header, formData, body)
  let scheme = call_568280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568280.url(scheme.get, call_568280.host, call_568280.base,
                         call_568280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568280, url, valid)

proc call*(call_568281: Call_NamespacesGetAuthorizationRule_568272;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesGetAuthorizationRule
  ## Gets an authorization rule for a namespace by name.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : Authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568282 = newJObject()
  var query_568283 = newJObject()
  add(path_568282, "namespaceName", newJString(namespaceName))
  add(path_568282, "resourceGroupName", newJString(resourceGroupName))
  add(query_568283, "api-version", newJString(apiVersion))
  add(path_568282, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568282, "subscriptionId", newJString(subscriptionId))
  result = call_568281.call(path_568282, query_568283, nil, nil, nil)

var namespacesGetAuthorizationRule* = Call_NamespacesGetAuthorizationRule_568272(
    name: "namespacesGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesGetAuthorizationRule_568273, base: "",
    url: url_NamespacesGetAuthorizationRule_568274, schemes: {Scheme.Https})
type
  Call_NamespacesDeleteAuthorizationRule_568298 = ref object of OpenApiRestCall_567641
proc url_NamespacesDeleteAuthorizationRule_568300(protocol: Scheme; host: string;
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

proc validate_NamespacesDeleteAuthorizationRule_568299(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a namespace authorization rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : Authorization Rule Name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568301 = path.getOrDefault("namespaceName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "namespaceName", valid_568301
  var valid_568302 = path.getOrDefault("resourceGroupName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "resourceGroupName", valid_568302
  var valid_568303 = path.getOrDefault("authorizationRuleName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "authorizationRuleName", valid_568303
  var valid_568304 = path.getOrDefault("subscriptionId")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "subscriptionId", valid_568304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568305 = query.getOrDefault("api-version")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "api-version", valid_568305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568306: Call_NamespacesDeleteAuthorizationRule_568298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a namespace authorization rule
  ## 
  let valid = call_568306.validator(path, query, header, formData, body)
  let scheme = call_568306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568306.url(scheme.get, call_568306.host, call_568306.base,
                         call_568306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568306, url, valid)

proc call*(call_568307: Call_NamespacesDeleteAuthorizationRule_568298;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesDeleteAuthorizationRule
  ## Deletes a namespace authorization rule
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : Authorization Rule Name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568308 = newJObject()
  var query_568309 = newJObject()
  add(path_568308, "namespaceName", newJString(namespaceName))
  add(path_568308, "resourceGroupName", newJString(resourceGroupName))
  add(query_568309, "api-version", newJString(apiVersion))
  add(path_568308, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568308, "subscriptionId", newJString(subscriptionId))
  result = call_568307.call(path_568308, query_568309, nil, nil, nil)

var namespacesDeleteAuthorizationRule* = Call_NamespacesDeleteAuthorizationRule_568298(
    name: "namespacesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesDeleteAuthorizationRule_568299, base: "",
    url: url_NamespacesDeleteAuthorizationRule_568300, schemes: {Scheme.Https})
type
  Call_NamespacesListKeys_568310 = ref object of OpenApiRestCall_567641
proc url_NamespacesListKeys_568312(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesListKeys_568311(path: JsonNode; query: JsonNode;
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
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : The connection string of the namespace for the specified authorizationRule.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568313 = path.getOrDefault("namespaceName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "namespaceName", valid_568313
  var valid_568314 = path.getOrDefault("resourceGroupName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "resourceGroupName", valid_568314
  var valid_568315 = path.getOrDefault("authorizationRuleName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "authorizationRuleName", valid_568315
  var valid_568316 = path.getOrDefault("subscriptionId")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "subscriptionId", valid_568316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568317 = query.getOrDefault("api-version")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "api-version", valid_568317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568318: Call_NamespacesListKeys_568310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Primary and Secondary ConnectionStrings to the namespace 
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj873988.aspx
  let valid = call_568318.validator(path, query, header, formData, body)
  let scheme = call_568318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568318.url(scheme.get, call_568318.host, call_568318.base,
                         call_568318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568318, url, valid)

proc call*(call_568319: Call_NamespacesListKeys_568310; namespaceName: string;
          resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesListKeys
  ## Gets the Primary and Secondary ConnectionStrings to the namespace 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj873988.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The connection string of the namespace for the specified authorizationRule.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568320 = newJObject()
  var query_568321 = newJObject()
  add(path_568320, "namespaceName", newJString(namespaceName))
  add(path_568320, "resourceGroupName", newJString(resourceGroupName))
  add(query_568321, "api-version", newJString(apiVersion))
  add(path_568320, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568320, "subscriptionId", newJString(subscriptionId))
  result = call_568319.call(path_568320, query_568321, nil, nil, nil)

var namespacesListKeys* = Call_NamespacesListKeys_568310(
    name: "namespacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_NamespacesListKeys_568311, base: "",
    url: url_NamespacesListKeys_568312, schemes: {Scheme.Https})
type
  Call_NamespacesRegenerateKeys_568322 = ref object of OpenApiRestCall_567641
proc url_NamespacesRegenerateKeys_568324(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesRegenerateKeys_568323(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the Primary/Secondary Keys to the Namespace Authorization Rule
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj873988.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : The connection string of the namespace for the specified authorizationRule.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568325 = path.getOrDefault("namespaceName")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "namespaceName", valid_568325
  var valid_568326 = path.getOrDefault("resourceGroupName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "resourceGroupName", valid_568326
  var valid_568327 = path.getOrDefault("authorizationRuleName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "authorizationRuleName", valid_568327
  var valid_568328 = path.getOrDefault("subscriptionId")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "subscriptionId", valid_568328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568329 = query.getOrDefault("api-version")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "api-version", valid_568329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the Namespace Authorization Rule Key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568331: Call_NamespacesRegenerateKeys_568322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the Primary/Secondary Keys to the Namespace Authorization Rule
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj873988.aspx
  let valid = call_568331.validator(path, query, header, formData, body)
  let scheme = call_568331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568331.url(scheme.get, call_568331.host, call_568331.base,
                         call_568331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568331, url, valid)

proc call*(call_568332: Call_NamespacesRegenerateKeys_568322;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesRegenerateKeys
  ## Regenerates the Primary/Secondary Keys to the Namespace Authorization Rule
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj873988.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The connection string of the namespace for the specified authorizationRule.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the Namespace Authorization Rule Key.
  var path_568333 = newJObject()
  var query_568334 = newJObject()
  var body_568335 = newJObject()
  add(path_568333, "namespaceName", newJString(namespaceName))
  add(path_568333, "resourceGroupName", newJString(resourceGroupName))
  add(query_568334, "api-version", newJString(apiVersion))
  add(path_568333, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568333, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568335 = parameters
  result = call_568332.call(path_568333, query_568334, nil, nil, body_568335)

var namespacesRegenerateKeys* = Call_NamespacesRegenerateKeys_568322(
    name: "namespacesRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_NamespacesRegenerateKeys_568323, base: "",
    url: url_NamespacesRegenerateKeys_568324, schemes: {Scheme.Https})
type
  Call_NotificationHubsCheckAvailability_568336 = ref object of OpenApiRestCall_567641
proc url_NotificationHubsCheckAvailability_568338(protocol: Scheme; host: string;
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

proc validate_NotificationHubsCheckAvailability_568337(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks the availability of the given notificationHub in a namespace.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj870968.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568339 = path.getOrDefault("namespaceName")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "namespaceName", valid_568339
  var valid_568340 = path.getOrDefault("resourceGroupName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "resourceGroupName", valid_568340
  var valid_568341 = path.getOrDefault("subscriptionId")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "subscriptionId", valid_568341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568342 = query.getOrDefault("api-version")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "api-version", valid_568342
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

proc call*(call_568344: Call_NotificationHubsCheckAvailability_568336;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks the availability of the given notificationHub in a namespace.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj870968.aspx
  let valid = call_568344.validator(path, query, header, formData, body)
  let scheme = call_568344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568344.url(scheme.get, call_568344.host, call_568344.base,
                         call_568344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568344, url, valid)

proc call*(call_568345: Call_NotificationHubsCheckAvailability_568336;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## notificationHubsCheckAvailability
  ## Checks the availability of the given notificationHub in a namespace.
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj870968.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The notificationHub name.
  var path_568346 = newJObject()
  var query_568347 = newJObject()
  var body_568348 = newJObject()
  add(path_568346, "namespaceName", newJString(namespaceName))
  add(path_568346, "resourceGroupName", newJString(resourceGroupName))
  add(query_568347, "api-version", newJString(apiVersion))
  add(path_568346, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568348 = parameters
  result = call_568345.call(path_568346, query_568347, nil, nil, body_568348)

var notificationHubsCheckAvailability* = Call_NotificationHubsCheckAvailability_568336(
    name: "notificationHubsCheckAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/checkNotificationHubAvailability",
    validator: validate_NotificationHubsCheckAvailability_568337, base: "",
    url: url_NotificationHubsCheckAvailability_568338, schemes: {Scheme.Https})
type
  Call_NotificationHubsList_568349 = ref object of OpenApiRestCall_567641
proc url_NotificationHubsList_568351(protocol: Scheme; host: string; base: string;
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

proc validate_NotificationHubsList_568350(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the notification hubs associated with a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568352 = path.getOrDefault("namespaceName")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "namespaceName", valid_568352
  var valid_568353 = path.getOrDefault("resourceGroupName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "resourceGroupName", valid_568353
  var valid_568354 = path.getOrDefault("subscriptionId")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "subscriptionId", valid_568354
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568355 = query.getOrDefault("api-version")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "api-version", valid_568355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568356: Call_NotificationHubsList_568349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the notification hubs associated with a namespace.
  ## 
  let valid = call_568356.validator(path, query, header, formData, body)
  let scheme = call_568356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568356.url(scheme.get, call_568356.host, call_568356.base,
                         call_568356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568356, url, valid)

proc call*(call_568357: Call_NotificationHubsList_568349; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## notificationHubsList
  ## Lists the notification hubs associated with a namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568358 = newJObject()
  var query_568359 = newJObject()
  add(path_568358, "namespaceName", newJString(namespaceName))
  add(path_568358, "resourceGroupName", newJString(resourceGroupName))
  add(query_568359, "api-version", newJString(apiVersion))
  add(path_568358, "subscriptionId", newJString(subscriptionId))
  result = call_568357.call(path_568358, query_568359, nil, nil, nil)

var notificationHubsList* = Call_NotificationHubsList_568349(
    name: "notificationHubsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs",
    validator: validate_NotificationHubsList_568350, base: "",
    url: url_NotificationHubsList_568351, schemes: {Scheme.Https})
type
  Call_NotificationHubsCreateOrUpdate_568372 = ref object of OpenApiRestCall_567641
proc url_NotificationHubsCreateOrUpdate_568374(protocol: Scheme; host: string;
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

proc validate_NotificationHubsCreateOrUpdate_568373(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates/Update a NotificationHub in a namespace.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856303.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568375 = path.getOrDefault("namespaceName")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "namespaceName", valid_568375
  var valid_568376 = path.getOrDefault("resourceGroupName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "resourceGroupName", valid_568376
  var valid_568377 = path.getOrDefault("subscriptionId")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "subscriptionId", valid_568377
  var valid_568378 = path.getOrDefault("notificationHubName")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "notificationHubName", valid_568378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568379 = query.getOrDefault("api-version")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "api-version", valid_568379
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

proc call*(call_568381: Call_NotificationHubsCreateOrUpdate_568372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates/Update a NotificationHub in a namespace.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856303.aspx
  let valid = call_568381.validator(path, query, header, formData, body)
  let scheme = call_568381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568381.url(scheme.get, call_568381.host, call_568381.base,
                         call_568381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568381, url, valid)

proc call*(call_568382: Call_NotificationHubsCreateOrUpdate_568372;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; notificationHubName: string; parameters: JsonNode): Recallable =
  ## notificationHubsCreateOrUpdate
  ## Creates/Update a NotificationHub in a namespace.
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856303.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update a NotificationHub Resource.
  var path_568383 = newJObject()
  var query_568384 = newJObject()
  var body_568385 = newJObject()
  add(path_568383, "namespaceName", newJString(namespaceName))
  add(path_568383, "resourceGroupName", newJString(resourceGroupName))
  add(query_568384, "api-version", newJString(apiVersion))
  add(path_568383, "subscriptionId", newJString(subscriptionId))
  add(path_568383, "notificationHubName", newJString(notificationHubName))
  if parameters != nil:
    body_568385 = parameters
  result = call_568382.call(path_568383, query_568384, nil, nil, body_568385)

var notificationHubsCreateOrUpdate* = Call_NotificationHubsCreateOrUpdate_568372(
    name: "notificationHubsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}",
    validator: validate_NotificationHubsCreateOrUpdate_568373, base: "",
    url: url_NotificationHubsCreateOrUpdate_568374, schemes: {Scheme.Https})
type
  Call_NotificationHubsGet_568360 = ref object of OpenApiRestCall_567641
proc url_NotificationHubsGet_568362(protocol: Scheme; host: string; base: string;
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

proc validate_NotificationHubsGet_568361(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists the notification hubs associated with a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568363 = path.getOrDefault("namespaceName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "namespaceName", valid_568363
  var valid_568364 = path.getOrDefault("resourceGroupName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "resourceGroupName", valid_568364
  var valid_568365 = path.getOrDefault("subscriptionId")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "subscriptionId", valid_568365
  var valid_568366 = path.getOrDefault("notificationHubName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "notificationHubName", valid_568366
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568367 = query.getOrDefault("api-version")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "api-version", valid_568367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568368: Call_NotificationHubsGet_568360; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the notification hubs associated with a namespace.
  ## 
  let valid = call_568368.validator(path, query, header, formData, body)
  let scheme = call_568368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568368.url(scheme.get, call_568368.host, call_568368.base,
                         call_568368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568368, url, valid)

proc call*(call_568369: Call_NotificationHubsGet_568360; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          notificationHubName: string): Recallable =
  ## notificationHubsGet
  ## Lists the notification hubs associated with a namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  var path_568370 = newJObject()
  var query_568371 = newJObject()
  add(path_568370, "namespaceName", newJString(namespaceName))
  add(path_568370, "resourceGroupName", newJString(resourceGroupName))
  add(query_568371, "api-version", newJString(apiVersion))
  add(path_568370, "subscriptionId", newJString(subscriptionId))
  add(path_568370, "notificationHubName", newJString(notificationHubName))
  result = call_568369.call(path_568370, query_568371, nil, nil, nil)

var notificationHubsGet* = Call_NotificationHubsGet_568360(
    name: "notificationHubsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}",
    validator: validate_NotificationHubsGet_568361, base: "",
    url: url_NotificationHubsGet_568362, schemes: {Scheme.Https})
type
  Call_NotificationHubsDelete_568386 = ref object of OpenApiRestCall_567641
proc url_NotificationHubsDelete_568388(protocol: Scheme; host: string; base: string;
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

proc validate_NotificationHubsDelete_568387(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a notification hub associated with a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568389 = path.getOrDefault("namespaceName")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "namespaceName", valid_568389
  var valid_568390 = path.getOrDefault("resourceGroupName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "resourceGroupName", valid_568390
  var valid_568391 = path.getOrDefault("subscriptionId")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "subscriptionId", valid_568391
  var valid_568392 = path.getOrDefault("notificationHubName")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "notificationHubName", valid_568392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568393 = query.getOrDefault("api-version")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "api-version", valid_568393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568394: Call_NotificationHubsDelete_568386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a notification hub associated with a namespace.
  ## 
  let valid = call_568394.validator(path, query, header, formData, body)
  let scheme = call_568394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568394.url(scheme.get, call_568394.host, call_568394.base,
                         call_568394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568394, url, valid)

proc call*(call_568395: Call_NotificationHubsDelete_568386; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          notificationHubName: string): Recallable =
  ## notificationHubsDelete
  ## Deletes a notification hub associated with a namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  var path_568396 = newJObject()
  var query_568397 = newJObject()
  add(path_568396, "namespaceName", newJString(namespaceName))
  add(path_568396, "resourceGroupName", newJString(resourceGroupName))
  add(query_568397, "api-version", newJString(apiVersion))
  add(path_568396, "subscriptionId", newJString(subscriptionId))
  add(path_568396, "notificationHubName", newJString(notificationHubName))
  result = call_568395.call(path_568396, query_568397, nil, nil, nil)

var notificationHubsDelete* = Call_NotificationHubsDelete_568386(
    name: "notificationHubsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}",
    validator: validate_NotificationHubsDelete_568387, base: "",
    url: url_NotificationHubsDelete_568388, schemes: {Scheme.Https})
type
  Call_NotificationHubsListAuthorizationRules_568398 = ref object of OpenApiRestCall_567641
proc url_NotificationHubsListAuthorizationRules_568400(protocol: Scheme;
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

proc validate_NotificationHubsListAuthorizationRules_568399(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the authorization rules for a NotificationHub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568401 = path.getOrDefault("namespaceName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "namespaceName", valid_568401
  var valid_568402 = path.getOrDefault("resourceGroupName")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "resourceGroupName", valid_568402
  var valid_568403 = path.getOrDefault("subscriptionId")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "subscriptionId", valid_568403
  var valid_568404 = path.getOrDefault("notificationHubName")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "notificationHubName", valid_568404
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568405 = query.getOrDefault("api-version")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "api-version", valid_568405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568406: Call_NotificationHubsListAuthorizationRules_568398;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the authorization rules for a NotificationHub.
  ## 
  let valid = call_568406.validator(path, query, header, formData, body)
  let scheme = call_568406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568406.url(scheme.get, call_568406.host, call_568406.base,
                         call_568406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568406, url, valid)

proc call*(call_568407: Call_NotificationHubsListAuthorizationRules_568398;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; notificationHubName: string): Recallable =
  ## notificationHubsListAuthorizationRules
  ## Gets the authorization rules for a NotificationHub.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  var path_568408 = newJObject()
  var query_568409 = newJObject()
  add(path_568408, "namespaceName", newJString(namespaceName))
  add(path_568408, "resourceGroupName", newJString(resourceGroupName))
  add(query_568409, "api-version", newJString(apiVersion))
  add(path_568408, "subscriptionId", newJString(subscriptionId))
  add(path_568408, "notificationHubName", newJString(notificationHubName))
  result = call_568407.call(path_568408, query_568409, nil, nil, nil)

var notificationHubsListAuthorizationRules* = Call_NotificationHubsListAuthorizationRules_568398(
    name: "notificationHubsListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/AuthorizationRules",
    validator: validate_NotificationHubsListAuthorizationRules_568399, base: "",
    url: url_NotificationHubsListAuthorizationRules_568400,
    schemes: {Scheme.Https})
type
  Call_NotificationHubsCreateOrUpdateAuthorizationRule_568423 = ref object of OpenApiRestCall_567641
proc url_NotificationHubsCreateOrUpdateAuthorizationRule_568425(protocol: Scheme;
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

proc validate_NotificationHubsCreateOrUpdateAuthorizationRule_568424(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates/Updates an authorization rule for a NotificationHub
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : Authorization Rule Name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568426 = path.getOrDefault("namespaceName")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "namespaceName", valid_568426
  var valid_568427 = path.getOrDefault("resourceGroupName")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "resourceGroupName", valid_568427
  var valid_568428 = path.getOrDefault("authorizationRuleName")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "authorizationRuleName", valid_568428
  var valid_568429 = path.getOrDefault("subscriptionId")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "subscriptionId", valid_568429
  var valid_568430 = path.getOrDefault("notificationHubName")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "notificationHubName", valid_568430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568431 = query.getOrDefault("api-version")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "api-version", valid_568431
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

proc call*(call_568433: Call_NotificationHubsCreateOrUpdateAuthorizationRule_568423;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates/Updates an authorization rule for a NotificationHub
  ## 
  let valid = call_568433.validator(path, query, header, formData, body)
  let scheme = call_568433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568433.url(scheme.get, call_568433.host, call_568433.base,
                         call_568433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568433, url, valid)

proc call*(call_568434: Call_NotificationHubsCreateOrUpdateAuthorizationRule_568423;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          notificationHubName: string; parameters: JsonNode): Recallable =
  ## notificationHubsCreateOrUpdateAuthorizationRule
  ## Creates/Updates an authorization rule for a NotificationHub
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : Authorization Rule Name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  var path_568435 = newJObject()
  var query_568436 = newJObject()
  var body_568437 = newJObject()
  add(path_568435, "namespaceName", newJString(namespaceName))
  add(path_568435, "resourceGroupName", newJString(resourceGroupName))
  add(query_568436, "api-version", newJString(apiVersion))
  add(path_568435, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568435, "subscriptionId", newJString(subscriptionId))
  add(path_568435, "notificationHubName", newJString(notificationHubName))
  if parameters != nil:
    body_568437 = parameters
  result = call_568434.call(path_568435, query_568436, nil, nil, body_568437)

var notificationHubsCreateOrUpdateAuthorizationRule* = Call_NotificationHubsCreateOrUpdateAuthorizationRule_568423(
    name: "notificationHubsCreateOrUpdateAuthorizationRule",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NotificationHubsCreateOrUpdateAuthorizationRule_568424,
    base: "", url: url_NotificationHubsCreateOrUpdateAuthorizationRule_568425,
    schemes: {Scheme.Https})
type
  Call_NotificationHubsGetAuthorizationRule_568410 = ref object of OpenApiRestCall_567641
proc url_NotificationHubsGetAuthorizationRule_568412(protocol: Scheme;
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

proc validate_NotificationHubsGetAuthorizationRule_568411(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an authorization rule for a NotificationHub by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568413 = path.getOrDefault("namespaceName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "namespaceName", valid_568413
  var valid_568414 = path.getOrDefault("resourceGroupName")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "resourceGroupName", valid_568414
  var valid_568415 = path.getOrDefault("authorizationRuleName")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "authorizationRuleName", valid_568415
  var valid_568416 = path.getOrDefault("subscriptionId")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "subscriptionId", valid_568416
  var valid_568417 = path.getOrDefault("notificationHubName")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "notificationHubName", valid_568417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568418 = query.getOrDefault("api-version")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "api-version", valid_568418
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568419: Call_NotificationHubsGetAuthorizationRule_568410;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an authorization rule for a NotificationHub by name.
  ## 
  let valid = call_568419.validator(path, query, header, formData, body)
  let scheme = call_568419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568419.url(scheme.get, call_568419.host, call_568419.base,
                         call_568419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568419, url, valid)

proc call*(call_568420: Call_NotificationHubsGetAuthorizationRule_568410;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          notificationHubName: string): Recallable =
  ## notificationHubsGetAuthorizationRule
  ## Gets an authorization rule for a NotificationHub by name.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  var path_568421 = newJObject()
  var query_568422 = newJObject()
  add(path_568421, "namespaceName", newJString(namespaceName))
  add(path_568421, "resourceGroupName", newJString(resourceGroupName))
  add(query_568422, "api-version", newJString(apiVersion))
  add(path_568421, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568421, "subscriptionId", newJString(subscriptionId))
  add(path_568421, "notificationHubName", newJString(notificationHubName))
  result = call_568420.call(path_568421, query_568422, nil, nil, nil)

var notificationHubsGetAuthorizationRule* = Call_NotificationHubsGetAuthorizationRule_568410(
    name: "notificationHubsGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NotificationHubsGetAuthorizationRule_568411, base: "",
    url: url_NotificationHubsGetAuthorizationRule_568412, schemes: {Scheme.Https})
type
  Call_NotificationHubsDeleteAuthorizationRule_568438 = ref object of OpenApiRestCall_567641
proc url_NotificationHubsDeleteAuthorizationRule_568440(protocol: Scheme;
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

proc validate_NotificationHubsDeleteAuthorizationRule_568439(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a notificationHub authorization rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : Authorization Rule Name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568441 = path.getOrDefault("namespaceName")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "namespaceName", valid_568441
  var valid_568442 = path.getOrDefault("resourceGroupName")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "resourceGroupName", valid_568442
  var valid_568443 = path.getOrDefault("authorizationRuleName")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "authorizationRuleName", valid_568443
  var valid_568444 = path.getOrDefault("subscriptionId")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "subscriptionId", valid_568444
  var valid_568445 = path.getOrDefault("notificationHubName")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "notificationHubName", valid_568445
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568446 = query.getOrDefault("api-version")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "api-version", valid_568446
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568447: Call_NotificationHubsDeleteAuthorizationRule_568438;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a notificationHub authorization rule
  ## 
  let valid = call_568447.validator(path, query, header, formData, body)
  let scheme = call_568447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568447.url(scheme.get, call_568447.host, call_568447.base,
                         call_568447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568447, url, valid)

proc call*(call_568448: Call_NotificationHubsDeleteAuthorizationRule_568438;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          notificationHubName: string): Recallable =
  ## notificationHubsDeleteAuthorizationRule
  ## Deletes a notificationHub authorization rule
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : Authorization Rule Name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  var path_568449 = newJObject()
  var query_568450 = newJObject()
  add(path_568449, "namespaceName", newJString(namespaceName))
  add(path_568449, "resourceGroupName", newJString(resourceGroupName))
  add(query_568450, "api-version", newJString(apiVersion))
  add(path_568449, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568449, "subscriptionId", newJString(subscriptionId))
  add(path_568449, "notificationHubName", newJString(notificationHubName))
  result = call_568448.call(path_568449, query_568450, nil, nil, nil)

var notificationHubsDeleteAuthorizationRule* = Call_NotificationHubsDeleteAuthorizationRule_568438(
    name: "notificationHubsDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NotificationHubsDeleteAuthorizationRule_568439, base: "",
    url: url_NotificationHubsDeleteAuthorizationRule_568440,
    schemes: {Scheme.Https})
type
  Call_NotificationHubsListKeys_568451 = ref object of OpenApiRestCall_567641
proc url_NotificationHubsListKeys_568453(protocol: Scheme; host: string;
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

proc validate_NotificationHubsListKeys_568452(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Primary and Secondary ConnectionStrings to the NotificationHub 
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj873988.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : The connection string of the NotificationHub for the specified authorizationRule.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568454 = path.getOrDefault("namespaceName")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "namespaceName", valid_568454
  var valid_568455 = path.getOrDefault("resourceGroupName")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "resourceGroupName", valid_568455
  var valid_568456 = path.getOrDefault("authorizationRuleName")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "authorizationRuleName", valid_568456
  var valid_568457 = path.getOrDefault("subscriptionId")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "subscriptionId", valid_568457
  var valid_568458 = path.getOrDefault("notificationHubName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "notificationHubName", valid_568458
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568459 = query.getOrDefault("api-version")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "api-version", valid_568459
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568460: Call_NotificationHubsListKeys_568451; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Primary and Secondary ConnectionStrings to the NotificationHub 
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj873988.aspx
  let valid = call_568460.validator(path, query, header, formData, body)
  let scheme = call_568460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568460.url(scheme.get, call_568460.host, call_568460.base,
                         call_568460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568460, url, valid)

proc call*(call_568461: Call_NotificationHubsListKeys_568451;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          notificationHubName: string): Recallable =
  ## notificationHubsListKeys
  ## Gets the Primary and Secondary ConnectionStrings to the NotificationHub 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj873988.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The connection string of the NotificationHub for the specified authorizationRule.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  var path_568462 = newJObject()
  var query_568463 = newJObject()
  add(path_568462, "namespaceName", newJString(namespaceName))
  add(path_568462, "resourceGroupName", newJString(resourceGroupName))
  add(query_568463, "api-version", newJString(apiVersion))
  add(path_568462, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568462, "subscriptionId", newJString(subscriptionId))
  add(path_568462, "notificationHubName", newJString(notificationHubName))
  result = call_568461.call(path_568462, query_568463, nil, nil, nil)

var notificationHubsListKeys* = Call_NotificationHubsListKeys_568451(
    name: "notificationHubsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/AuthorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_NotificationHubsListKeys_568452, base: "",
    url: url_NotificationHubsListKeys_568453, schemes: {Scheme.Https})
type
  Call_NotificationHubsRegenerateKeys_568464 = ref object of OpenApiRestCall_567641
proc url_NotificationHubsRegenerateKeys_568466(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsRegenerateKeys_568465(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the Primary/Secondary Keys to the NotificationHub Authorization Rule
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj873988.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : The connection string of the NotificationHub for the specified authorizationRule.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568467 = path.getOrDefault("namespaceName")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "namespaceName", valid_568467
  var valid_568468 = path.getOrDefault("resourceGroupName")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "resourceGroupName", valid_568468
  var valid_568469 = path.getOrDefault("authorizationRuleName")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "authorizationRuleName", valid_568469
  var valid_568470 = path.getOrDefault("subscriptionId")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "subscriptionId", valid_568470
  var valid_568471 = path.getOrDefault("notificationHubName")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "notificationHubName", valid_568471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568472 = query.getOrDefault("api-version")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "api-version", valid_568472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the NotificationHub Authorization Rule Key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568474: Call_NotificationHubsRegenerateKeys_568464; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the Primary/Secondary Keys to the NotificationHub Authorization Rule
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj873988.aspx
  let valid = call_568474.validator(path, query, header, formData, body)
  let scheme = call_568474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568474.url(scheme.get, call_568474.host, call_568474.base,
                         call_568474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568474, url, valid)

proc call*(call_568475: Call_NotificationHubsRegenerateKeys_568464;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          notificationHubName: string; parameters: JsonNode): Recallable =
  ## notificationHubsRegenerateKeys
  ## Regenerates the Primary/Secondary Keys to the NotificationHub Authorization Rule
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj873988.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The connection string of the NotificationHub for the specified authorizationRule.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the NotificationHub Authorization Rule Key.
  var path_568476 = newJObject()
  var query_568477 = newJObject()
  var body_568478 = newJObject()
  add(path_568476, "namespaceName", newJString(namespaceName))
  add(path_568476, "resourceGroupName", newJString(resourceGroupName))
  add(query_568477, "api-version", newJString(apiVersion))
  add(path_568476, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_568476, "subscriptionId", newJString(subscriptionId))
  add(path_568476, "notificationHubName", newJString(notificationHubName))
  if parameters != nil:
    body_568478 = parameters
  result = call_568475.call(path_568476, query_568477, nil, nil, body_568478)

var notificationHubsRegenerateKeys* = Call_NotificationHubsRegenerateKeys_568464(
    name: "notificationHubsRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/AuthorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_NotificationHubsRegenerateKeys_568465, base: "",
    url: url_NotificationHubsRegenerateKeys_568466, schemes: {Scheme.Https})
type
  Call_NotificationHubsGetPnsCredentials_568479 = ref object of OpenApiRestCall_567641
proc url_NotificationHubsGetPnsCredentials_568481(protocol: Scheme; host: string;
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

proc validate_NotificationHubsGetPnsCredentials_568480(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the PNS Credentials associated with a notification hub .
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_568482 = path.getOrDefault("namespaceName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "namespaceName", valid_568482
  var valid_568483 = path.getOrDefault("resourceGroupName")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "resourceGroupName", valid_568483
  var valid_568484 = path.getOrDefault("subscriptionId")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "subscriptionId", valid_568484
  var valid_568485 = path.getOrDefault("notificationHubName")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "notificationHubName", valid_568485
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568486 = query.getOrDefault("api-version")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "api-version", valid_568486
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568487: Call_NotificationHubsGetPnsCredentials_568479;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the PNS Credentials associated with a notification hub .
  ## 
  let valid = call_568487.validator(path, query, header, formData, body)
  let scheme = call_568487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568487.url(scheme.get, call_568487.host, call_568487.base,
                         call_568487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568487, url, valid)

proc call*(call_568488: Call_NotificationHubsGetPnsCredentials_568479;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; notificationHubName: string): Recallable =
  ## notificationHubsGetPnsCredentials
  ## Lists the PNS Credentials associated with a notification hub .
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  var path_568489 = newJObject()
  var query_568490 = newJObject()
  add(path_568489, "namespaceName", newJString(namespaceName))
  add(path_568489, "resourceGroupName", newJString(resourceGroupName))
  add(query_568490, "api-version", newJString(apiVersion))
  add(path_568489, "subscriptionId", newJString(subscriptionId))
  add(path_568489, "notificationHubName", newJString(notificationHubName))
  result = call_568488.call(path_568489, query_568490, nil, nil, nil)

var notificationHubsGetPnsCredentials* = Call_NotificationHubsGetPnsCredentials_568479(
    name: "notificationHubsGetPnsCredentials", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/pnsCredentials",
    validator: validate_NotificationHubsGetPnsCredentials_568480, base: "",
    url: url_NotificationHubsGetPnsCredentials_568481, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
