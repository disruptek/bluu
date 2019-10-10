
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2017-03-30
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "network-vmssPublicIpAddress"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PublicIPAddressesListVirtualMachineScaleSetPublicIPAddresses_573879 = ref object of OpenApiRestCall_573657
proc url_PublicIPAddressesListVirtualMachineScaleSetPublicIPAddresses_573881(
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
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/publicipaddresses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublicIPAddressesListVirtualMachineScaleSetPublicIPAddresses_573880(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets information about all public IP addresses on a virtual machine scale set level.
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
  var valid_574041 = path.getOrDefault("resourceGroupName")
  valid_574041 = validateParameter(valid_574041, JString, required = true,
                                 default = nil)
  if valid_574041 != nil:
    section.add "resourceGroupName", valid_574041
  var valid_574042 = path.getOrDefault("subscriptionId")
  valid_574042 = validateParameter(valid_574042, JString, required = true,
                                 default = nil)
  if valid_574042 != nil:
    section.add "subscriptionId", valid_574042
  var valid_574043 = path.getOrDefault("virtualMachineScaleSetName")
  valid_574043 = validateParameter(valid_574043, JString, required = true,
                                 default = nil)
  if valid_574043 != nil:
    section.add "virtualMachineScaleSetName", valid_574043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574057 = query.getOrDefault("api-version")
  valid_574057 = validateParameter(valid_574057, JString, required = true,
                                 default = newJString("2017-03-30"))
  if valid_574057 != nil:
    section.add "api-version", valid_574057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574084: Call_PublicIPAddressesListVirtualMachineScaleSetPublicIPAddresses_573879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about all public IP addresses on a virtual machine scale set level.
  ## 
  let valid = call_574084.validator(path, query, header, formData, body)
  let scheme = call_574084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574084.url(scheme.get, call_574084.host, call_574084.base,
                         call_574084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574084, url, valid)

proc call*(call_574155: Call_PublicIPAddressesListVirtualMachineScaleSetPublicIPAddresses_573879;
          resourceGroupName: string; subscriptionId: string;
          virtualMachineScaleSetName: string; apiVersion: string = "2017-03-30"): Recallable =
  ## publicIPAddressesListVirtualMachineScaleSetPublicIPAddresses
  ## Gets information about all public IP addresses on a virtual machine scale set level.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  var path_574156 = newJObject()
  var query_574158 = newJObject()
  add(path_574156, "resourceGroupName", newJString(resourceGroupName))
  add(query_574158, "api-version", newJString(apiVersion))
  add(path_574156, "subscriptionId", newJString(subscriptionId))
  add(path_574156, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  result = call_574155.call(path_574156, query_574158, nil, nil, nil)

var publicIPAddressesListVirtualMachineScaleSetPublicIPAddresses* = Call_PublicIPAddressesListVirtualMachineScaleSetPublicIPAddresses_573879(
    name: "publicIPAddressesListVirtualMachineScaleSetPublicIPAddresses",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/publicipaddresses", validator: validate_PublicIPAddressesListVirtualMachineScaleSetPublicIPAddresses_573880,
    base: "",
    url: url_PublicIPAddressesListVirtualMachineScaleSetPublicIPAddresses_573881,
    schemes: {Scheme.Https})
type
  Call_PublicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses_574197 = ref object of OpenApiRestCall_573657
proc url_PublicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses_574199(
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
  assert "ipConfigurationName" in path,
        "`ipConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/virtualMachines/"),
               (kind: VariableSegment, value: "virtualmachineIndex"),
               (kind: ConstantSegment, value: "/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName"),
               (kind: ConstantSegment, value: "/ipconfigurations/"),
               (kind: VariableSegment, value: "ipConfigurationName"),
               (kind: ConstantSegment, value: "/publicipaddresses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses_574198(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets information about all public IP addresses in a virtual machine IP configuration in a virtual machine scale set.
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
  ##   ipConfigurationName: JString (required)
  ##                      : The IP configuration name.
  ##   networkInterfaceName: JString (required)
  ##                       : The network interface name.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the virtual machine scale set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574200 = path.getOrDefault("resourceGroupName")
  valid_574200 = validateParameter(valid_574200, JString, required = true,
                                 default = nil)
  if valid_574200 != nil:
    section.add "resourceGroupName", valid_574200
  var valid_574201 = path.getOrDefault("subscriptionId")
  valid_574201 = validateParameter(valid_574201, JString, required = true,
                                 default = nil)
  if valid_574201 != nil:
    section.add "subscriptionId", valid_574201
  var valid_574202 = path.getOrDefault("virtualmachineIndex")
  valid_574202 = validateParameter(valid_574202, JString, required = true,
                                 default = nil)
  if valid_574202 != nil:
    section.add "virtualmachineIndex", valid_574202
  var valid_574203 = path.getOrDefault("ipConfigurationName")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "ipConfigurationName", valid_574203
  var valid_574204 = path.getOrDefault("networkInterfaceName")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "networkInterfaceName", valid_574204
  var valid_574205 = path.getOrDefault("virtualMachineScaleSetName")
  valid_574205 = validateParameter(valid_574205, JString, required = true,
                                 default = nil)
  if valid_574205 != nil:
    section.add "virtualMachineScaleSetName", valid_574205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574206 = query.getOrDefault("api-version")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = newJString("2017-03-30"))
  if valid_574206 != nil:
    section.add "api-version", valid_574206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574207: Call_PublicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses_574197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about all public IP addresses in a virtual machine IP configuration in a virtual machine scale set.
  ## 
  let valid = call_574207.validator(path, query, header, formData, body)
  let scheme = call_574207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574207.url(scheme.get, call_574207.host, call_574207.base,
                         call_574207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574207, url, valid)

proc call*(call_574208: Call_PublicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses_574197;
          resourceGroupName: string; subscriptionId: string;
          virtualmachineIndex: string; ipConfigurationName: string;
          networkInterfaceName: string; virtualMachineScaleSetName: string;
          apiVersion: string = "2017-03-30"): Recallable =
  ## publicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses
  ## Gets information about all public IP addresses in a virtual machine IP configuration in a virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualmachineIndex: string (required)
  ##                      : The virtual machine index.
  ##   ipConfigurationName: string (required)
  ##                      : The IP configuration name.
  ##   networkInterfaceName: string (required)
  ##                       : The network interface name.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  var path_574209 = newJObject()
  var query_574210 = newJObject()
  add(path_574209, "resourceGroupName", newJString(resourceGroupName))
  add(query_574210, "api-version", newJString(apiVersion))
  add(path_574209, "subscriptionId", newJString(subscriptionId))
  add(path_574209, "virtualmachineIndex", newJString(virtualmachineIndex))
  add(path_574209, "ipConfigurationName", newJString(ipConfigurationName))
  add(path_574209, "networkInterfaceName", newJString(networkInterfaceName))
  add(path_574209, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  result = call_574208.call(path_574209, query_574210, nil, nil, nil)

var publicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses* = Call_PublicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses_574197(
    name: "publicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces/{networkInterfaceName}/ipconfigurations/{ipConfigurationName}/publicipaddresses", validator: validate_PublicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses_574198,
    base: "",
    url: url_PublicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses_574199,
    schemes: {Scheme.Https})
type
  Call_PublicIPAddressesGetVirtualMachineScaleSetPublicIPAddress_574211 = ref object of OpenApiRestCall_573657
proc url_PublicIPAddressesGetVirtualMachineScaleSetPublicIPAddress_574213(
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
  assert "ipConfigurationName" in path,
        "`ipConfigurationName` is a required path parameter"
  assert "publicIpAddressName" in path,
        "`publicIpAddressName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/virtualMachines/"),
               (kind: VariableSegment, value: "virtualmachineIndex"),
               (kind: ConstantSegment, value: "/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName"),
               (kind: ConstantSegment, value: "/ipconfigurations/"),
               (kind: VariableSegment, value: "ipConfigurationName"),
               (kind: ConstantSegment, value: "/publicipaddresses/"),
               (kind: VariableSegment, value: "publicIpAddressName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublicIPAddressesGetVirtualMachineScaleSetPublicIPAddress_574212(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the specified public IP address in a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   publicIpAddressName: JString (required)
  ##                      : The name of the public IP Address.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualmachineIndex: JString (required)
  ##                      : The virtual machine index.
  ##   ipConfigurationName: JString (required)
  ##                      : The name of the IP configuration.
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the virtual machine scale set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574215 = path.getOrDefault("resourceGroupName")
  valid_574215 = validateParameter(valid_574215, JString, required = true,
                                 default = nil)
  if valid_574215 != nil:
    section.add "resourceGroupName", valid_574215
  var valid_574216 = path.getOrDefault("publicIpAddressName")
  valid_574216 = validateParameter(valid_574216, JString, required = true,
                                 default = nil)
  if valid_574216 != nil:
    section.add "publicIpAddressName", valid_574216
  var valid_574217 = path.getOrDefault("subscriptionId")
  valid_574217 = validateParameter(valid_574217, JString, required = true,
                                 default = nil)
  if valid_574217 != nil:
    section.add "subscriptionId", valid_574217
  var valid_574218 = path.getOrDefault("virtualmachineIndex")
  valid_574218 = validateParameter(valid_574218, JString, required = true,
                                 default = nil)
  if valid_574218 != nil:
    section.add "virtualmachineIndex", valid_574218
  var valid_574219 = path.getOrDefault("ipConfigurationName")
  valid_574219 = validateParameter(valid_574219, JString, required = true,
                                 default = nil)
  if valid_574219 != nil:
    section.add "ipConfigurationName", valid_574219
  var valid_574220 = path.getOrDefault("networkInterfaceName")
  valid_574220 = validateParameter(valid_574220, JString, required = true,
                                 default = nil)
  if valid_574220 != nil:
    section.add "networkInterfaceName", valid_574220
  var valid_574221 = path.getOrDefault("virtualMachineScaleSetName")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "virtualMachineScaleSetName", valid_574221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574222 = query.getOrDefault("api-version")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = newJString("2017-03-30"))
  if valid_574222 != nil:
    section.add "api-version", valid_574222
  var valid_574223 = query.getOrDefault("$expand")
  valid_574223 = validateParameter(valid_574223, JString, required = false,
                                 default = nil)
  if valid_574223 != nil:
    section.add "$expand", valid_574223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574224: Call_PublicIPAddressesGetVirtualMachineScaleSetPublicIPAddress_574211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified public IP address in a virtual machine scale set.
  ## 
  let valid = call_574224.validator(path, query, header, formData, body)
  let scheme = call_574224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574224.url(scheme.get, call_574224.host, call_574224.base,
                         call_574224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574224, url, valid)

proc call*(call_574225: Call_PublicIPAddressesGetVirtualMachineScaleSetPublicIPAddress_574211;
          resourceGroupName: string; publicIpAddressName: string;
          subscriptionId: string; virtualmachineIndex: string;
          ipConfigurationName: string; networkInterfaceName: string;
          virtualMachineScaleSetName: string; apiVersion: string = "2017-03-30";
          Expand: string = ""): Recallable =
  ## publicIPAddressesGetVirtualMachineScaleSetPublicIPAddress
  ## Get the specified public IP address in a virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Expands referenced resources.
  ##   publicIpAddressName: string (required)
  ##                      : The name of the public IP Address.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualmachineIndex: string (required)
  ##                      : The virtual machine index.
  ##   ipConfigurationName: string (required)
  ##                      : The name of the IP configuration.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  var path_574226 = newJObject()
  var query_574227 = newJObject()
  add(path_574226, "resourceGroupName", newJString(resourceGroupName))
  add(query_574227, "api-version", newJString(apiVersion))
  add(query_574227, "$expand", newJString(Expand))
  add(path_574226, "publicIpAddressName", newJString(publicIpAddressName))
  add(path_574226, "subscriptionId", newJString(subscriptionId))
  add(path_574226, "virtualmachineIndex", newJString(virtualmachineIndex))
  add(path_574226, "ipConfigurationName", newJString(ipConfigurationName))
  add(path_574226, "networkInterfaceName", newJString(networkInterfaceName))
  add(path_574226, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  result = call_574225.call(path_574226, query_574227, nil, nil, nil)

var publicIPAddressesGetVirtualMachineScaleSetPublicIPAddress* = Call_PublicIPAddressesGetVirtualMachineScaleSetPublicIPAddress_574211(
    name: "publicIPAddressesGetVirtualMachineScaleSetPublicIPAddress",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces/{networkInterfaceName}/ipconfigurations/{ipConfigurationName}/publicipaddresses/{publicIpAddressName}", validator: validate_PublicIPAddressesGetVirtualMachineScaleSetPublicIPAddress_574212,
    base: "", url: url_PublicIPAddressesGetVirtualMachineScaleSetPublicIPAddress_574213,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
