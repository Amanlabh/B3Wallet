import { useSystemMethod } from "service/system"
import DisplayData from "./DisplayData"
import { Button } from "./ui/button"

interface CreateWalletProps {}

const CreateWallet: React.FC<CreateWalletProps> = ({}) => {
  const { call, data, error, loading } = useSystemMethod(
    "create_wallet_canister"
  )

  return (
    <div>
      <section>
        <h2>B3Wallet</h2>
        <Button isLoading={loading} onClick={() => call()}>
          Create Wallet
        </Button>
      </section>
      <DisplayData loading={loading} error={error} data={data} />
    </div>
  )
}

export default CreateWallet