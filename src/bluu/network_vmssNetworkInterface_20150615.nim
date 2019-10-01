
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2015-06-15
## termsOfService: (not provided)
## license: (not provided)
## 
## The Microsoft Azure Network management API provides a RESTful set of web services that interact with Microsoft Azure Networks service to manage your network resources. The API has entities that capture the relationship between an end user and the Microsoft Azure Networks service.
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
  macServiceName = "network-vmssNetworkInterface"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_567863 = ref object of OpenApiRestCall_567641
proc url_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_567865(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineScaleSetName" in path,
        "`virtualMachineScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/networkInterfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_567864(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets all network interfaces in a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the virtual machine scale set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568038 = path.getOrDefault("resourceGroupName")
  valid_568038 = validateParameter(valid_568038, JString, required = true,
                                 default = nil)
  if valid_568038 != nil:
    section.add "resourceGroupName", valid_568038
  var valid_568039 = path.getOrDefault("subscriptionId")
  valid_568039 = validateParameter(valid_568039, JString, required = true,
                                 default = nil)
  if valid_568039 != nil:
    section.add "subscriptionId", valid_568039
  var valid_568040 = path.getOrDefault("virtualMachineScaleSetName")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "virtualMachineScaleSetName", valid_568040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_568064: Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_567863;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all network interfaces in a virtual machine scale set.
  ## 
  let valid = call_568064.validator(path, query, header, formData, body)
  let scheme = call_568064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568064.url(scheme.get, call_568064.host, call_568064.base,
                         call_568064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568064, url, valid)

proc call*(call_568135: Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_567863;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualMachineScaleSetName: string): Recallable =
  ## networkInterfacesListVirtualMachineScaleSetNetworkInterfaces
  ## Gets all network interfaces in a virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  var path_568136 = newJObject()
  var query_568138 = newJObject()
  add(path_568136, "resourceGroupName", newJString(resourceGroupName))
  add(query_568138, "api-version", newJString(apiVersion))
  add(path_568136, "subscriptionId", newJString(subscriptionId))
  add(path_568136, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  result = call_568135.call(path_568136, query_568138, nil, nil, nil)

var networkInterfacesListVirtualMachineScaleSetNetworkInterfaces* = Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_567863(
    name: "networkInterfacesListVirtualMachineScaleSetNetworkInterfaces",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/networkInterfaces", validator: validate_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_567864,
    base: "",
    url: url_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_567865,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_568177 = ref object of OpenApiRestCall_567641
proc url_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_568179(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineScaleSetName" in path,
        "`virtualMachineScaleSetName` is a required path parameter"
  assert "virtualmachineIndex" in path,
        "`virtualmachineIndex` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/virtualMachines/"),
               (kind: VariableSegment, value: "virtualmachineIndex"),
               (kind: ConstantSegment, value: "/networkInterfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_568178(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets information about all network interfaces in a virtual machine in a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualmachineIndex: JString (required)
  ##                      : The virtual machine index.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the virtual machine scale set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568180 = path.getOrDefault("resourceGroupName")
  valid_568180 = validateParameter(valid_568180, JString, required = true,
                                 default = nil)
  if valid_568180 != nil:
    section.add "resourceGroupName", valid_568180
  var valid_568181 = path.getOrDefault("subscriptionId")
  valid_568181 = validateParameter(valid_568181, JString, required = true,
                                 default = nil)
  if valid_568181 != nil:
    section.add "subscriptionId", valid_568181
  var valid_568182 = path.getOrDefault("virtualmachineIndex")
  valid_568182 = validateParameter(valid_568182, JString, required = true,
                                 default = nil)
  if valid_568182 != nil:
    section.add "virtualmachineIndex", valid_568182
  var valid_568183 = path.getOrDefault("virtualMachineScaleSetName")
  valid_568183 = validateParameter(valid_568183, JString, required = true,
                                 default = nil)
  if valid_568183 != nil:
    section.add "virtualMachineScaleSetName", valid_568183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568184 = query.getOrDefault("api-version")
  valid_568184 = validateParameter(valid_568184, JString, required = true,
                                 default = nil)
  if valid_568184 != nil:
    section.add "api-version", valid_568184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568185: Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_568177;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about all network interfaces in a virtual machine in a virtual machine scale set.
  ## 
  let valid = call_568185.validator(path, query, header, formData, body)
  let scheme = call_568185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568185.url(scheme.get, call_568185.host, call_568185.base,
                         call_568185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568185, url, valid)

proc call*(call_568186: Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_568177;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualmachineIndex: string; virtualMachineScaleSetName: string): Recallable =
  ## networkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces
  ## Gets information about all network interfaces in a virtual machine in a virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualmachineIndex: string (required)
  ##                      : The virtual machine index.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  var path_568187 = newJObject()
  var query_568188 = newJObject()
  add(path_568187, "resourceGroupName", newJString(resourceGroupName))
  add(query_568188, "api-version", newJString(apiVersion))
  add(path_568187, "subscriptionId", newJString(subscriptionId))
  add(path_568187, "virtualmachineIndex", newJString(virtualmachineIndex))
  add(path_568187, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  result = call_568186.call(path_568187, query_568188, nil, nil, nil)

var networkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces* = Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_568177(
    name: "networkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces", validator: validate_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_568178,
    base: "",
    url: url_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_568179,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_568189 = ref object of OpenApiRestCall_567641
proc url_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_568191(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineScaleSetName" in path,
        "`virtualMachineScaleSetName` is a required path parameter"
  assert "virtualmachineIndex" in path,
        "`virtualmachineIndex` is a required path parameter"
  assert "networkInterfaceName" in path,
        "`networkInterfaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/virtualMachines/"),
               (kind: VariableSegment, value: "virtualmachineIndex"),
               (kind: ConstantSegment, value: "/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_568190(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the specified network interface in a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualmachineIndex: JString (required)
  ##                      : The virtual machine index.
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the virtual machine scale set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568193 = path.getOrDefault("resourceGroupName")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "resourceGroupName", valid_568193
  var valid_568194 = path.getOrDefault("subscriptionId")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "subscriptionId", valid_568194
  var valid_568195 = path.getOrDefault("virtualmachineIndex")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "virtualmachineIndex", valid_568195
  var valid_568196 = path.getOrDefault("networkInterfaceName")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "networkInterfaceName", valid_568196
  var valid_568197 = path.getOrDefault("virtualMachineScaleSetName")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "virtualMachineScaleSetName", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568198 = query.getOrDefault("api-version")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "api-version", valid_568198
  var valid_568199 = query.getOrDefault("$expand")
  valid_568199 = validateParameter(valid_568199, JString, required = false,
                                 default = nil)
  if valid_568199 != nil:
    section.add "$expand", valid_568199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568200: Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_568189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified network interface in a virtual machine scale set.
  ## 
  let valid = call_568200.validator(path, query, header, formData, body)
  let scheme = call_568200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568200.url(scheme.get, call_568200.host, call_568200.base,
                         call_568200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568200, url, valid)

proc call*(call_568201: Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_568189;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualmachineIndex: string; networkInterfaceName: string;
          virtualMachineScaleSetName: string; Expand: string = ""): Recallable =
  ## networkInterfacesGetVirtualMachineScaleSetNetworkInterface
  ## Get the specified network interface in a virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Expands referenced resources.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualmachineIndex: string (required)
  ##                      : The virtual machine index.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  var path_568202 = newJObject()
  var query_568203 = newJObject()
  add(path_568202, "resourceGroupName", newJString(resourceGroupName))
  add(query_568203, "api-version", newJString(apiVersion))
  add(query_568203, "$expand", newJString(Expand))
  add(path_568202, "subscriptionId", newJString(subscriptionId))
  add(path_568202, "virtualmachineIndex", newJString(virtualmachineIndex))
  add(path_568202, "networkInterfaceName", newJString(networkInterfaceName))
  add(path_568202, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  result = call_568201.call(path_568202, query_568203, nil, nil, nil)

var networkInterfacesGetVirtualMachineScaleSetNetworkInterface* = Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_568189(
    name: "networkInterfacesGetVirtualMachineScaleSetNetworkInterface",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces/{networkInterfaceName}", validator: validate_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_568190,
    base: "", url: url_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_568191,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
